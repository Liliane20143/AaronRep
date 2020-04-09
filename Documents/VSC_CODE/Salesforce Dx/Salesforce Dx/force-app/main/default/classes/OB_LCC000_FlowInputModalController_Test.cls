/*********************************************************************************
Name: OB_LCP000_FlowInputModalController_Test
Copyright © 2016 ITC
=================================================================================
Purpose:  Class is test class for a OB_LCP000_FlowInputModalController

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0       Monika Kocot             16/07/2019       Created           NEXI-190
********************************************************************************/
@isTest
private with sharing class OB_LCC000_FlowInputModalController_Test
{
    /*******************************************************************************
    Purpose: Method tests OB_LCP000_FlowInputModalController.cleanData method
    Parameters: Id orderHeaderId
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0       Monika Kocot             16/07/2019       Created           NEXI-190
    ********************************************************************************/
    @isTest
    private static void cleanDataMethodTest( )
    {
        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader( );
        insert orderHeader;
        List<NE__Order_Header__c> orderHeaders = new List<NE__Order_Header__c> {orderHeader};

        NE__Order__c order = OB_TestDataFactory.getOrder( );
        order.NE__Order_Header__c = orderHeader.Id;
        order.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_DRAFT;
        insert order;
        List<NE__Order__c> orders = new List<NE__Order__c> {order};

        NE__OrderItem__c orderItem = OB_TestDataFactory.getOrderItem( order.Id );
        insert orderItem;
        List<NE__OrderItem__c> orderItems = new List<NE__OrderItem__c> {orderItem};

        Test.startTest( );
        Boolean isUpdated = OB_LCC000_FlowInputModalController.cleanDataMethod( orderHeader.Id );
        Test.stopTest( );

        System.assertEquals( true, isUpdated );
    }

    /*******************************************************************************
    Purpose: Method tests OB_LCP000_FlowInputModalController.cleanData method with
    negative scenario when orderHeder was not created.
    Parameters: Id orderHeaderId
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0       Monika Kocot             23/07/2019       Created           NEXI-190
    ********************************************************************************/
    @isTest
    private static void cleanDataMethodTestNegativeScenario( )
    {
        NE__Order_Header__c orderHeader = new NE__Order_Header__c( );
        insert orderHeader;
        delete orderHeader;

        Test.startTest( );
        Boolean isUpdated = OB_LCC000_FlowInputModalController.cleanDataMethod( orderHeader.Id );
        Test.stopTest( );

        System.assertEquals( false, isUpdated );
    }

    /*******************************************************************************
    Purpose: Method tests OB_LCP000_FlowInputModalController.cleanData method with
    negative scenario when orderHeder id is null.
    Parameters: Id orderHeaderId
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0       Monika Kocot             23/07/2019       Created           NEXI-190
    ********************************************************************************/
    @isTest
    private static void cleanDataMethodTestNegativeScenarioNullId( )
    {
        Id orderHeaderId;

        Test.startTest( );
        Boolean result = OB_LCC000_FlowInputModalController.cleanDataMethod( orderHeaderId );
        Test.stopTest( );

        System.assertEquals( false, result );
    }
}