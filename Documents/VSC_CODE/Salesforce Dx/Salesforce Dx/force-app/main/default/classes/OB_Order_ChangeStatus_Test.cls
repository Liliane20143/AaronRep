/*****************************************************************
Name: OB_Order_ChangeStatus_Test 
Copyright © 2016 ITC
============================================================
Purpose:  Class tests OB_Order_ChangeStatus methods

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0      Marta Stempien          24/04/2019         Created           NEXI-20
********************************************************************************/
@isTest
public with sharing class OB_Order_ChangeStatus_Test
{
    /*******************************************************************************
	Purpose:  Method tests setting fields (status and timestamp) of NE__Order__c
	          - 'Draft' - success scenario - Draft after rejection of the pricing

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Joanna Mielczarek       29/04/2019      Created         NEXI-20_order_status_handleLogic
 	********************************************************************************/
    @isTest static void setOrderStatusDraftSuccess( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_DRAFT;
        testOrder.OB_BankApprovalStatus__c = OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_APPROVATO;
        testOrder.OB_ApprovalType__c = OB_UtilityConstants.PRICING;
        testOrder.OB_PricingApproval__c = true;
        insert testOrder;

        OB_Order_ChangeStatus.setOrderStatusDraft( testOrder );
        List<NE__Order__c> testOrders = [ SELECT Id, OB_Bank_OrderStatus__c FROM NE__Order__c WHERE Id = :testOrder.Id ];

        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_DRAFT, testOrders.get( 0 ).OB_Bank_OrderStatus__c );
    }

    /*******************************************************************************
    Purpose:  Method tests updating fulfilment status of OrderHeader after updating order's one - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       26/04/2019      Created         NEXI-20_order_status_handleLogic
    ********************************************************************************/
    @isTest static void fulfilmentStatusAfterUpdateTestSuccess( )
    {
        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        insert testOrderHeader;

        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        insert testOrder;

        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_TOAPPROVE;
        update testOrder;

        List<NE__Order_Header__c> testOHs =
        [
                SELECT Id, NE__Order_Header__c.OB_FulfilmentStatus__c
                FROM NE__Order_Header__c
                WHERE Id = :testOrderHeader.Id
        ];
        System.assertEquals( OB_UtilityConstants.FULFILMENTSTATUS_DRAFT, testOHs.get( 0 ).OB_FulfilmentStatus__c ); //  Micol Ferrari <micol.ferrari@accenture.com>, 18/07/2019 

    }

    /*******************************************************************************
    Purpose:  Method tests updating fulfilment status of OrderHeader after updating order's one - failed scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       26/04/2019      Created         NEXI-20_order_status_handleLogic
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
    Purpose:  Method tests setting field (status) of NE__Order__c - 'Draft - approved pricing' - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       25/04/2019      Created         NEXI-20_order_status_handleLogic
    ********************************************************************************/
    @isTest static void setOrderStatusDraftApprovedPricingSuccess( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.OB_PricingApproval__c = true;
        testOrder.OB_BankApprovalStatus__c = OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_INAPPROVAZIONE;
        testOrder.OB_ApprovalType__c = OB_UtilityConstants.PRICING;
        insert testOrder;

        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_DRAFT;
        testOrder.OB_BankApprovalStatus__c = OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_APPROVATO;
        testOrder.OB_ApprovalType__c = OB_UtilityConstants.PRICING;
        update testOrder;

        List<NE__Order__c> testOrders =
        [
                SELECT Id, OB_Bank_OrderStatus__c
                FROM NE__Order__c
                WHERE Id = :testOrder.Id
        ];

        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_APPROVED_PRICING, testOrders.get( 0 ).OB_Bank_OrderStatus__c );
    }

    /*******************************************************************************
	Purpose:  Method tests setting fields (status and timestamp) of NE__Order__c
	          - 'Draft - approved pricing' - failed scenario with wrong data

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Joanna Mielczarek       26/04/2019      Created         NEXI-20_order_status_handleLogic
 	********************************************************************************/
    @isTest static void setOrderStatusDraftApprovedPricingFailed( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;

        testOrder.OB_ApprovalType__c = OB_UtilityConstants.BIO;
        update testOrder;

        List<NE__Order__c> testOrders =
        [
                SELECT Id
                FROM NE__Order__c
                WHERE OB_Bank_OrderStatus__c = :OB_Order_ChangeStatus.ORDER_STATUS_APPROVED_PRICING
        ];

        System.assertEquals( 0, testOrders.size( ) );
    }

    /*******************************************************************************
	Purpose:  Method tests setting fields (status and timestamp) of NE__Order__c - 'Draft - rejected pricing' - success scenario

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Joanna Mielczarek       25/04/2019      Created         NEXI-20_order_status_handleLogic
 	********************************************************************************/
    @isTest static void setOrderStatusDraftRejectedPricingSuccess( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.OB_PricingApproval__c = false;
        insert testOrder;

        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_DRAFT;
        testOrder.OB_BankApprovalStatus__c = OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_RIGETTATO;
        testOrder.OB_ApprovalType__c = OB_UtilityConstants.PRICING;
        update testOrder;

        List<NE__Order__c> testOrders =
        [
                SELECT Id, OB_Bank_OrderStatus__c
                FROM NE__Order__c
                WHERE Id = :testOrder.Id
        ];

        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_DRAFT_REJECTED_PRICING, testOrders.get( 0 ).OB_Bank_OrderStatus__c );
    }

    /*******************************************************************************
	Purpose:  Method tests setting fields (status and timestamp) of NE__Order__c - 'Draft - rejected pricing' - failed scenarioo

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Joanna Mielczarek       26/04/2019      Created         NEXI-20_order_status_handleLogic
 	********************************************************************************/
    @isTest static void setOrderStatusDraftRejectedPricingFailed( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;

        testOrder.OB_ApprovalType__c = OB_UtilityConstants.BIO;
        update testOrder;

        List<NE__Order__c> testOrders =
        [
                SELECT Id
                FROM NE__Order__c
                WHERE OB_Bank_OrderStatus__c = :OB_Order_ChangeStatus.ORDER_STATUS_DRAFT_REJECTED_PRICING
        ];

        System.assertEquals( 0, testOrders.size( ) );
    }

    /*******************************************************************************
	Purpose:  Method tests setting fields (status and timestamp) of NE__Order__c - 'Economic conditions approval' - success scenario

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Joanna Mielczarek       25/04/2019      Created         NEXI-20_order_status_handleLogic
 	********************************************************************************/
    @isTest static void setOrderStatusEconomicConditionsApprovalSuccess( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.OB_ApprovalType__c = OB_UtilityConstants.BIO;
        insert testOrder;

        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_TOAPPROVE;
        testOrder.OB_BankApprovalStatus__c = OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_INAPPROVAZIONE;
        testOrder.OB_ApprovalType__c = OB_UtilityConstants.PRICING;
        update testOrder;

        List<NE__Order__c> testOrders =
        [
                SELECT Id, OB_Bank_OrderStatus__c
                FROM NE__Order__c
                WHERE Id = :testOrder.Id
        ];

        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_ECONONOMIC_CONDITIONS_APPROVAL, testOrders.get( 0 ).OB_Bank_OrderStatus__c );
    }

    /*******************************************************************************
	Purpose:  Method tests setting fields (status and timestamp) of NE__Order__c - 'Economic conditions approval' - failed scenario

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Joanna Mielczarek       26/04/2019      Created         NEXI-20_order_status_handleLogic
 	********************************************************************************/
    @isTest static void setOrderStatusEconomicConditionsApprovalFailed( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;

        testOrder.OB_ApprovalType__c = OB_UtilityConstants.BIO;
        update testOrder;

        List<NE__Order__c> testOrders =
        [
                SELECT Id
                FROM NE__Order__c
                WHERE OB_Nexi_OrderStatus__c = :OB_Order_ChangeStatus.ORDER_STATUS_ECONONOMIC_CONDITIONS_APPROVAL
        ];

        System.assertEquals( 0, testOrders.size( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests setting fields (status and timestamp) of NE__Order__c - 'Draft - incomplete order' - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       16/05/2019      Created         NEXI-46
    ********************************************************************************/
    @isTest static void setOrderStatusDraftIncompleteOrderSuccess( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;

        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_PENDING;
        testOrder.OB_BankApprovalStatus__c = OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_RIGETTATO;
        testOrder.OB_ApprovalType__c = OB_UtilityConstants.BIO;
        testOrder.OB_ApprovalBIO__c = false;
        update testOrder;

        List<NE__Order__c> testOrders =
        [
                SELECT Id
                FROM NE__Order__c
                WHERE OB_Nexi_OrderStatus__c = :OB_Order_ChangeStatus.ORDER_STATUS_DRAFT_INCOMPLETE_ORDER
        ];

        System.assertEquals( 1, testOrders.size( ) );
    }

    /*******************************************************************************
	Purpose:  Method tests setting fields (status and timestamp) of NE__Order__c - 'Draft - incomplete order' - failed scenario

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Joanna Mielczarek       16/05/2019      Created         NEXI-46
 	********************************************************************************/
    @isTest static void setOrderStatusDraftIncompleteOrderFailed( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;

        testOrder.OB_ApprovalBIO__c = false;
        update testOrder;

        List<NE__Order__c> testOrders =
        [
                SELECT Id
                FROM NE__Order__c
                WHERE OB_Nexi_OrderStatus__c = :OB_Order_ChangeStatus.ORDER_STATUS_DRAFT_INCOMPLETE_ORDER
        ];

        System.assertEquals( 0, testOrders.size( ) );
    }

    /*******************************************************************************
	Purpose:  Method tests setting fields (status and timestamp) of NE__Order__c - Bank Verification - success scenario

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Joanna Mielczarek       25/04/2019      Created         NEXI-20_order_status_handleLogic
 	********************************************************************************/
    @isTest static void setOrderStatus_BankVerificationSuccess( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.OB_ApprovalType__c = OB_UtilityConstants.PRICING;
        insert testOrder;

        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_TOAPPROVE;
        testOrder.OB_BankApprovalStatus__c = OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_INAPPROVAZIONE;
        testOrder.OB_ApprovalType__c = OB_UtilityConstants.BIO;
        update testOrder;

        List<NE__Order__c> testOrders =
        [
                SELECT Id, OB_Bank_OrderStatus__c
                FROM NE__Order__c
                WHERE Id = :testOrder.Id
        ];

        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_BANK_VERIFICATION, testOrders.get( 0 ).OB_Bank_OrderStatus__c );
    }

    /*******************************************************************************
	Purpose:  Method tests setting fields (status and timestamp) of NE__Order__c - In Bank Verification - failed scenario

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Joanna Mielczarek       26/04/2019      Created         NEXI-20_order_status_handleLogic
 	********************************************************************************/
    @isTest static void setOrderStatusBankVerificationFailed( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;

        testOrder.OB_ApprovalType__c = OB_UtilityConstants.PRICING;
        update testOrder;

        List<NE__Order__c> testOrders =
        [
                SELECT Id
                FROM NE__Order__c
                WHERE OB_Nexi_OrderStatus__c = :OB_Order_ChangeStatus.ORDER_STATUS_BANK_VERIFICATION
        ];

        System.assertEquals( 0, testOrders.size( ) );
    }

    /*******************************************************************************
	Purpose:  Method tests setting fields (status and timestamp) of NE__Order__c - Order Cancelled - success scenario

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Joanna Mielczarek       06/05/2019      Created         NEXI-20_order_status_handleLogic
 	********************************************************************************/
    @isTest static void setOrderStatusOrderCancelledSuccess( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.OB_CancelledByBank__c = true;
        insert testOrder;

        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_CANCELLED;
        update testOrder;

        List<NE__Order__c> testOrders =
        [
                SELECT Id, OB_Bank_OrderStatus__c
                FROM NE__Order__c
                WHERE Id = :testOrder.Id
        ];

        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_ORDER_CANCELLED, testOrders.get( 0 ).OB_Bank_OrderStatus__c );
    }

    /*******************************************************************************
	Purpose:  Method tests setting fields (status and timestamp) of NE__Order__c - Order Cancelled - failed scenario

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Joanna Mielczarek       06/05/2019      Created         NEXI-20_order_status_handleLogic
 	********************************************************************************/
    @isTest static void setOrderStatusOrderCancelledFailed( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;

        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_CANCELLED;
        testOrder.OB_CancelledByBank__c = false;
        update testOrder;

        List<NE__Order__c> testOrders =
        [
                SELECT Id
                FROM NE__Order__c
                WHERE OB_Nexi_OrderStatus__c = :OB_Order_ChangeStatus.ORDER_STATUS_ORDER_CANCELLED
        ];

        System.assertEquals( 0, testOrders.size( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests setting fields (status and timestamp) of NE__Order__c -
       OB_Bank_OrderStatus__c - Practice Fulfilled Partially
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0       Marta Stempien       25/04/2019      Created         AF-Funnel-v3.0_status_logic_6.1
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

    /*******************************************************************************
    Purpose:  Method tests setting fields (status and timestamp) of NE__Order__c -
       OB_Bank_OrderStatus__c - Practice Fulfilled Partially

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0    Marta Stempien          26/04/2019        Created         AF-Funnel-v3.0_status_logic_6.1
   ********************************************************************************/
    @isTest
    static void setOrderStatusOrderFulfilledOrPartiallyFulfilledFulfilledPartiallyScenarioTest( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;

        List<NE__OrderItem__c> orderItemsList = new List<NE__OrderItem__c>( );
        for ( integer i = 0; i < 3; i++ )
        {
            NE__OrderItem__c oOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
            oOrderItem.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
            oOrderItem.RecordTypeId =
            [
                    SELECT Id
                    FROM RecordType
                    WHERE DeveloperName = 'Terminali'
                    AND sObjectType = 'NE__OrderItem__c'
                    AND Name = :OB_UtilityConstants.POS_RT
                    LIMIT 1
            ].Id;
            orderItemsList.add( oOrderItem );
        }
        NE__OrderItem__c cancelledOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        cancelledOrderItem.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_CANCELLED;
        orderItemsList.add( cancelledOrderItem );
        insert orderItemsList;

        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
        update testOrder;

        List<NE__Order__c> testOrders = [ SELECT Id, OB_Bank_OrderStatus__c FROM NE__Order__c WHERE Id = :testOrder.Id ];
        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_ORDER_FULFILLED_PARTIALLY, testOrders.get( 0 ).OB_Bank_OrderStatus__c );
    }

    /*******************************************************************************
    Purpose:  Method tests setOrderStatus_PracticeFulfilledOrPartiallyFulfilled method
        for the OrderItem status change for Installed

    History
    --------
    VERSION        AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien          26/04/2019        Created     AF-Funnel-v3.0_status_logic_6.1
    ********************************************************************************/
    @isTest
    static void setOrderStatusOrderFulfilledOrPartiallyFulfilledTerminaliOrderItemCompleteStatusTest( )
    {
        NE__Order__c order = OB_TestDataFactory.getOrder( );
        insert order;
        List<NE__OrderItem__c> orderItemsList = new List<NE__OrderItem__c>( );
        for ( integer i = 0; i < 3; i++ )
        {
            NE__OrderItem__c orderItem = OB_TestDataFactory.getOrderItem( order.Id );
            orderItem.RecordTypeId =
            [
                    SELECT Id
                    FROM RecordType
                    WHERE sObjectType = 'NE__OrderItem__c'
                    AND Name = :OB_UtilityConstants.POS_RT
                    LIMIT 1
            ].id;
            orderItem.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
            orderItemsList.add( orderItem );
        }
        insert orderItemsList;
        order.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
        update order;
        List<NE__OrderItem__c> orderItems = [ SELECT Id, OB_Nexi_OrderItemStatus__c FROM NE__OrderItem__c WHERE Id = :orderItemsList.get( 0 ).id ];
        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_INSTALLED, orderItems.get( 0 ).OB_Nexi_OrderItemStatus__c );
    }

    /*******************************************************************************
    Purpose:  Method tests setOrderStatus_PracticeFulfilledOrPartiallyFulfilled method
       for the OrderItem status change for Declined

    History
    --------
    VERSION        AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien          26/04/2019        Created     AF-Funnel-v3.0_status_logic_6.1
    ********************************************************************************/
    @isTest
    static void setOrderStatusOrderFulfilledOrPartiallyFulfilledTerminaliOrderItemCancelledStatusTest( )
    {
        NE__Order__c order = OB_TestDataFactory.getOrder( );
        insert order;
        List<NE__OrderItem__c> orderItemsList = new List<NE__OrderItem__c>( );
        for ( integer i = 0; i < 3; i++ )
        {
            NE__OrderItem__c orderItem = OB_TestDataFactory.getOrderItem( order.Id );
            orderItem.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
            orderItem.RecordTypeId =
            [
                    SELECT Id
                    FROM RecordType
                    WHERE sObjectType = 'NE__OrderItem__c'
                    AND Name = :OB_UtilityConstants.POS_RT
                    LIMIT 1
            ].id;
            orderItemsList.add( orderItem );
        }
        NE__OrderItem__c cancelledOrderItem = OB_TestDataFactory.getOrderItem( order.Id );
        cancelledOrderItem.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_CANCELLED;
        cancelledOrderItem.RecordTypeId =
        [
                SELECT Id
                FROM RecordType
                WHERE sObjectType = 'NE__OrderItem__c'
                AND Name = :OB_UtilityConstants.POS_RT
                LIMIT 1
        ].id;
        orderItemsList.add( cancelledOrderItem );
        insert orderItemsList;
        order.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
        update order;
        List<NE__OrderItem__c> orderCompletedItems =
        [
                SELECT Id, OB_Nexi_OrderItemStatus__c
                FROM NE__OrderItem__c
                WHERE Id = :orderItemsList.get( 0 ).id
        ];
        List<NE__OrderItem__c> orderCancelledItems =
        [
                SELECT Id, OB_Nexi_OrderItemStatus__c
                FROM NE__OrderItem__c
                WHERE Id = :orderItemsList.get( 3 ).id
        ];
        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_CANCELLED, orderCancelledItems.get( 0 ).OB_Nexi_OrderItemStatus__c );
        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_INSTALLED, orderCompletedItems.get( 0 ).OB_Nexi_OrderItemStatus__c );
    }

    /*******************************************************************************
    Purpose:  Method tests setting field (status ) of NE__Order__c

    History
    --------
    VERSION          AUTHOR               DATE            DETAIL          Description
    1.0          Marta Stempien        20/05/2019        Created             NEXI-46
    ********************************************************************************/
    @isTest static void setOrderStatusNexiWorkInProgress( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_DRAFT;
        testOrder.OB_ApprovalType__c = OB_UtilityConstants.BIO;
        testOrder.OB_BankApprovalStatus__c = OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_APPROVATO;
        insert testOrder;

        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_PENDING;
        update testOrder;

        List<NE__Order__c> testOrders =
        [
                SELECT Id, OB_Bank_OrderStatus__c
                FROM NE__Order__c
                WHERE Id = :testOrder.id
        ];

        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_PROCEDURE_NEXI_PROCESSING, testOrders.get( 0 ).OB_Bank_OrderStatus__c );
    }

    /*******************************************************************************
    Purpose:  Method tests setting field (status ) of NE__Order__c

    History
    --------
    VERSION          AUTHOR               DATE            DETAIL          Description
    1.0          Marta Stempien        20/05/2019        Created             NEXI-46
    ********************************************************************************/
    @isTest static void changeNexiOrderStatusWhenOrderUpdatedForOrderNull( )
    {
        OB_Order_ChangeStatus.changeNexiOrderStatusWhenOrderUpdated( null, null );
        List <NE__Order__c> oOrders = [ SELECT Id FROM NE__Order__c ];

        System.assertEquals( 0, oOrders.size( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests setting field (status ) of NE__Order__c

    History
    --------
    VERSION          AUTHOR               DATE            DETAIL          Description
    1.0          Marta Stempien        20/05/2019        Created             NEXI-46
    ********************************************************************************/
    @isTest static void changeNexiOrderStatusWhenOrderUpdatedForOrderHeaderNull( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_PENDING;
        testOrder.OB_ApprovalType__c = OB_UtilityConstants.BIO;
        insert testOrder;
        OB_Order_ChangeStatus.changeNexiOrderStatusWhenOrderUpdated( testOrder, null );
        List<NE__Order__c> testOrders =
        [
                SELECT Id, OB_Bank_OrderStatus__c
                FROM NE__Order__c
                WHERE Id = :testOrder.id
        ];

        System.assertEquals( 'Draft', testOrders.get( 0 ).OB_Bank_OrderStatus__c );

    }

    /*******************************************************************************
	Purpose:  Method tests setting fields (status and timestamp) of NE__Order__c
	          - 'Draft' - failed scenario - Order doesn't inserted

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Joanna Mielczarek       29/04/2019      Created         NEXI-20_order_status_handleLogic
 	********************************************************************************/
    @isTest static void setOrderStatusDraftFailed( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.OB_Nexi_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_APPROVED_PRICING;

        OB_Order_ChangeStatus.setOrderStatusDraft( testOrder );
        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_DRAFT, testOrder.OB_Nexi_OrderStatus__c );
    }

    /*******************************************************************************
	Purpose:  Method tests setting fields (status) of NE__Order__c
	          - 'Draft' - in case of null order

	History
	--------
	VERSION         AUTHOR                  DATE            DETAIL          Description
	1.0         Marta Stempien           20/05/2019         Created          NEXI-46
 	********************************************************************************/
    @isTest static void setOrderStatusDraftCheckForNull( )
    {
        OB_Order_ChangeStatus.setOrderStatusDraft( null );
        System.assert( true );
    }

    /*******************************************************************************
	Purpose:  Method tests setting fields (status) of NE__Order__c
	          - 'OrderToBeCompleted' in case of null order

	History
	--------
	VERSION         AUTHOR                  DATE            DETAIL          Description
	1.0         Marta Stempien           20/05/2019         Created          NEXI-46
 	********************************************************************************/
    @isTest static void setOrderStatusOrderToBeCompletedCheckForNull( )
    {
        OB_Order_ChangeStatus.setOrderStatusOrderToBeCompleted( null );
        System.assert( true );
    }


    /*******************************************************************************
    Purpose:  Method tests setting fields (status and timestamp) of NE__Order__c
              - 'Draft - incomplete order' - success scenario - user clicked 'riprendi convenzionamento' button

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       29/04/2019      Created         NEXI-20_order_status_handleLogic
    2.0         Joanna Mielczarek       05/06/2019      Modified        NEXI-99 updated test to new logic (without update)
    ********************************************************************************/
    @isTest static void setOrderStatusDraftIncompleteOrderIsResumeAgreement( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder = OB_Order_ChangeStatus.setOrderStatusDraftIncompleteOrder( testOrder, true, false, false );
        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_DRAFT_INCOMPLETE_ORDER, testOrder.OB_Nexi_OrderStatus__c );
    }

    /*******************************************************************************
    Purpose:  Method tests setting fields (status and timestamp) of NE__Order__c
              - 'Draft - incomplete order' - success scenario - user is on 'Operational Data' step

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       30/04/2019      Created         NEXI-20_order_status_handleLogic
    2.0         Joanna Mielczarek       05/06/2019      Modified        NEXI-99 updated test to new logic (without update)
    ********************************************************************************/
    @isTest static void setOrderStatusDraftIncompleteOrderIsOperationalDataStep( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_DRAFT;
        testOrder = OB_Order_ChangeStatus.setOrderStatusDraftIncompleteOrder( testOrder, false, true, false );
        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_DRAFT_INCOMPLETE_ORDER, testOrder.OB_Nexi_OrderStatus__c );
    }

    /*******************************************************************************
    Purpose:  Method tests setting fields (status and timestamp) of NE__Order__c
              - 'Draft - incomplete order' - success scenario - user re-enters the flow

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       30/04/2019      Created         NEXI-20_order_status_handleLogic
    2.0         Joanna Mielczarek       05/06/2019      Modified        NEXI-99 updated test to new logic (without update)
    ********************************************************************************/
    @isTest static void setOrderStatusDraftIncompleteOrderIsReEntered( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder = OB_Order_ChangeStatus.setOrderStatusDraftIncompleteOrder( testOrder, false, false, true );
        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_DRAFT_INCOMPLETE_ORDER, testOrder.OB_Nexi_OrderStatus__c );
    }

    /*******************************************************************************
	Purpose:  Method tests setting fields (status and timestamp) of NE__Order__c - 'Draft - incomplete order' - failed scenario

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Joanna Mielczarek       10/05/2019      Created         NEXI-20_order_status_handleLogic
	2.0         Joanna Mielczarek       05/06/2019      Modified        NEXI-99 updated test to new logic (without update)
 	********************************************************************************/
    @isTest static void setOrderStatusDraftIncompleteOrderNullParameters( )
    {
        NE__Order__c testOrder = OB_Order_ChangeStatus.setOrderStatusDraftIncompleteOrder( null, null, null, null );
        System.assertNotEquals( OB_Order_ChangeStatus.ORDER_STATUS_DRAFT_INCOMPLETE_ORDER, testOrder.OB_Nexi_OrderStatus__c );
    }

    /*******************************************************************************
	Purpose:  Method tests setting fields (status and timestamp) of NE__Order__c - 'Order to be completed' - success scenario

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Joanna Mielczarek       29/04/2019      Created         NEXI-22_order_status_saveAsDraft
 	********************************************************************************/
    @isTest static void setOrderStatusOrderToBeCompletedSuccess( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;

        OB_Order_ChangeStatus.setOrderStatusOrderToBeCompleted( testOrder );
        List<NE__Order__c> testOrders =
        [
                SELECT Id, OB_Nexi_OrderStatus__c
                FROM NE__Order__c
                WHERE OB_Nexi_OrderStatus__c = :OB_Order_ChangeStatus.ORDER_STATUS_ORDER_TO_BE_COMPLETED
        ];

        System.assertEquals( 1, testOrders.size( ) );
    }

    /*******************************************************************************
	Purpose:  Method tests setting fields (status and timestamp) of NE__Order__c - 'Order to be completed' - failed scenario

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Joanna Mielczarek       29/04/2019      Created         NEXI-22_order_status_saveAsDraft
 	********************************************************************************/
    @isTest static void setOrderStatusOrderToBeCompletedFailed( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        OB_Order_ChangeStatus.setOrderStatusOrderToBeCompleted( testOrder );
        List<NE__Order__c> testOrders =
        [
                SELECT Id
                FROM NE__Order__c
                WHERE OB_Nexi_OrderStatus__c = :OB_Order_ChangeStatus.ORDER_STATUS_ORDER_TO_BE_COMPLETED
        ];

        System.assertEquals( 0, testOrders.size( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests setting field OB_Nexi_OrderStatus__c of NE__Order__c - OrderStatusOperationControls - accept scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek       20/05/2019      Created         AF-Funnel-v3.0_status_logic_5.1
    ********************************************************************************/
    @isTest
    public static void changeOrderStatusForOrderStatusOperationControlsTest( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_PENDING;
        insert testOrder;
        NE__Order_Header__c testOrderHeader = new NE__Order_Header__c( NE__OrderId__c = testOrder.Id );
        testOrderHeader.OB_In_Approvazione_a__c = OB_UtilityConstants.FASECONTROL_OPERATIONAL_CONTROLS;
        testOrderHeader.OB_StartApprovalProcess__c = true;
        testOrderHeader.OB_AcquiringApproval__c = false;
        insert testOrderHeader;

        OB_Order_ChangeStatus.changeOrderStatus( testOrderHeader, testOrder );
        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_OPERATION_CONTROLS, testOrder.OB_Nexi_OrderStatus__c );
    }

    /*******************************************************************************
    Purpose:  Method tests setting field OB_Nexi_OrderStatus__c of NE__Order__c - OB_Order_ChangeStatus.ORDER_STATUS_AML_CONTROLS - accept scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek       20/05/2019      Created         AF-Funnel-v3.0_status_logic_5.1
    ********************************************************************************/
    @isTest
    public static void changeOrderStatusOrderStatusAMLControlsTest( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_PENDING;
        insert testOrder;
        NE__Order_Header__c testOrderHeader = new NE__Order_Header__c( NE__OrderId__c = testOrder.Id );
        testOrderHeader.OB_In_Approvazione_a__c = OB_UtilityConstants.FASECONTROL_OPERATIONAL_CONTROLS;
        testOrderHeader.OB_StartApprovalProcess__c = true;
        testOrderHeader.OB_AcquiringApproval__c = false;
        insert testOrderHeader;

        testOrder.OB_Nexi_OrderStatus__c = null;
        testOrderHeader.OB_In_Approvazione_a__c = OB_UtilityConstants.FASECONTROL_CONTROLS_AML;
        OB_Order_ChangeStatus.changeOrderStatus( testOrderHeader, testOrder );

        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_AML_CONTROLS, testOrder.OB_Nexi_OrderStatus__c );
    }

    /*******************************************************************************
    Purpose:  Method tests setting field OB_Nexi_OrderStatus__c of NE__Order__c - OB_Order_ChangeStatus.ORDER_STATUS_SECURITY_CHECKS - accept scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek       20/05/2019      Created         AF-Funnel-v3.0_status_logic_5.1
    ********************************************************************************/
    @isTest
    public static void changeOrderStatusOrderStatusSecurityChecksTest( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_PENDING;
        insert testOrder;
        NE__Order_Header__c testOrderHeader = new NE__Order_Header__c( NE__OrderId__c = testOrder.Id );
        testOrderHeader.OB_In_Approvazione_a__c = OB_UtilityConstants.FASECONTROL_OPERATIONAL_CONTROLS;
        testOrderHeader.OB_StartApprovalProcess__c = true;
        testOrderHeader.OB_AcquiringApproval__c = false;
        insert testOrderHeader;

        testOrder.OB_Nexi_OrderStatus__c = null;
        testOrderHeader.OB_In_Approvazione_a__c = OB_UtilityConstants.FASECONTROL_SECURITY_CHECKS;
        OB_Order_ChangeStatus.changeOrderStatus( testOrderHeader, testOrder );
        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_SECURITY_CHECKS, testOrder.OB_Nexi_OrderStatus__c );
    }

    /*******************************************************************************
    Purpose:  Method tests setting field OB_Nexi_OrderStatus__c of NE__Order__c - OB_Order_ChangeStatus.ORDER_STATUS_MISSING_INFORMATION - accept scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek       20/05/2019      Created         AF-Funnel-v3.0_status_logic_5.1
    ********************************************************************************/
    @isTest
    public static void changeOrderStatusOrderStatusMissingInformationTest( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_PENDING;
        insert testOrder;
        NE__Order_Header__c testOrderHeader = new NE__Order_Header__c( NE__OrderId__c = testOrder.Id );
        testOrderHeader.OB_In_Approvazione_a__c = OB_UtilityConstants.FASECONTROL_OPERATIONAL_CONTROLS;
        testOrderHeader.OB_StartApprovalProcess__c = true;
        testOrderHeader.OB_AcquiringApproval__c = false;
        insert testOrderHeader;

        testOrder.OB_Nexi_OrderStatus__c = null;
        testOrderHeader.OB_StartApprovalProcess__c = false;
        testOrderHeader.OB_Rejection_Reason__c = OB_UtilityConstants.REJECTION_ABSENT_DOCUMENTATION;
        OB_Order_ChangeStatus.changeOrderStatus( testOrderHeader, testOrder );
        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_MISSING_INFORMATION, testOrder.OB_Nexi_OrderStatus__c );
    }

    /*******************************************************************************
    Purpose:    Method check if field OB_FulfilmentStatus__c in NE__Order__c is "Pending".
                Scenario excpect method return null, becouse OB_FulfilementStatus__c is set on "Draft"
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek       20/05/2019      Created         AF-Funnel-v3.0_status_logic_5.1
    ********************************************************************************/
    @isTest
    public static void changeOrderStatusWhenFulfilmentStatusInOrderIsNotPendignTest( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_DRAFT;
        insert testOrder;
        NE__Order_Header__c testOrderHeader = new NE__Order_Header__c( NE__OrderId__c = testOrder.Id );
        insert testOrderHeader;

        OB_Order_ChangeStatus.changeOrderStatus( testOrderHeader, testOrder );
        System.assertEquals( null, testOrder.OB_Nexi_OrderStatus__c );
    }

    /*******************************************************************************
    Purpose:    Method check if field OB_StartApprovalProcess__c in NE__Order_Header__c is "False ", and OB_Rejection_Reason__c is "Missing documentation" or "Incomplete documentation"
                Scenario excpect to set field OB_Bank_OrderStatus__c in NE__Order_c to "Order status missing information"
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek       20/05/2019      Created         AF-Funnel-v3.0_status_logic_5.1
    ********************************************************************************/
    @isTest
    public static void changeOrderStatusForBankOrderStatusTest( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_PENDING;
        insert testOrder;
        NE__Order_Header__c testOrderHeader = new NE__Order_Header__c( NE__OrderId__c = testOrder.Id );
        testOrderHeader.OB_StartApprovalProcess__c = false;
        testOrderHeader.OB_Rejection_Reason__c = OB_UtilityConstants.REJECTION_MISSING_DOCUMENTATION;
        insert testOrderHeader;

        OB_Order_ChangeStatus.changeOrderStatus( testOrderHeader, testOrder );
        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_MISSING_INFORMATION, testOrder.OB_Bank_OrderStatus__c );
    }

    /*******************************************************************************
    Purpose:  Method tests setting field OB_Nexi_OrderStatus__c of NE__Order__c - OrderStatusOperationControls - accept scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek       20/05/2019      Created         AF-Funnel-v3.0_status_logic_5.1
    ********************************************************************************/
    @isTest
    public static void changeOrderStatusWhenFieldStartApprovalProcessInOrderHeaderIsTrueTest( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_PENDING;
        insert testOrder;
        NE__Order_Header__c testOrderHeader = new NE__Order_Header__c( NE__OrderId__c = testOrder.Id );
        testOrderHeader.OB_In_Approvazione_a__c = OB_UtilityConstants.FASECONTROL_OPERATIONAL_CONTROLS;
        testOrderHeader.OB_StartApprovalProcess__c = true;
        testOrderHeader.OB_AcquiringApproval__c = true;
        insert testOrderHeader;

        OB_Order_ChangeStatus.changeOrderStatus( testOrderHeader, testOrder );
        System.assertEquals( null, testOrder.OB_Nexi_OrderStatus__c );
    }

    /*******************************************************************************
    Purpose:  Method tests updating Orders - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       05/06/2019      Created         NEXI-99
    ********************************************************************************/
    @isTest static void updateOrdersStatusSuccess( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;
        testOrder.OB_Bank_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_APPROVED_PRICING;
        OB_Order_ChangeStatus.updateOrdersStatus( new List<NE__Order__c>{ testOrder } );
        List<NE__Order__c> ordersAfterUpdate = [ SELECT Id, OB_Bank_OrderStatus__c FROM NE__Order__c WHERE Id = :testOrder.Id ];

        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_APPROVED_PRICING, ordersAfterUpdate.get( 0 ).OB_Bank_OrderStatus__c );
    }

    /*******************************************************************************
    Purpose:  Method tests updating Orders - failed scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       05/06/2019      Created         NEXI-99
    ********************************************************************************/
    @isTest static void updateOrdersStatusEmptyList( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;
        testOrder.OB_Bank_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_APPROVED_PRICING;
        OB_Order_ChangeStatus.updateOrdersStatus( new List<NE__Order__c>( ) );
        List<NE__Order__c> ordersAfterUpdate = [ SELECT Id, OB_Bank_OrderStatus__c FROM NE__Order__c WHERE Id = :testOrder.Id ];

        System.assertNotEquals( OB_Order_ChangeStatus.ORDER_STATUS_APPROVED_PRICING, ordersAfterUpdate.get( 0 ).OB_Bank_OrderStatus__c );
    }

    /*******************************************************************************
    Purpose:  Method tests updating Orders - failed scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       05/06/2019      Created         NEXI-99
    ********************************************************************************/
    @isTest static void updateOrdersStatusException( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.OB_Bank_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_APPROVED_PRICING;
        OB_Order_ChangeStatus.updateOrdersStatus( new List<NE__Order__c>{ testOrder } );
        List<NE__Order__c> ordersAfterUpdate =
        [
                SELECT Id
                FROM NE__Order__c
                WHERE OB_Bank_OrderStatus__c = :OB_Order_ChangeStatus.ORDER_STATUS_APPROVED_PRICING
        ];

        System.assertEquals( 0, ordersAfterUpdate.size( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests changeNexiOrderStatusWhenOrderUpdated - order header was refused

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       08/10/2019      Created         NEXI-357
    ********************************************************************************/
    @isTest
    private static void changeNexiOrderStatusWhenOrderUpdatedFinalRefusal( )
    {
        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        testOrderHeader.OB_Rejection_Reason__c = OB_UtilityConstants.REJECTION_REASON_FINAL_REJ;
        insert testOrderHeader;
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        insert testOrder;

        Test.startTest( );
        OB_Order_ChangeStatus.changeNexiOrderStatusWhenOrderUpdated( testOrder, testOrderHeader );
        Test.stopTest( );

        List<NE__Order__c> result = [ SELECT OB_Bank_LastStatusChange__c FROM NE__Order__c LIMIT 1 ];
        System.assert( result.get( 0 ).OB_Bank_LastStatusChange__c == null );
    }
}