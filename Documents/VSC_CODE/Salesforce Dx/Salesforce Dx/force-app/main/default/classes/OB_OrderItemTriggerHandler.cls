/*****************************************************************
Name: OB_OrderItemTriggerHandler
Copyright © 2016 ITC
============================================================
Purpose:  Class handles logic for OrderItem status changes (OB_Nexi_OrderItemStatus__c
History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0      Wojciech Kucharek        07/05/2019       Created           NEXI-23
********************************************************************************/
public with sharing class OB_OrderItemTriggerHandler
{
    //NEXI-222 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 25/07/2019 Start
    public static final Id PRODUCT_RECORD_TYPE_MOTO = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( 'Moto' ).getRecordTypeId( );
    public static final Id PRODUCT_RECORD_TYPE_ECOMMERCE = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( 'eCommerce' ).getRecordTypeId( );
    //NEXI-222 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 25/07/2019 Stop

    /*******************************************************************************
    Purpose:  Method Update OB_Moto__c and/or OB_eCommerce__c on order header if needed
    Parameters: Map<Id, NE__OrderItem__c> newOrderItemMap
    Returns: -
    Throwable : use this method inside try catch if outside trigger

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-222
    ********************************************************************************/
    public static void updateOrderMotoEcomerce( Map<Id, NE__OrderItem__c> newOrderItemMap )
    {
        Map<Id, NE__Order_Header__c> orderHeadersToUpdate = new Map<Id, NE__Order_Header__c>( );
        for ( NE__OrderItem__c loopOrderItem :
        [
                SELECT NE__OrderId__r.NE__Order_Header__c,
                        NE__ProdId__r.RecordTypeId
                FROM NE__OrderItem__c
                WHERE Id IN :newOrderItemMap.keySet( )
                AND ( NE__ProdId__r.RecordTypeId = :PRODUCT_RECORD_TYPE_MOTO OR NE__ProdId__r.RecordTypeId = :PRODUCT_RECORD_TYPE_ECOMMERCE)
                AND NE__Action__c = :OB_UtilityConstants.ADD_ACTION
        ] )
        {
            if ( loopOrderItem.NE__ProdId__r.RecordTypeId == PRODUCT_RECORD_TYPE_MOTO )
            {
                if ( orderHeadersToUpdate.get( loopOrderItem.NE__OrderId__r.NE__Order_Header__c ) == null )
                {
                    orderHeadersToUpdate.put( loopOrderItem.NE__OrderId__r.NE__Order_Header__c, new NE__Order_Header__c( Id = loopOrderItem.NE__OrderId__r.NE__Order_Header__c, OB_Moto__c = true ) );
                }
                else
                {
                    orderHeadersToUpdate.get( loopOrderItem.NE__OrderId__r.NE__Order_Header__c ).OB_Moto__c = true;
                }
            }
            else
            {
                if ( orderHeadersToUpdate.get( loopOrderItem.NE__OrderId__r.NE__Order_Header__c ) == null )
                {
                    orderHeadersToUpdate.put( loopOrderItem.NE__OrderId__r.NE__Order_Header__c, new NE__Order_Header__c( Id = loopOrderItem.NE__OrderId__r.NE__Order_Header__c, OB_eCommerce__c = true ) );
                }
                else
                {
                    orderHeadersToUpdate.get( loopOrderItem.NE__OrderId__r.NE__Order_Header__c ).OB_eCommerce__c = true;
                }
            }
        }
        if ( !orderHeadersToUpdate.isEmpty( ) )
        {
            update orderHeadersToUpdate.values( );
        }
    }
}