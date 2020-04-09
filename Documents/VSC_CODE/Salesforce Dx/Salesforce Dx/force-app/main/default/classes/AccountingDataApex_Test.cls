/*******************************************************************************
Purpose:  Test class for AccountingDataApex

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         ?                       ?               Created         ?
1.1         Wojciech Szuba          07/10/2019      Refactored      NEXI-103
********************************************************************************/
@IsTest
private class AccountingDataApex_Test
{
    /*******************************************************************************
    Purpose:  Test method for AccountingDataApex.getAllBillingProfile

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               Created         ?
    1.1         Wojciech Szuba          07/10/2019      Refactored      NEXI-103
    ********************************************************************************/
    @isTest
    private static void getAllBillingProfilesTest( )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;

        NE__Billing_Profile__c testBillingProfile = OB_TestDataFactory.getBillingProfile( testAccount.Id );
        testBillingProfile.OB_Bank_Account_Number__c = '123456789012';
        insert testBillingProfile;

        Test.startTest( );
        List<NE__Billing_Profile__c> testResult = AccountingDataApex.getAllBillingProfile( );
        Test.stopTest( );
        System.assert( !testResult.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Test method for AccountingDataApex.getAllBillingProfile

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               Created         ?
    1.1         Wojciech Szuba          10/10/2019      Refactored      NEXI-103
    ********************************************************************************/
    @isTest
    private static void insertFieldsMethodTest( )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;

        List<String> testInput = new List<String>( );
        String testJSON = '{"attributes":{"type":"NE__Billing_Profile__c"},"OB_ABI__c":"12345","OB_Bank_Account_Number__c":"121212121212","OB_Bank_Account_Owner__c":"' + testAccount.Id + '","NE__Account__c":"' + testAccount.Id + '"}';
        testInput.add( testJSON );

        Test.startTest( );
        List<NE__Billing_Profile__c> testResult = AccountingDataApex.insertFieldsMethod( testInput );
        Test.stopTest( );
        System.assert( !testResult.isEmpty( ) );
    }
}