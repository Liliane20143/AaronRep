/*****************************************************************
Name: OB_LCC005_OperationalData_Test
Copyright © 2019 ITC
============================================================
Purpose:  Class tests OB_LCC005_OperationalData

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         Joanna Mielczarek       07/05/2019      Created         NEXI-20_order_status_handleLogic
********************************************************************************/
@isTest
public with sharing class OB_LCC005_OperationalData_Test
{

    /*******************************************************************************
	Purpose:  Method tests setting fields (status and timestamp) of NE__Order__c - 'Draft - Incomplete Order'
	          - success scenario

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Joanna Mielczarek       07/05/2019      Created         NEXI-20_order_status_handleLogic
 	********************************************************************************/
    @isTest static void setOrderStatusDraftIncompleteOrderSuccess( )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        testOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_DRAFT;
        insert testOrder;

        String testJSON = '{ "Configuration" : { "Id" : "' + testOrder.Id + '" } }';
        Map<String, Object> testData = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );

        OB_LCC005_OperationalData.setOrderStatusDraftIncompleteOrder( testData );

        List<NE__Order__c> testOrders =
        [
                SELECT Id
                FROM NE__Order__c
                WHERE OB_Nexi_OrderStatus__c = :OB_Order_ChangeStatus.ORDER_STATUS_DRAFT_INCOMPLETE_ORDER
        ];
        System.assertEquals( 1, testOrders.size( ) );
    }

    /*******************************************************************************
	Purpose:  Method tests setting fields (status and timestamp) of NE__Order__c - 'Draft - Incomplete Order'
	          - failed scenario - invalid data

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Joanna Mielczarek       07/05/2019      Created         NEXI-20_order_status_handleLogic
 	********************************************************************************/
    @isTest static void setOrderStatusDraftIncompleteOrderFailed( )
    {
        String testJSON = '{ "Configuration" : { "Id" : "" } }';
        Map<String, Object> testData = ( Map<String, Object> ) JSON.deserializeUntyped( testJSON );

        OB_LCC005_OperationalData.setOrderStatusDraftIncompleteOrder( testData );

        List<NE__Order__c> testOrders =
        [
                SELECT Id
                FROM NE__Order__c
                WHERE OB_Nexi_OrderStatus__c = :OB_Order_ChangeStatus.ORDER_STATUS_DRAFT_INCOMPLETE_ORDER
        ];
        System.assertEquals( 0, testOrders.size( ) );
    }

    /*******************************************************************************
	Purpose:  Method tests setting fields (status and timestamp) of NE__Order__c - 'Draft - Incomplete Order'
	          - failed scenario - invalid data

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Joanna Mielczarek       07/05/2019      Created         NEXI-20_order_status_handleLogic
 	********************************************************************************/
    @isTest static void setOrderStatusDraftIncompleteOrderEmptyMap( )
    {
        Map<String, Object> testData = new Map<String, Object>( );
        OB_LCC005_OperationalData.setOrderStatusDraftIncompleteOrder( testData );

        List<NE__Order__c> testOrders =
        [
                SELECT Id
                FROM NE__Order__c
                WHERE OB_Nexi_OrderStatus__c = :OB_Order_ChangeStatus.ORDER_STATUS_DRAFT_INCOMPLETE_ORDER
        ];
        System.assertEquals( 0, testOrders.size( ) );
    }
}