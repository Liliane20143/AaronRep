/*****************************************************************
Purpose:  Class tests CartWrapperController class

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         ?                       11/04/2019      Created         ?
1.1         Damian Krzyzaniak        03/09/2019       Modified      Changed method name - removed suffix
1.2         Wojciech Szuba          10/10/2019      Refactored      NEXI-103
********************************************************************************/
@isTest
private class CartWrapperController_Test
{
    /*****************************************************************
    Purpose:  Method tests CartWrapperController.getOrderIdFromUrl

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       11/04/2019      Created         ?
    1.1         Wojciech Szuba          10/10/2019      Refactored      NEXI-103
    ********************************************************************************/
    @isTest
    private static void getOrderIdFromUrlTest( )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );//R1F2_RP_000_CC Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 11/04/2019
        insert testAccount;

        CartWrapperController testCartWrapperController = new CartWrapperController( );

        PageReference pageRef = Page.CartWrapperVisualforce;
        Test.setCurrentPage( pageRef );

        ApexPages.currentPage( ).getParameters( ).put( 'accId', testAccount.Id );
        Id idUrl = ( Id ) ApexPages.currentPage( ).getParameters( ).get( 'accId' );

        System.assertNotEquals( null, testCartWrapperController.getOrderIdFromUrl( ) ); //R1F2_RP_000_CC Zuzanna Urban<z.urban@accenture.com>, 17/04/2019
    }
}