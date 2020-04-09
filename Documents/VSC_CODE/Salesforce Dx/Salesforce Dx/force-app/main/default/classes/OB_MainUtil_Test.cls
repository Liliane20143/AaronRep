/**
*@author Joanna Mielczarek <joanna.mielczarek@accenture.com>
*@date 20/03/2018
*@description Main utility test class
*@history 20/03/2018 tests created
*/
@isTest
private class OB_MainUtil_Test
{

    /**
    *@author Joanna Mielczarek <joanna.mielczarek@accenture.com>
    *@date 27/03/2019
    *@description Method tests splitting String with null params
    */
    @isTest static void explodeString_Null( )
    {
        System.assertEquals( null, OB_MainUtil.explodeString( null, ';' ) );
        System.assertEquals( null, OB_MainUtil.explodeString( 'test;test', null ) );
        System.assertEquals( null, OB_MainUtil.explodeString( null, null ) );
    }

    /**
    *@author Joanna Mielczarek <joanna.mielczarek@accenture.com>
    *@date 27/03/2019
    *@description Method tests splitting String to String with apostrophes and commas
    */
    @isTest static void explodeString_MoreThanOneString( )
    {
        System.assertEquals( '(\'test1\',\'test2\')', OB_MainUtil.explodeString( 'test1;test2', ';' ) );
    }

}