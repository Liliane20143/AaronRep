/*
CLASS NAME TO TEST : OB_BillingProfileTriggerHandler
AUTHOR: DORIS TATIANA
DATE  : 09/11/2018
*/

@isTest
public class OB_BillingProfileTriggerHandler_Test
{
    @isTest
    public static void rearrange_Test( )
    { 

        String iban = 'IT26D0511611703000000002340';

        Test.startTest( );
        OB_BillingProfileTriggerHandler.rearrange( iban );
        Test.stopTest( );

    }

    @isTest
    public static void convertToInteger_Test( )
    {

        String iban = 'IT26D0511611703000000002340';

        Test.startTest( );
        OB_BillingProfileTriggerHandler.convertToInteger( iban );
        Test.stopTest( );

    }

    @isTest
    public static void performModulos_Test( )
    {

        String iban = 'IT26D0511611703000000002340';

        Test.startTest( );
        OB_BillingProfileTriggerHandler.convertToInteger( iban );
        Test.stopTest( );

    }

    @isTest
    public static void validateIban_Test( )
    {

        String iban = 'IT26D0511611703000000002340';

        Test.startTest( );
        OB_BillingProfileTriggerHandler.validateIban( iban );
        Test.stopTest( );

    }

    @isTest
    public static void checkValidityOnIban_Test( )
    {

        List<NE__Billing_Profile__c> billProfs = new List<NE__Billing_Profile__c>( );
        List<NE__Billing_Profile__c> oldBillProfs = new List<NE__Billing_Profile__c>( );
        NE__Billing_Profile__c billProf = new NE__Billing_Profile__c( );
        Account acc = new Account( Name = 'test' );
        acc.OB_Employees_Number__c = 'Minore di 10';
        acc.NE__Fiscal_code__c = '12345678909';
        acc.NE__VAT__c = '67543456789';
        insert acc;

        String iban = 'IT26D0511611703000000002340';
        billProf.NE__Iban__c = iban;
        billProf.OB_ABICode__c = '05116';
        billProf.OB_CABCode__c = '11703';
        billProf.OB_CINCode__c = 'D';
        billProf.OB_Bank_Account_Number__c = '000000002340';
        billProf.OB_EuroControlCode__c = '26';
        billProf.OB_CountryCode__c = 'IT';
        billProf.OB_BypassValidation__c = false;
        billProf.NE__Account__c = acc.Id;
        billProfs.add( billProf );
        insert billProfs;

        NE__Billing_Profile__c billProf2 = new NE__Billing_Profile__c( );
        Account acc1 = new Account( Name = 'test' );
        acc1.OB_Employees_Number__c = 'Minore di 10';
        acc1.NE__Fiscal_code__c = '12345678909';
        acc1.NE__VAT__c = '67543456789';
        insert acc1;
        billProf2.NE__Iban__c = iban;
        billProf2.OB_ABICode__c = '05116';
        billProf2.OB_CABCode__c = '11703';
        billProf2.OB_CINCode__c = 'D';
        billProf2.OB_Bank_Account_Number__c = '000000002340';
        billProf2.OB_EuroControlCode__c = '26';
        billProf2.OB_CountryCode__c = 'IT';
        billProf2.OB_BypassValidation__c = false;
        billProf2.NE__Account__c = acc1.Id;

        oldBillProfs.add( billProf2 );
        insert oldBillProfs;


        Test.startTest( );
        OB_BillingProfileTriggerHandler bp = new OB_BillingProfileTriggerHandler( );
        bp.checkValidityOnIban( billProfs, oldBillProfs );
        Test.stopTest( );

    }

    /*******************************************************************************
    Purpose:  Method test checkValidityOnIban with bad OB_Bank_Account_Number__c
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       11/10/2019      Created         NEXI-366
    ********************************************************************************/
    @isTest
    private static void checkValidityOnIbanBadAccountNumber( )
    {
        Account aAccount = OB_TestDataFactory.getAccount( );
        insert aAccount;
        NE__Billing_Profile__c billingProfile = OB_TestDataFactory.getBillingProfile( aAccount.id );
        billingProfile.NE__Iban__c = 'IT64G0313812300000241351661';
        billingProfile.OB_ABICode__c = '03138';
        billingProfile.OB_CABCode__c = '12300';
        billingProfile.OB_CINCode__c = 'G';
        billingProfile.OB_Bank_Account_Number__c = '000241351661';
        billingProfile.OB_EuroControlCode__c = '64';
        billingProfile.OB_CountryCode__c = 'IT';
        insert billingProfile;
        billingProfile.OB_Bank_Account_Number__c = '0002413516611';
        List<NE__Billing_Profile__c> testData = new List<NE__Billing_Profile__c> {billingProfile};
        OB_BillingProfileTriggerHandler core = new OB_BillingProfileTriggerHandler( );
        core.checkValidityOnIban( testData, new List<NE__Billing_Profile__c>( ) );
        System.assertNotEquals( null, billingProfile.id );
    }
}