/*****************************************************************
Name: OB_LCP000_FlowInputModalController
Copyright © 2016 ITC
============================================================
Purpose:  Controller for change fulfilment status of orders, orderheaders and
order items after chosen "Controlla Codice Fiscale" in Dati Societa 5 step

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0       Kinga Fornal             16/07/2019       Created           NEXI-190
1.1       Monika Kocot             23/07/2019       Created           NEXI-190
********************************************************************************/
public with sharing class OB_LCC000_FlowInputModalController
{
    /*******************************************************************************
    Purpose: Method for change fulfilment status after chosen "Controlla Codice Fiscale"
    in Dati Societa step
    Parameters: Id orderHeaderId
    Returns: Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0       Monika Kocot           17/07/2019        Created          NEXI-190
    ********************************************************************************/
    @AuraEnabled
    public static Boolean cleanDataMethod( Id orderHeaderId )
    {
        Boolean isSuccess = false;
        List<SObject> toUpdate = new List<SObject>( );

        if ( String.isBlank( orderHeaderId ) )
        {
            return isSuccess;
        }

        List<NE__Order__c> orders =
        [
                SELECT Id,OB_FulfilmentStatus__c,
                        NE__Order_Header__c, NE__Order_Header__r.OB_FulfilmentStatus__c
                FROM NE__Order__c
                WHERE NE__Order_Header__c = :orderHeaderId
        ];

        List<NE__OrderItem__c> orderItemList =
        [
                SELECT Id,OB_FulfilmentStatus__c
                FROM NE__OrderItem__c
                WHERE NE__OrderId__r.NE__Order_Header__c = :orderHeaderId
        ];

        NE__Order_Header__c orderHeader = new NE__Order_Header__c( Id = orderHeaderId );
        orderHeader.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_CANCELLED;
        toUpdate.add( orderHeader );

        for ( NE__Order__c order : orders )
        {
            order.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_CANCELLED;
            toUpdate.add( order );
        }

        for ( NE__OrderItem__c orderItem : orderItemList )
        {
            orderItem.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_CANCELLED;
            toUpdate.add( orderItem );
        }

        if ( !toUpdate.isEmpty( ) )
        {
            try
            {
                update toUpdate;
                isSuccess = true;

            } catch ( Exception e )
            {
                System.debug( LoggingLevel.ERROR, 'OB_LCP000_FlowInputModalController.cleanDataMethod ERROR: ' + e.getMessage( ) );
                isSuccess = false;
            }
        }
        return isSuccess;
    }
}