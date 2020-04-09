@isTest
public class OB_OrderTriggerHandler_Test 
{

    /*******************************************************************************
    Purpose:  Method prepares data to test OB_OrderTriggerHandler methods
    Parameters: Boolean afterPricing, Boolean afterBIO, NE__Order__c oldOrder, Id productRecordTypeId
    Returns: NE__Order__c

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       21/05/2019      Created         NEXI-46
    ********************************************************************************/
    private static NE__Order__c prepareData( Boolean afterPricing, Boolean afterBIO, NE__Order__c oldOrder, Id productRecordTypeId )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;

        Account bankAccount = OB_TestDataFactory.getAccount( );
        bankAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName( ).get( 'Bank' ).getRecordTypeId( );
        insert bankAccount;

        Contact testContact = OB_TestDataFactory.getContact( testAccount );
        testContact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName( ).get( 'Esecutore' ).getRecordTypeId( );
        testContact.OB_Bank__c = bankAccount.Id;
        insert testContact;

        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        testOrderHeader.OB_Main_Process__c = OB_UtilityConstants.MAINTENANCE;
        testOrderHeader.OB_StartApprovalProcess__c = false;
        testOrderHeader.OB_Sub_Process__c = 'variazione economica';
        insert testOrderHeader;

        NE__Order__c testOrder = oldOrder;
        oldOrder.NE__Order_Header__c = testOrderHeader.Id;

        if ( afterPricing )
        {
            testOrder.OB_AgreedChanges__c = false;
            testOrder.OB_ApprovalType__c = OB_UtilityConstants.APPROV_TYPE_PRICING;
            insert  testOrder;

            NE__Product__c testProduct_Parent = new NE__Product__c( );
            testProduct_Parent.RecordTypeId = productRecordTypeId;
            insert testProduct_Parent;

            NE__Product__c testProduct = new NE__Product__c( );
            testProduct.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName( ).get( 'Pricing' ).getRecordTypeId( );
            insert testProduct;

            NE__OrderItem__c testOrderItem_Parent = OB_TestDataFactory.getOrderItem( testOrder.Id );
            testOrderItem_Parent.NE__OrderId__c = testOrder.Id;
            testOrderItem_Parent.NE__ProdId__c = testProduct_Parent.Id;
            testOrderItem_Parent.NE__Action__c = 'Change';
            insert testOrderItem_Parent;

            NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
            testOrderItem.NE__OrderId__c = testOrder.Id;
            testOrderItem.NE__ProdId__c = testProduct.Id;
            testOrderItem.NE__Parent_Order_Item__c = testOrderItem_Parent.Id;
            testOrderItem.NE__Action__c = 'Change';
            insert testOrderItem;
        }
        else if ( afterBIO )
        {
            testOrder.NE__AccountId__c = testAccount.Id;
            testOrder.OB_ABI__c = bankAccount.OB_ABI__c;
            insert testOrder;

            OB_LogRequest__c testLogRequest = new OB_LogRequest__c( );
            testLogRequest.OB_OrderId__c = testOrder.Id;
            testLogRequest.OB_Status__c = OB_UtilityConstants.BOZZA;
            insert testLogRequest;
        }

        return testOrder;
    }

    /*******************************************************************************
    Purpose: Method tests creating LogRequest with trigger after update Order - POS Order Item - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       21/05/2019      Created         NEXI-46
    ********************************************************************************/
    @isTest static void createLogRequestAfterPricingOrderItemPOSSuccess( )
    {
        NE__Order__c oldOrder = new NE__Order__c( );
        Id productRecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName( ).get( 'Terminali' ).getRecordTypeId( );

        NE__Order__c testOrder = OB_OrderTriggerHandler_Test.prepareData( true, false, oldOrder, productRecordTypeId);
        testOrder.OB_BankApprovalStatus__c = OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_RIGETTATO;
        //giovanni spinelli 21/08/2019 start
        testOrder.OB_ReceiptHeader__c = 'test';
        testOrder.OB_ShopSign__c = 'test';
        //giovanni spinelli 21/08/2019 end
        update testOrder;

        List<OB_LogRequest__c> testLogRequests = [ SELECT Id FROM OB_LogRequest__c WHERE OB_OrderId__c = :testOrder.Id ];

        System.assertEquals( 1, testLogRequests.size( ) );
    }

    /*******************************************************************************
    Purpose: Method tests creating LogRequest with trigger after update Order - Acquiring Order Item - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       21/05/2019      Created         NEXI-46
    ********************************************************************************/
    @isTest static void createLogRequestAfterPricingOrderItemACQSuccess( )
    {
        NE__Order__c oldOrder = new NE__Order__c( );
        Id productRecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName( ).get( 'Acquiring' ).getRecordTypeId( );

        NE__Order__c testOrder = OB_OrderTriggerHandler_Test.prepareData( true, false, oldOrder, productRecordTypeId );
        testOrder.OB_BankApprovalStatus__c = OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_RIGETTATO;
        update testOrder;

        List<OB_LogRequest__c> testLogRequests = [ SELECT Id FROM OB_LogRequest__c WHERE OB_OrderId__c = :testOrder.Id ];

        System.assertEquals( 1, testLogRequests.size( ) );
    }

    /*******************************************************************************
    Purpose: Method tests creating LogRequest with trigger after update Order -
             existing log request with the same OrderId as updated - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       21/05/2019      Created         NEXI-46
    ********************************************************************************/
    @isTest static void createLogRequestAfterPricingExistingLogRequest( )
    {
        NE__Order__c oldOrder = new NE__Order__c( );
        Id productRecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName( ).get( 'Terminali' ).getRecordTypeId( );

        NE__Order__c testOrder = OB_OrderTriggerHandler_Test.prepareData( true, false, oldOrder, productRecordTypeId );

        OB_LogRequest__c testLogRequest = new OB_LogRequest__c( );
        testLogRequest.OB_OrderId__c = testOrder.Id;
        insert testLogRequest;

        testOrder.OB_BankApprovalStatus__c = OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_RIGETTATO;
        update testOrder;

        List<OB_LogRequest__c> testLogRequests = [ SELECT Id FROM OB_LogRequest__c WHERE OB_OrderId__c = :testOrder.Id ];

        System.assertEquals( 1, testLogRequests.size( ) );
    }

    /*******************************************************************************
    Purpose: Method tests creating LogRequest with trigger after update Order - Order doesn't meet conditions - failed scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       21/05/2019      Created         NEXI-46
    ********************************************************************************/
    @isTest static void createLogRequestAfterPricingFailed( )
    {
        NE__Order__c oldOrder = new NE__Order__c( );
        Id productRecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName( ).get( 'Service' ).getRecordTypeId( );

        NE__Order__c testOrder = OB_OrderTriggerHandler_Test.prepareData( true, false, oldOrder, productRecordTypeId );

        List<OB_LogRequest__c> testLogRequests = [ SELECT Id FROM OB_LogRequest__c WHERE OB_OrderId__c = :testOrder.Id ];

        System.assertEquals( 0, testLogRequests.size( ) );
    }

    /*******************************************************************************
    Purpose: Method tests creating LogRequest with trigger after update Order - bank approval status is 'Approvato'
             - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       21/05/2019      Created         NEXI-46
    ********************************************************************************/
    @isTest static void changeLogRequestStatusAfterBioApprovatoBankStatus( )
    {
        NE__Order__c oldOrder = new NE__Order__c(
                OB_ApprovalType__c = OB_UtilityConstants.APPROV_TYPE_BIO,
                OB_BankApprovalStatus__c = OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_APPROVATO,
                OB_ApprovalBIO__c = false );

        NE__Order__c testOrder = OB_OrderTriggerHandler_Test.prepareData( false, true, oldOrder, null );
        testOrder.OB_ApprovalType__c = OB_UtilityConstants.APPROV_TYPE_BIO;
        update testOrder;

        List<OB_LogRequest__c> testLogRequests = [ SELECT Id, OB_Status__c FROM OB_LogRequest__c WHERE OB_OrderId__c = :testOrder.Id ];

        //System.assertEquals( OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT, testLogRequests.get( 0 ).OB_Status__c );
    }

    /*******************************************************************************
    Purpose: Method tests creating LogRequest with trigger after update Order - bank approval status is 'Rigettato'
             - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       21/05/2019      Created         NEXI-46
    ********************************************************************************/
    @isTest static void changeLogRequestStatusAfterBioRigettatoBankStatus( )
    {
        NE__Order__c oldOrder = new NE__Order__c(
                OB_ApprovalType__c = OB_UtilityConstants.APPROV_TYPE_BIO,
                OB_BankApprovalStatus__c = OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_APPROVATO,
                OB_ApprovalBIO__c = false );

        NE__Order__c testOrder = OB_OrderTriggerHandler_Test.prepareData( false, true, oldOrder, null );
        testOrder.OB_ApprovalType__c = OB_UtilityConstants.APPROV_TYPE_BIO;
        testOrder.OB_BankApprovalStatus__c = OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_RIGETTATO;
        update testOrder;

        List<OB_LogRequest__c> testLogRequests = [ SELECT Id, OB_Status__c FROM OB_LogRequest__c WHERE OB_OrderId__c = :testOrder.Id ];

        System.assertEquals( OB_UtilityConstants.INATTESA, testLogRequests.get( 0 ).OB_Status__c );
    }

    /*******************************************************************************
    Purpose: Method tests creating LogRequest with trigger after update Order - bank approval status is 'Rigettato' in old map
             - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       21/05/2019      Created         NEXI-46
    ********************************************************************************/
    @isTest static void changeLogRequestStatusAfterBioRigettatoBankStatusFromOldMap( )
    {
        NE__Order__c oldOrder = new NE__Order__c(
                OB_ApprovalType__c = OB_UtilityConstants.APPROV_TYPE_BIO,
                OB_BankApprovalStatus__c = OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_RIGETTATO,
                OB_ApprovalBIO__c = false );

        NE__Order__c testOrder = OB_OrderTriggerHandler_Test.prepareData( false, true, oldOrder, null );
        testOrder.OB_ApprovalBIO__c = true;
        testOrder.OB_ApprovalType__c = OB_UtilityConstants.APPROV_TYPE_BIO;
        testOrder.OB_BankApprovalStatus__c = OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_APPROVATO;
        update testOrder;

        List<OB_LogRequest__c> testLogRequests = [ SELECT Id, OB_Status__c FROM OB_LogRequest__c WHERE OB_OrderId__c = :testOrder.Id ];

        //System.assertEquals( OB_UtilityConstants.CONFERMATO, testLogRequests.get( 0 ).OB_Status__c );
    }
    
    /*******************************************************************************
    Purpose:  Method tests updating fulfilment status of OrderHeader after updating order's one - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       21/05/2019      Created         NEXI-46
    ********************************************************************************/
    @isTest static void fulfilmentStatusAfterUpdateTestSuccess( )
    {
        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        insert testOrderHeader;

        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.ORDERS_STATUS_PENDING; // <daniele.gandini@ccenture.com> - 02/07/2019 - WN-9
        insert testOrder;

        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_TOAPPROVE;
        update testOrder;

        List<NE__Order_Header__c> testOHs =
        [
                SELECT Id, OB_FulfilmentStatus__c
                FROM NE__Order_Header__c
                WHERE Id = :testOrderHeader.Id
        ];
        System.assertEquals( OB_UtilityConstants.FULFILMENTSTATUS_TOAPPROVE, testOHs.get( 0 ).OB_FulfilmentStatus__c );
    }

    /*******************************************************************************
    Purpose:  Method tests updating fulfilment status of OrderHeader after updating order's one - failed scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       21/05/2019      Created         NEXI-46
    ********************************************************************************/
    @isTest static void fulfilmentStatusAfterUpdateTestFailed( )
    {
        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        insert testOrderHeader;

        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_TOAPPROVE;
        insert testOrder;

        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_TOAPPROVE;
        update testOrder;

        List<NE__Order_Header__c> testOHs =
        [
                SELECT Id, NE__Order_Header__c.OB_FulfilmentStatus__c
                FROM NE__Order_Header__c
                WHERE Id = :testOrderHeader.Id
        ];
        System.assertNotEquals( OB_UtilityConstants.FULFILMENTSTATUS_TOAPPROVE, testOHs.get( 0 ).OB_FulfilmentStatus__c );
    }

    /*******************************************************************************
    Purpose:  Method tests setting fields (status and timestamp) of NE__Order__c -
              OB_Bank_OrderStatus__c - Practice Fulfilled Partially
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien          21/05/2019      Created         NEXI-46
    ********************************************************************************/
    @isTest
    static void setOrderStatusOrderFulfilledOrPartiallyFulfilledFulfilledScenarioTest( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;

        List<NE__OrderItem__c> orderItemsList = new List<NE__OrderItem__c>( );
        for ( integer i = 0; i < 3; i++ )
        {
            NE__OrderItem__c oOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
            oOrderItem.RecordTypeId =
            [
                    SELECT Id
                    FROM RecordType
                    WHERE DeveloperName = 'Terminali'
                    AND sObjectType = 'NE__OrderItem__c'
                    AND Name = :OB_UtilityConstants.POS_RT
                    LIMIT 1
            ].Id;
            oOrderItem.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
            orderItemsList.add( oOrderItem );
        }
        insert orderItemsList;

        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
        update testOrder;

        List<NE__Order__c> testOrders = [ SELECT Id, OB_Bank_OrderStatus__c FROM NE__Order__c WHERE Id = :testOrder.Id ];

        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_ORDER_FULFILLED, testOrders.get( 0 ).OB_Bank_OrderStatus__c );
    }

}