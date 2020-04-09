/*****************************************************************
Purpose:  Test class for ChangePasswordController

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         ?                       ?               Created         ?
1.1         Wojciech Szuba          10/10/2019      Refactored      NEXI-103
********************************************************************************/
@IsTest
private class ChangePasswordController_Test
{
    /*****************************************************************
    Purpose:  Method tests ChangePasswordController.changePassword

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               Created         ?
    1.1         Wojciech Szuba          10/10/2019      Refactored      NEXI-103
    ********************************************************************************/
    @IsTest
    private static void testChangePasswordController( )
    {
        ChangePasswordController testChangePasswordController = new ChangePasswordController( );
        testChangePasswordController.oldPassword = '123456';
        testChangePasswordController.newPassword = 'qwerty1';
        testChangePasswordController.verifyNewPassword = 'qwerty1';
        System.assertEquals( testChangePasswordController.changePassword( ), null );
    }
}