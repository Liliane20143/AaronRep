/*******************************************************************************
Purpose:    Test class for OB_ExternalSourceMappingTrigger

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         ?                       ?               Created         ?
1.1         Wojciech Szuba          03/10/2019      Refactored      NEXI-107
********************************************************************************/
@isTest
private class OB_ExternalSourceMappingTrigger_Test
{
    /*******************************************************************************
    Purpose:    Test method for ExternalSourceMapping Trigger, update

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               Created         ?
    1.1         Wojciech Szuba          03/10/2019      Refactored      NEXI-107
    ********************************************************************************/
    @isTest
    private static void externalSourceMappingTriggerUpdateTest( )
    {
        //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - START
        OB_TriggerSupport__c triggerSupport = new OB_TriggerSupport__c( );
        triggerSupport.Name = 'OB_DisableTriggers';
        triggerSupport.OB_DisableAll__c = false;
        triggerSupport.OB_DisableExternalSourceMappingTrigger__c = false;
        insert triggerSupport;
        //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - STOP
        
        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;

        NE__Service_Point__c testServicePoint = OB_TestDataFactory.getServicePoint( );
        insert testServicePoint;

        ExternalSourceMapping__c testExternalSourceMapping = OB_TestDataFactory.getExternalSourceMapping( );
        testExternalSourceMapping.OB_Merchant_ID__c = testAccount.Id;
        testExternalSourceMapping.OB_Service_Point_ID__c = testServicePoint.Id;
        testExternalSourceMapping.OB_ToBeChecked__c = true;
        insert testExternalSourceMapping;

        testExternalSourceMapping.OB_ToBeChecked__c = false;
        Test.startTest( );
        Database.SaveResult testResult = Database.update( testExternalSourceMapping, false );
        Test.stopTest( );
        System.assert( testResult.isSuccess( ) );
    }
}