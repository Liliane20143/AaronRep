/*******************************************************************************
Purpose:    Test class for OB_OrderItemTrigger

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         Wojciech Szuba          04/10/2019      Created         NEXI-107
********************************************************************************/
@IsTest
private class OB_OrderItemTrigger_Test
{
    /*******************************************************************************
    Purpose:    Test method for OrderItem Trigger, insert

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba          04/10/2019      Created         NEXI-107
    ********************************************************************************/
    @IsTest
    private static void orderItemTriggerInsertTest( )
    {
         //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - START
        OB_TriggerSupport__c triggerSupport = new OB_TriggerSupport__c( );
        triggerSupport.Name = 'OB_DisableTriggers';
        triggerSupport.OB_DisableAll__c = false;
        triggerSupport.OB_DisableOrderItemTrigger__c = false; 
        insert triggerSupport;
        //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - STOP
        
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;

        NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
        Test.startTest( );
        Database.SaveResult testResult = Database.insert( testOrderItem, false );
        Test.stopTest( );
        System.assert( testResult.isSuccess( ) );
    }
}