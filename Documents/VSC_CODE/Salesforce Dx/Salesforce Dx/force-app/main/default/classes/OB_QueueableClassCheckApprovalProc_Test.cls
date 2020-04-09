/*
     * @author Roland Nieznanski
     * @date Creation 10/06/2019
     * @description Test class OB_QueueableClassCheckApprovalProc_Test for class OB_QueueableClassCheckApprovalProcesses.
*/
@isTest
private class OB_QueueableClassCheckApprovalProc_Test
{

    /*
         * @Author   :       Andrea Morittu
         * @Date     :       11-Jun-19
         * @Task     :       OB_QueueableClassCheckApprovalProc_Test for class OB_QueueableClassCheckApprovalProcesses.
    */
    private static void buildData( )
    {
        //NEXI Kinga Fornal<kinga.fornal@accenture.com>, 17/06/2019 Code Coverage Fix START
        Id bankRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( 'Bank' ).getRecordTypeId( );
        Account bank = new Account( Name = 'TEST',
                RecordTypeId = bankRecordId,
                OB_Employees_Number__c = 'Minore di 10',
                OB_VAT_Not_Present__c = true,
                OB_DescriptionVATNotPresent__c = 'description',
                NE__Fiscal_code__c = 'RSSMRA80A01F205X',
                OB_BypassValidation__c = true,
                OB_ABI__c = '05696',
                OB_Status__c = 'Active' );
        insert bank;

        OB_Bank_Profile__c bp = new OB_Bank_Profile__c( );
        bp.OB_Bank__c = bank.Id;
        bp.OB_Service_Type__c = 'Acquiring';
        bp.OB_Business_Model_POS__c = 'Bilaterale';
        bp.OB_Circuit__c = 'JCB';
        bp.OB_Other_Acquirer__c = 'Amex';
        bp.OB_Applicant_RAC_Code_SIA__c = 'Banca';
        bp.OB_Terminal_Id_Generator__c = 'Banca';
        bp.OB_Technical_component_invoicing__c = 'TecMarket(servizio fatturazione per conto terzi)';
        bp.OB_GT__c = 'Nexi';
        bp.OB_Processor__c = 'SIA SMAC';
        bp.OB_Bilateral_Pricing__c = 'SI';
        bp.OB_Sending_Contract_to_Nexi__c = 'SI';
        bp.OB_SME_Factory__c = 'SI';
        bp.OB_NeedBIO__c = true;
        insert bp;

        List <NE__Order__c> orders = new List<NE__Order__c>( );
        NE__Order_Header__c ordh = OB_TestDataFactory.getOrderHeader( );
        ordh.OB_ABI__c = '12345';
        ordh.OB_ProposerABI__c = bank.Id;
        ordh.OB_Main_Process__c = 'Maintenance';
        ordh.OB_StartApprovalProcess__c = false;
        insert ordh;
        //NEXI Kinga Fornal<kinga.fornal@accenture.com>, 17/06/2019 Code Coverage Fix STOP
        for ( Integer i = 0; i < 50; i++ )
        {
            NE__Order__c order = OB_TestDataFactory.getOrder( ordh );
            order.OB_ABI__c = '000' + i;
            order.OB_AdditionalDocumentationRequired__c = true;
            orders.add( order );
        }
        insert orders;
         OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest( );
        testLogRequest.OB_OrderId__c = orders[0].Id;  
        testLogRequest.RecordTypeId = Schema.SObjectType.OB_LogRequest__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.CONSISTENZART ).getRecordTypeId( );
        insert testLogRequest;
    }

    /*******************************************************************************
    Purpose:  Method check the OB_QueueableClassCheckApprovalProcesses - not Salesforce License User
    Returns: ---

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0      Kinga Fornal           17/06/2019          Created            ---
    1.1      Joanna Mielczarek      01/08/2019          Modified        NEXI-246 added core method
    ********************************************************************************/
    @isTest
    private static void testQueueableNonSalesforceUser( )
    {
        buildData( );

        Id parentId = [ select id, OB_ABI__c,OB_StartApprovalProcess__c from NE__Order_Header__c where OB_ABI__c LIKE '12345' ][ 0 ].Id;
        List<NE__Order__c> orders = [ SELECT Id, Name from NE__Order__c where Name like '%000%' ];
        OB_QueueableClassCheckApprovalProcesses updater = new OB_QueueableClassCheckApprovalProcesses( orders[ 0 ].Id );
        List<User> testUsers = [ SELECT Id FROM User WHERE Profile.UserLicense.Name != 'Salesforce' AND IsActive = true LIMIT 1 ];

        System.runAs( testUsers[ 0 ] )
        {
            Test.startTest( );
            System.enqueueJob( updater );
            Test.stopTest( );
        }
        System.assertEquals( 50, [ select count( ) from NE__Order__c where NE__Order_Header__c = :parentId ] );
    }

    /*******************************************************************************
    Purpose:  Method check the OB_QueueableClassCheckApprovalProcesses - Salesforce License User
    Returns: ---

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
     1.0      Kinga Fornal           17/06/2019         Created            ---
     1.1      Joanna Mielczarek      01/08/2019          Modified        NEXI-246 added core method
    ********************************************************************************/
    @isTest
    private static void testQueueableSalesforceUser( )
    {
        buildData( );

        Id parentId = [ select id, OB_ABI__c,OB_StartApprovalProcess__c from NE__Order_Header__c where OB_ABI__c LIKE '12345' ][ 0 ].Id;
        List<NE__Order__c> orders = [ SELECT Id, Name from NE__Order__c where Name like '%000%' ];
        OB_QueueableClassCheckApprovalProcesses updater = new OB_QueueableClassCheckApprovalProcesses( orders[ 0 ].Id );
        List<User> testUsers = [ SELECT Id FROM User WHERE Profile.UserLicense.Name = 'Salesforce' AND IsActive = true LIMIT 1 ];

        System.runAs( testUsers[ 0 ] )
        {
            Test.startTest( );
            System.enqueueJob( updater );
            Test.stopTest( );
        }
        System.assertEquals( 50, [ select count( ) from NE__Order__c where NE__Order_Header__c = :parentId ] );
    }

    /*******************************************************************************
    Purpose:  Method check the OB_QueueableClassCheckApprovalProcesses - Salesforce License User
    Returns: ---

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               ?               ?
    1.1        Joanna Mielczarek       31/07/2019       Created         NEXI-246 just increase cc
    ********************************************************************************/
    @isTest
    private static void testQueueableSalesforceUserTwo( )
    {
        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        testOrderHeader.OB_Sub_Process__c = OB_UtilityConstants.HEADER_SUBPROCESS_TERMINAOFFERTA;
        testOrderHeader.OB_Main_Process__c = 'Maintenance';
        testOrderHeader.OB_Gambling__c = false;
        testOrderHeader.OB_PO118_Ecommerce__c = false;
        testOrderHeader.OB_PO118_MOTO__c = false;
        testOrderHeader.OB_HotelCarRental__c = false;
        testOrderHeader.OB_PEP__c = false;
        testOrderHeader.OB_isBlackList__c = false;
        testOrderHeader.OB_isUCAMP__c = false;
        testOrderHeader.OB_PreAuth__c = false;
        testOrderHeader.OB_PreAuth__c = false;
        testOrderHeader.OB_StartApprovalProcess__c = false;
        insert testOrderHeader;
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        testOrder.OB_AdditionalDocumentationRequired__c = false;
        insert testOrder;
        NE__Product__c pProduct = OB_TestDataFactory.getProduct( );
        insert pProduct;
        NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        testOrderItem.NE__ProdId__c = pProduct.id;
        insert testOrderItem;
        OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest( );
        testLogRequest.OB_OrderId__c = testOrder.Id;
        testLogRequest.RecordTypeId = Schema.SObjectType.OB_LogRequest__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.CONSISTENZART ).getRecordTypeId( );
        insert testLogRequest;

        OB_QueueableClassCheckApprovalProcesses updater = new OB_QueueableClassCheckApprovalProcesses( testOrder.Id );
        User testUser = [ SELECT Id FROM User WHERE Profile.UserLicense.Name = 'Salesforce' AND IsActive = true LIMIT 1 ].get( 0 );

        System.runAs( testUser )
        {
            Test.startTest( );
            System.enqueueJob( updater );
            Test.stopTest( );
        }
        System.assertEquals( 1, [ SELECT Id FROM NE__Order__c ].size( ) );
    }
 @isTest
    private static void testQueueableSalesforceUserNotCheckAcq( )
    {
         Id bankRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( 'Bank' ).getRecordTypeId( );
         Account bank = new Account( Name = 'TEST',
                RecordTypeId = bankRecordId,
                OB_Employees_Number__c = 'Minore di 10',
                OB_VAT_Not_Present__c = true,
                OB_DescriptionVATNotPresent__c = 'description',
                NE__Fiscal_code__c = 'RSSMRA80A01F205X',
                OB_BypassValidation__c = true,
                OB_ABI__c = '05696',
                OB_Status__c = 'Active' );
        insert bank; 
        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        testOrderHeader.OB_Sub_Process__c = OB_UtilityConstants.HEADER_SUBPROCESS_OPERATIVA;
        testOrderHeader.OB_Main_Process__c = 'Maintenance';
        testOrderHeader.OB_Gambling__c = false;
        testOrderHeader.OB_PO118_Ecommerce__c = false;
        testOrderHeader.OB_PO118_MOTO__c = false;
        testOrderHeader.OB_HotelCarRental__c = false;
        testOrderHeader.OB_PEP__c = false;
        testOrderHeader.OB_isBlackList__c = false;
        testOrderHeader.OB_isUCAMP__c = false;
        testOrderHeader.OB_PreAuth__c = false;
        testOrderHeader.OB_PreAuth__c = false;
        testOrderHeader.OB_StartApprovalProcess__c = false;
        testOrderHeader.OB_ProposerABI__c = bank.Id;
        insert testOrderHeader;
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        testOrder.OB_AdditionalDocumentationRequired__c = false;
        insert testOrder;
        NE__Product__c pProduct = OB_TestDataFactory.getProduct( );
        insert pProduct;
        NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        testOrderItem.NE__ProdId__c = pProduct.id;
        insert testOrderItem;
        OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest( );
        testLogRequest.OB_OrderId__c = testOrder.Id;
        testLogRequest.RecordTypeId = Schema.SObjectType.OB_LogRequest__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.CONSISTENZART ).getRecordTypeId( );
        insert testLogRequest;
       //NEXI Kinga Fornal<kinga.fornal@accenture.com>, 17/06/2019 Code Coverage Fix START
       

        OB_Bank_Profile__c bp = new OB_Bank_Profile__c( );
        bp.OB_Bank__c = bank.Id;
        bp.OB_Service_Type__c = 'Acquiring';
        bp.OB_Business_Model_POS__c = 'Bilaterale';
        bp.OB_Circuit__c = 'JCB';
        bp.OB_Other_Acquirer__c = 'Amex';
        bp.OB_Applicant_RAC_Code_SIA__c = 'Banca';
        bp.OB_Terminal_Id_Generator__c = 'Banca';
        bp.OB_Technical_component_invoicing__c = 'TecMarket(servizio fatturazione per conto terzi)';
        bp.OB_GT__c = 'Nexi';
        bp.OB_Processor__c = 'SIA SMAC';
        bp.OB_Bilateral_Pricing__c = 'SI';
        bp.OB_Sending_Contract_to_Nexi__c = 'SI';
        bp.OB_SME_Factory__c = 'SI';
        bp.OB_NeedBIO__c = true;
        insert bp;

        OB_QueueableClassCheckApprovalProcesses updater = new OB_QueueableClassCheckApprovalProcesses( testOrder.Id );
        User testUser = [ SELECT Id FROM User WHERE Profile.UserLicense.Name = 'Salesforce' AND IsActive = true LIMIT 1 ].get( 0 );

        System.runAs( testUser )
        {
            Test.startTest( );
            System.enqueueJob( updater );
        // System.debug( OB_Utility.retrieveSpecialCategoryConfigurations(testOrderHeader.Id));
            Test.stopTest( );
        }
        System.assertEquals( 1, [ SELECT Id FROM NE__Order__c ].size( ) );
    }
    /*******************************************************************************
    Purpose:  Method prepares data for updateStartDatePricing()
    Params:   Boolean agreedChanges, String variationPOSPB, Id rootOrderItemRT
    Returns:  Id

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               ?               ?
    1.1         Joanna Mielczarek       31/07/2019      Created         NEXI-246 just increase cc
    ********************************************************************************/
    private static Id prepareDataForUpdateStartDatePricing( Boolean agreedChanges, String variationPOSPB, Id rootOrderItemRT )
    {
        // Simone Misani WN-617-15/10/2019 START
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.OB_AgreedChanges__c = agreedChanges;
        insert testOrder;

        NE__Product__c  prod =  OB_TestDataFactory.getProduct();
        prod.RecordTypeId = rootOrderItemRT;
        insert prod;

        NE__OrderItem__c rootOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        rootOrderItem.NE__ProdId__c = prod.id;
        insert rootOrderItem;

        NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        testOrderItem.OB_VariationPOSPB__c = variationPOSPB;
        testOrderItem.NE__Root_Order_Item__c = rootOrderItem.Id;
        testOrderItem.NE__Action__c = 'Change';
        insert testOrderItem;
        //// Simone Misani WN-617-15/10/2019 END
        return testOrder.Id;
    }

    /*******************************************************************************
    Purpose:  Method tests updateStartDatePricing - Vas record type and MIGLIORATIVA scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               ?               ?
    1.1         Joanna Mielczarek       31/07/2019      Created         NEXI-246 just increase cc
    ********************************************************************************/
    @isTest
    public static void updateStartDatePricingVasMIGLIORATIVA( )
    {
        Id rootOrderItemRT = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( 'Vas' ).getRecordTypeId( );// Simone Misani WN-617-15/10/2019
        OB_QueueableClassCheckApprovalProcesses.updateStartDatePricing( prepareDataForUpdateStartDatePricing( false, 'MIGLIORATIVA', rootOrderItemRT ) );

        List<NE__OrderItem__c> result = [ SELECT NE__StartDate__c FROM NE__OrderItem__c WHERE NE__Action__c = 'Change' ];
        System.assert( result.get( 0 ).NE__StartDate__c.isSameDay( DateTime.now( ).addDays( 1 ) ) );
    }

    /*******************************************************************************
    Purpose:  Method tests updateStartDatePricing - Vas record type and PEGGIORATIVA scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               ?               ?
    1.1         Joanna Mielczarek       31/07/2019      Created         NEXI-246 just increase cc
    ********************************************************************************/
    @isTest
    public static void updateStartDatePricingVasPEGGIORATIVA( )
    {
        Id rootOrderItemRT = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( 'Vas' ).getRecordTypeId( );// Simone Misani WN-617-15/10/2019
        OB_QueueableClassCheckApprovalProcesses.updateStartDatePricing( prepareDataForUpdateStartDatePricing( false, 'PEGGIORATIVA', rootOrderItemRT ) );

        List<NE__OrderItem__c> result = [ SELECT NE__StartDate__c FROM NE__OrderItem__c WHERE NE__Action__c = 'Change' ];
        System.assert( result.get( 0 ).NE__StartDate__c.isSameDay( DateTime.now( ).addDays( 70 ) ) );
    }

    /*******************************************************************************
    Purpose:  Method tests updateStartDatePricing - Pagobancomat record type and agreed changes = true scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               ?               ?
    1.1         Joanna Mielczarek       31/07/2019      Created         NEXI-246 just increase cc
    ********************************************************************************/
    @isTest
    public static void updateStartDatePricingPagobancomatAgreedChanges( )
    {
        Id rootOrderItemRT = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.PAGOBANCOMAT ).getRecordTypeId( );// Simone Misani WN-617-15/10/2019
        OB_QueueableClassCheckApprovalProcesses.updateStartDatePricing( prepareDataForUpdateStartDatePricing( true, '', rootOrderItemRT ) );

        List<NE__OrderItem__c> result = [ SELECT NE__StartDate__c FROM NE__OrderItem__c WHERE NE__Action__c = 'Change' ];
        System.assert( result.get( 0 ).NE__StartDate__c.isSameDay( DateTime.now( ).addDays( 1 ) ) );
    }

    /*******************************************************************************
    Purpose:  Method tests updateStartDatePricing - Pagobancomat record type and PEGGIORATIVA scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               ?               ?
    1.1         Joanna Mielczarek       31/07/2019      Created         NEXI-246 just increase cc
    ********************************************************************************/
    @isTest
    public static void updateStartDatePricingPagobancomatPEGGIORATIVA( )
    {
        Id rootOrderItemRT = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.PAGOBANCOMAT ).getRecordTypeId( );// Simone Misani WN-617-15/10/2019
        OB_QueueableClassCheckApprovalProcesses.isSetLessTwenty = true; // Roland Nieznanski <roland.nieznanski@accenture.com> 03/09/2019 variable used to controll test
        OB_QueueableClassCheckApprovalProcesses.updateStartDatePricing( prepareDataForUpdateStartDatePricing( false, 'PEGGIORATIVA', rootOrderItemRT ) );

        List<NE__OrderItem__c> result = [ SELECT NE__StartDate__c FROM NE__OrderItem__c WHERE NE__Action__c = 'Change' ];
        System.assert( result.get( 0 ).NE__StartDate__c != null );
    }

    /*******************************************************************************
    Purpose:  Method tests updateStartDateCommissionModel - pricing record type scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               ?               ?
    1.1         Joanna Mielczarek       31/07/2019      Created         NEXI-246 just increase cc
    ********************************************************************************/
    @isTest
    private static void updateStartDateCommissionModelPricing( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;

        NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        testOrderItem.RecordTypeId = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.PRICING ).getRecordTypeId( );
        testOrderItem.NE__Action__c = 'Add';
        insert testOrderItem;

        Test.startTest( );
        OB_QueueableClassCheckApprovalProcesses.updateStartDateCommissionModel( testOrder.Id );
        Test.stopTest( );

        List<NE__OrderItem__c> result = [ SELECT NE__StartDate__c FROM NE__OrderItem__c ];
        System.assert( result.get( 0 ).NE__StartDate__c.isSameDay( DateTime.now( ).addDays( 1 ) ) );
    }

    /*******************************************************************************
    Purpose:  Method tests updateStartDateCommissionModel - visa/mastercard product code scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               ?               ?
    1.1         Joanna Mielczarek       31/07/2019      Created         NEXI-246 just increase cc
    1.2         Joanna Mielczarek       20/08/2019      Modified        NEXI-261 changed assertion
    ********************************************************************************/
    @isTest
    private static void updateStartDateCommissionModelVisaMastercard( )
    {
        NE__Product__c testProduct = OB_TestDataFactory.getProduct( );
        testProduct.OB_Codice_sfdc__c = 'visamastercard';
        insert testProduct;

        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;

        NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        testOrderItem.NE__Root_Order_Item__c = null;
        testOrderItem.NE__ProdId__c = testProduct.Id;
        insert testOrderItem;

        Test.startTest( );
        OB_QueueableClassCheckApprovalProcesses.updateStartDateCommissionModel( testOrder.Id );
        Test.stopTest( );

        List<NE__OrderItem__c> result = [ SELECT OB_StartValidationDate__c FROM NE__OrderItem__c ];
        System.assert( result.get( 0 ).OB_StartValidationDate__c.isSameDay( Datetime.now( ).addDays( 1 ) ) );
    }

    /*******************************************************************************
    Purpose:  Method tests execute - operation setup

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       31/07/2019      Created         NEXI-314
    ********************************************************************************/
    @isTest
    private static void executeOperationSetup( )
    {
        Account bankAccount = OB_TestDataFactory.getBankAccount( );
        insert bankAccount;
        OB_Bank_Profile__c bankProfile = OB_TestDataFactory.getBankProfile( bankAccount );
        insert bankProfile;

        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        testOrderHeader.OB_Main_Process__c = OB_UtilityConstants.SETUP;
        testOrderHeader.OB_ProposerABI__c = bankAccount.Id;
        insert testOrderHeader;
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        insert testOrder;

        User operation = [ SELECT Id FROM User WHERE Profile.Name = :OB_UtilityConstants.OPERATION AND IsActive = true LIMIT 1 ].get( 0 );// Roland Nieznanski <roland.nieznanski@accenture.com> 03/10/2019 Add check for active user
        System.runAs( operation )
        {
            Test.startTest( );
            OB_QueueableClassCheckApprovalProcesses updater = new OB_QueueableClassCheckApprovalProcesses( testOrder.Id );
            System.enqueueJob( updater );
            Test.stopTest( );

            List<NE__Order__c> resultOrder = [ SELECT OB_FulfilmentStatus__c FROM NE__Order__c ];
            System.assertEquals( OB_UtilityConstants.FULFILMENTSTATUS_TOAPPROVE, resultOrder.get( 0 ).OB_FulfilmentStatus__c );
            List<NE__Order_Header__c> resultOrderHeader = [ SELECT OB_FulfilmentStatus__c FROM NE__Order_Header__c ];
            System.assertEquals( OB_UtilityConstants.FULFILMENTSTATUS_PENDING, resultOrderHeader.get( 0 ).OB_FulfilmentStatus__c );
        }
    }
}