/*****************************************************************
Name: OB_OrderItemTriggerHandlerTest
Copyright © 2016 ITC
============================================================
Purpose:  Class tests OB_OrderItemTriggerHandler
History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0      Wojciech Kucharek        26/04/2019        Created           NEXI-23
********************************************************************************/
@isTest
private class OB_OrderItemTriggerHandler_Test
{

    /*******************************************************************************
    Purpose:  Method is core data preparation for tests of updateOrderMotoEcomerce from OB_OrderItemTriggerHandler
    Parameters: Id inProductRT, String inAction
    Returns: Id

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-222
    ********************************************************************************/
    private static Id coreForInsertMotoECommerceTest( Id inProductRT, String inAction )
    {
        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader( );
        insert orderHeader;
        NE__Order__c oOrder = OB_TestDataFactory.getOrder( );
        oOrder.NE__Order_Header__c = orderHeader.Id;
        insert oOrder;
        NE__Product__c pProduct = OB_TestDataFactory.getProduct( );
        pProduct.RecordTypeId = inProductRT;
        insert pProduct;
        List<NE__OrderItem__c> orderItemsToUpdate = new List<NE__OrderItem__c>( );
        for ( Integer i = 0; i < 200; i++ )
        {
            NE__OrderItem__c oOrderItem = OB_TestDataFactory.getOrderItem( oOrder.Id );
            oOrderItem.NE__ProdId__c = pProduct.Id;
            oOrderItem.NE__Action__c = inAction;
            orderItemsToUpdate.add( oOrderItem );
        }
        insert orderItemsToUpdate;
        return orderHeader.Id;
    }

    /*******************************************************************************
    Purpose:  Method test  updateOrderMotoEcomerce from OB_OrderItemTriggerHandler when Moto is added
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-222
    ********************************************************************************/
    @isTest
    private static void insertMotoTest( )
    {
        Id orderHeaderId = coreForInsertMotoEcommerceTest( OB_OrderItemTriggerHandler.PRODUCT_RECORD_TYPE_MOTO, OB_UtilityConstants.ADD_ACTION );
        NE__Order_Header__c result = [ SELECT OB_Moto__c FROM NE__Order_Header__c WHERE Id = :orderHeaderId ];
        System.assert( result.OB_Moto__c );
    }

    /*******************************************************************************
    Purpose:  Method test  updateOrderMotoEcomerce from OB_OrderItemTriggerHandler when eCommerce is added
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-222
    ********************************************************************************/
    @isTest
    private static void insertECommerceTest( )
    {
        Id orderHeaderId = coreForInsertMotoEcommerceTest( OB_OrderItemTriggerHandler.PRODUCT_RECORD_TYPE_ECOMMERCE, OB_UtilityConstants.ADD_ACTION );
        NE__Order_Header__c result = [ SELECT OB_eCommerce__c FROM NE__Order_Header__c WHERE Id = :orderHeaderId ];
        System.assert( result.OB_eCommerce__c );
    }

    /*******************************************************************************
    Purpose:  Method test  updateOrderMotoEcomerce from OB_OrderItemTriggerHandler with null parameter
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       25/07/2019      Created         NEXI-222
    ********************************************************************************/
    @isTest
    private static void updateOrderMotoEcomerceNullTest( )
    {
        try
        {
            OB_OrderItemTriggerHandler.updateOrderMotoEcomerce( null );
            System.assert( false );
        } catch ( Exception ex )
        {
            System.assert( true );
        }
    }
}