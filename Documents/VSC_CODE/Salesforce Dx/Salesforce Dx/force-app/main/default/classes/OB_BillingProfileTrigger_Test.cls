/*******************************************************************************
Purpose:    Test class for OB_BillingProfileTrigger

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         Doris Tatiana           12/11/2018      Created         ?
1.1         Wojciech Szuba          04/10/2019      Refactored      NEXI-107
********************************************************************************/
@isTest
private class OB_BillingProfileTrigger_Test
{
    /*******************************************************************************
    Purpose:    Test method for BillingProfile Trigger, insert

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba          04/10/2019      Created         NEXI-107
    ********************************************************************************/
    @isTest
    private static void billingProfileTriggerInsertTest( )
    {
        //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - START
        OB_TriggerSupport__c triggerSupport = new OB_TriggerSupport__c( );
        triggerSupport.Name = 'OB_DisableTriggers';
        triggerSupport.OB_DisableAll__c = false;
        triggerSupport.OB_DisableBillingProfileTrigger__c = false;
        insert triggerSupport;
        //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - STOP
 	
        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;

        NE__Billing_Profile__c testBillingProfile = OB_TestDataFactory.getBillingProfile( testAccount.Id );
        Test.startTest( );
        Database.SaveResult testResult = Database.insert( testBillingProfile );
        Test.stopTest( );

        System.assert( testResult.isSuccess( ) );
    }

    /*******************************************************************************
    Purpose:    Test method for BillingProfile Trigger, update

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba          04/10/2019      Created         NEXI-107
    ********************************************************************************/
    @isTest
    private static void billingProfileTriggerUpdateTest( )
    {
        //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - START
        OB_TriggerSupport__c triggerSupport = new OB_TriggerSupport__c( );
        triggerSupport.Name = 'OB_DisableTriggers';
        triggerSupport.OB_DisableAll__c = false;
        triggerSupport.OB_DisableBillingProfileTrigger__c = false;
        insert triggerSupport;
        //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - STOP
       
        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;

        NE__Billing_Profile__c testBillingProfile = OB_TestDataFactory.getBillingProfile( testAccount.Id );
        insert testBillingProfile;

        testBillingProfile.OB_BypassValidation__c = false;
        Test.startTest( );
        Database.SaveResult testResult = Database.update( testBillingProfile );
        Test.stopTest( );

        System.assert( testResult.isSuccess( ) );
    }
}