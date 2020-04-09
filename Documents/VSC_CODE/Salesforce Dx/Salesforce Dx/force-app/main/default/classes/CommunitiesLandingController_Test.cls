/*****************************************************************
Purpose:  Test class for CommunitiesLandingController

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         ?                       ?               Created         ?
1.1         Wojciech Szuba          10/10/2019      Refactored      NEXI-103
********************************************************************************/
@IsTest
private class CommunitiesLandingController_Test
{
    /*****************************************************************
    Purpose:  Method tests CommunitiesLandingController.forwardToStartPage

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               Created         ?
    1.1         Wojciech Szuba          10/10/2019      Refactored      NEXI-103
    ********************************************************************************/
    @IsTest
    private static void testCommunitiesLandingController( )
    {
        CommunitiesLandingController testCommunitiesLandingController = new CommunitiesLandingController( );
        PageReference testPageReference = testCommunitiesLandingController.forwardToStartPage( );
        System.assert( String.isBlank( String.valueOf( testPageReference.getUrl( ) ) ) );
    }
}