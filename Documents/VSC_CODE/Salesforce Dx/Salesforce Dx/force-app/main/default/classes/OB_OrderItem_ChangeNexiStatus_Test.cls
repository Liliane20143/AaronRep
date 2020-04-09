/*****************************************************************
Name: OB_OrderItem_ChangeNexiStatus_Test
Copyright © 2016 ITC
============================================================
Purpose:  Class tests OB_OrderItem_ChangeNexiStatus methods
History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0      Kinga Fornal            14/06/2019         Created             ---
********************************************************************************/
@isTest
public with sharing class OB_OrderItem_ChangeNexiStatus_Test
{
    /*******************************************************************************
    Purpose:  Method to generate data for test
    Parameters: -
    Returns: NE__OrderItem__c
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0      Kinga Fornal            14/06/2019         Created             ---
    ********************************************************************************/
    public static NE__OrderItem__c getSampleOrderItem( )
    {
        Account testAccount = OB_TestDataFactory.getAccount();
        insert testAccount;
        NE__Order__c configuration = OB_TestDataFactory.getOrder();
        insert configuration;
        NE__OrderItem__c orderItem = OB_TestDataFactory.getOrderItem(configuration.Id);
        insert orderItem;
        return orderItem;
    }

   /*******************************************************************************
   Purpose:  Method tests OB_OrderItem_ChangeNexiStatus.setNexiStatus
   Parameters: -
   Returns: -
   History
   --------
   VERSION     AUTHOR                  DATE            DETAIL          Description
   1.0      Kinga Fornal            14/06/2019         Created             ---
   ********************************************************************************/
    @isTest
    public static void setNexiStatusMoneticaOkTest( )
    {
        NE__OrderItem__c testOrderItem = getSampleOrderItem();
        testOrderItem.OB_Tech_Outcome_Monetica__c = OB_UtilityConstants.TECHOUTCOME_OK;

        Test.startTest();
        OB_OrderItem_ChangeNexiStatus.setNexiStatus(testOrderItem, OB_UtilityConstants.FULFILMENTSTATUS_SENT);
        Test.stopTest();

        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_OK_MONETICA, testOrderItem.OB_Nexi_OrderItemStatus__c );

    }

    /*******************************************************************************
   Purpose:  Method tests OB_OrderItem_ChangeNexiStatus.setNexiStatus
   Parameters: -
   Returns: -
   History
   --------
   VERSION     AUTHOR                  DATE            DETAIL          Description
   1.0      Kinga Fornal            14/06/2019         Created             ---
   ********************************************************************************/
    @isTest
    public static void setNexiStatusMoneticaKOTest( )
    {
        NE__OrderItem__c testOrderItem = getSampleOrderItem();
        testOrderItem.OB_Tech_Outcome_Monetica__c = OB_UtilityConstants.TECHOUTCOME_KO;

        Test.startTest();
        OB_OrderItem_ChangeNexiStatus.setNexiStatus(testOrderItem, OB_UtilityConstants.FULFILMENTSTATUS_SENT);
        Test.stopTest();

        System.assertEquals( OB_Order_ChangeStatus.ORDER_STATUS_KO_MONETICA, testOrderItem.OB_Nexi_OrderItemStatus__c );

    }

    /*******************************************************************************
    Purpose:  Method tests OB_OrderItem_ChangeNexiStatus.setNexiStatus
    Parameters: -
    Returns: -
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0      Kinga Fornal            14/06/2019         Created             ---
    ********************************************************************************/
    @isTest
    public static void setNexiStatusEquensOKTest( )
    {
        NE__OrderItem__c testOrderItem = getSampleOrderItem();
        testOrderItem.OB_Tech_Outcome_Equens__c = OB_UtilityConstants.TECHOUTCOME_OK;

        Test.startTest();
        OB_OrderItem_ChangeNexiStatus.setNexiStatus(testOrderItem, OB_UtilityConstants.FULFILMENTSTATUS_SENT);
        Test.stopTest();

        System.assertEquals(  OB_Order_ChangeStatus.ORDER_STATUS_UPLOADED, testOrderItem.OB_Nexi_OrderItemStatus__c );

    }

    /*******************************************************************************
    Purpose:  Method tests OB_OrderItem_ChangeNexiStatus.setNexiStatus
    Parameters: -
    Returns: -
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0      Kinga Fornal            14/06/2019         Created             ---
    ********************************************************************************/
    @isTest
    public static void setNexiStatusEquensKOTest( )
    {
        NE__OrderItem__c testOrderItem = getSampleOrderItem();
        testOrderItem.OB_Tech_Outcome_Equens__c = OB_UtilityConstants.TECHOUTCOME_KO;

        Test.startTest();
        OB_OrderItem_ChangeNexiStatus.setNexiStatus(testOrderItem, OB_UtilityConstants.FULFILMENTSTATUS_SENT);
        Test.stopTest();

        System.assertEquals(  OB_Order_ChangeStatus.ORDER_STATUS_SENDER_DISCARD, testOrderItem.OB_Nexi_OrderItemStatus__c );
    }

    /*******************************************************************************
      Purpose:  Method tests OB_OrderItem_ChangeNexiStatus.setNexiStatus
      Parameters: -
      Returns: -
      History
      --------
      VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0      Kinga Fornal            14/06/2019         Created             ---
      ********************************************************************************/
    @isTest
    public static void setNexiStatusReturnTest( )
    {
        NE__OrderItem__c testOrderItem = getSampleOrderItem();
        testOrderItem.OB_Tech_Outcome_Equens__c = OB_UtilityConstants.TECHOUTCOME_KO;

        Test.startTest();
        OB_OrderItem_ChangeNexiStatus.setNexiStatus(testOrderItem, 'abc');
        Test.stopTest();
 
        System.assertEquals(  null, testOrderItem.OB_Nexi_OrderItemStatus__c );
    }
}