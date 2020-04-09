/*****************************************************************
Name: OB_OrderItem_ChangeNexiStatus_Test
Copyright © 2016 ITC
============================================================
Purpose:  Class tests OB_OrderItem_ChangeNexiStatus methods

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0      Wojciech Kucharek         07/05/2019       Created           NEXI-23
********************************************************************************/
public with sharing class OB_OrderItem_ChangeNexiStatus
{
    /*******************************************************************************
    Purpose:  Method sets values of fields of NE__OrderItem__c.OB_Nexi_OrderItemStatus__c, when change value of OB_FulfilmentStatus__c in NE__Order__c
    Parameters: NE__Order__c selected order item
    Returns: -


    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek       07/05/2019      Created         NEXI-48
    ********************************************************************************/
    public static void setNexiStatus( NE__OrderItem__c inOrderItem, String inOrderFulfilmentStatus )
    {
        Boolean isFulfilmentStatusInCorrect = !( OB_UtilityConstants.FULFILMENTSTATUS_SENT.equals( inOrderFulfilmentStatus ) ||  OB_UtilityConstants.FULFILMENTSTATUS_FAILED.equals( inOrderFulfilmentStatus ) );
        if ( inOrderItem.NE__Root_Order_Item__c != null || isFulfilmentStatusInCorrect )
        {
            return;
        }
        if ( inOrderItem.OB_Tech_Outcome_Monetica__c == OB_UtilityConstants.TECHOUTCOME_OK )
        {
            inOrderItem.OB_Nexi_OrderItemStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_OK_MONETICA;
        }
        else if ( inOrderItem.OB_Tech_Outcome_Monetica__c == OB_UtilityConstants.TECHOUTCOME_KO )
        {
            inOrderItem.OB_Nexi_OrderItemStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_KO_MONETICA;
        }
        if ( inOrderItem.OB_Tech_Outcome_Equens__c == OB_UtilityConstants.TECHOUTCOME_OK )
        {
            inOrderItem.OB_Nexi_OrderItemStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_UPLOADED;
        }
        else if ( inOrderItem.OB_Tech_Outcome_Equens__c == OB_UtilityConstants.TECHOUTCOME_KO )
        {
            inOrderItem.OB_Nexi_OrderItemStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_SENDER_DISCARD;
        }
    }
}