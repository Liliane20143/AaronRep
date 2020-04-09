/*******************************************************************************
Purpose:  Test class for OB_Maintenance_Shortcut_SP_CC

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         Antonio Vatrano         18/04/2019      Created         ?
1.1         Wojciech Szuba          07/10/2019      Refactored      Changed test class name, added small fixes
********************************************************************************/
@isTest
private class OB_Maintenance_Shortcut_SP_CC_Test
{
    /*******************************************************************************
    Purpose:  Test method for OB_Maintenance_Shortcut_SP_CC.retrieveSP

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Antonio Vatrano         18/04/2019      Created         ?
    1.1         Wojciech Szuba          07/10/2019      Refactored      Removed unused code
    ********************************************************************************/
    @isTest
    private static void retrieveSPTest( )
    {
        OB_Maintenance_Shortcut_SP_CC.SearchResultWrapper testWrapper = new OB_Maintenance_Shortcut_SP_CC.SearchResultWrapper( );
        testWrapper.errorMessage = 'test';
        testWrapper.selectedServicePoint = '';
        testWrapper.selectedServicePointExt = '';
        testWrapper.executorModifiedAllowed = true;
        testWrapper.outcome = '';
        testWrapper.selectedMerchantExt = '';
        testWrapper.selectedMerchantAsset = '';
        testWrapper.selectedServicePointAsset = '';

        NE__Service_Point__c testServicePoint = OB_TestDataFactory.getServicePoint( );
        insert testServicePoint;

        Test.startTest( );
        Map<String,String> testResult = OB_Maintenance_Shortcut_SP_CC.retrieveSP( testServicePoint.Id );
        Test.stopTest( );
        System.assert( !testResult.isEmpty( ) );
    }
}