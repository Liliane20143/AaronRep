/*******************************************************************************
Purpose:    Test class for OB_Service_PointTrigger

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         Doris Tatiana           19/11/2018      Created         ?
1.1         Roland Nieznanski       30/09/2019      Refactored      Changed test class name
1.2         Wojciech Szuba          03/10/2019      Refactored      NEXI-252
********************************************************************************/
@isTest
private class OB_Service_PointTrigger_Test
{
    /*******************************************************************************
    Purpose:    Test method for Service Point Trigger, insert

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               Created         ?
    1.1         Wojciech Szuba          03/10/2019      Refactored      NEXI-252
    ********************************************************************************/
    @isTest
    private static void servicePointTriggerInsertTest( )
    {
        //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - START
        OB_TriggerSupport__c triggerSupport = new OB_TriggerSupport__c( );
        triggerSupport.Name = 'OB_DisableTriggers';
        triggerSupport.OB_DisableAll__c = false;
        triggerSupport.OB_DisableServicePointTrigger__c = false;
        insert triggerSupport;
        //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - STOP
        
        NE__Service_Point__c testServicePoint = OB_TestDataFactory.getServicePoint( );
        Test.startTest( );
        Database.SaveResult testResult = Database.insert( testServicePoint, false );
        Test.stopTest( );
        System.assert( testResult.isSuccess( ) );
    }

    /*******************************************************************************
    Purpose:    Test method for Service Point Trigger, update

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba          03/10/2019      Created         NEXI-252
    ********************************************************************************/
    @isTest
    private static void servicePointTriggerUpdateTest( )
    {
        //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - START
        OB_TriggerSupport__c triggerSupport = new OB_TriggerSupport__c( );
        triggerSupport.Name = 'OB_DisableTriggers';
        insert triggerSupport;
        //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - STOP
        
        NE__Service_Point__c testServicePoint = OB_TestDataFactory.getServicePoint( );
        insert testServicePoint;

        testServicePoint.Name = 'secondTestName';
        Test.startTest( );
        Database.SaveResult testResult = Database.update( testServicePoint, false );
        Test.stopTest( );
        System.assert( testResult.isSuccess( ) );
    }
}