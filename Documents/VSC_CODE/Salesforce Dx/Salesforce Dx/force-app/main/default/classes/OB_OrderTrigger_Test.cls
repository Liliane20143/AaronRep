/*******************************************************************************
Purpose:    Test class for OB_OrderTrigger

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         ?                       ?               Created         ?
1.1         Wojciech Szuba          04/10/2019      Refactored      NEXI-107
********************************************************************************/
@isTest
private class OB_OrderTrigger_Test
{
    /*******************************************************************************
    Purpose:    Test method for Order Trigger, update

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               Created         ?
    1.1         Wojciech Szuba          04/10/2019      Refactored      NEXI-107
    ********************************************************************************/
    @isTest
    private static void orderTriggerUpdateTest( )
    {
         //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - START
        OB_TriggerSupport__c triggerSupport = new OB_TriggerSupport__c( );
        triggerSupport.Name = 'OB_DisableTriggers';
        triggerSupport.OB_DisableAll__c = false;
        triggerSupport.OB_DisableOrderTrigger__c = false; 
        insert triggerSupport;
        //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - STOP
        
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
        insert testOrder;

        testOrder.OB_ApprovalBIO__c = true;
        Test.startTest( );
        Database.SaveResult testResult = Database.update( testOrder, false );
        Test.stopTest( );
        System.assert( testResult.isSuccess( ) );
    }
}