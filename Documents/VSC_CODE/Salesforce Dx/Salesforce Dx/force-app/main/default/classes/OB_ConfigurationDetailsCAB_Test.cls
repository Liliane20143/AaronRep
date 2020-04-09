/**************************************************************
* Date Created       : 13/11/2018  
* Author             : Doris Tatiana
* Class name to test : OB_ConfigurationDetailsCABController
***************************************************************
*/

@isTest
public with sharing class OB_ConfigurationDetailsCAB_Test
{
    @isTest
    public static void getUserABIServer_test( )
    {
    Profile profile1 = [ SELECT Id FROM Profile WHERE Name = 'System Administrator' ];

        User user = new User( LastName          = 'test'+UserInfo.getOrganizationId(),
                              Alias             = 'test123y',
                              Email             = 'test12@'+UserInfo.getOrganizationId()+'test.com',
                              Username          = 'name2@' + UserInfo.getOrganizationId()+ 'test.com',
                              CommunityNickname = 'tests'+UserInfo.getOrganizationId(),
                              ProfileId         =  profile1.Id,
                              EmailEncodingKey  = 'ISO-8859-1',
                              TimeZoneSidKey    = 'Europe/Rome',
                              LocaleSidKey      = 'it_IT',
                              LanguageLocaleKey = 'en_US' );
        insert user;
        Test.startTest( );

        //List<User> userList = [ SELECT id, OB_Abi__c, ob_cab__c FROM User ];
        //User userInfo = userList.get( 0 );

        //OB_ConfigurationDetailsCABController.getUserABIServer( userInfo.id );
        OB_ConfigurationDetailsCABController.getUserABIServer( user.id );
        Test.stopTest( );
    }

    @isTest
    public static void getRowsByMatrixParameterId_test( )
    {
        NE__Matrix_Parameter__c matrixParameter = new NE__Matrix_Parameter__c( Name = 'test' );
        insert matrixParameter;

        Test.startTest( );
        OB_ConfigurationDetailsCABController.getRowsByMatrixParameterId( matrixParameter, null, null, null );
        Test.stopTest( );
    }

    @isTest
    public static void calculateDate_test( )
    {
        Date myDate = Date.newInstance( 1990, 11, 21 );
        Date newDate = myDate.addMonths( -1 );
        String startDate = String.valueOf( newDate );

        Test.startTest( );
        OB_ConfigurationDetailsCABController.calculateDate( startDate );
        Test.stopTest( );
    }

    @isTest
    public static void insertCloneRow_test( )
    {
        Date myDate = Date.newInstance( 1990, 11, 21 );
        Date newDate = myDate.addMonths( +1 );

        NE__Matrix_Parameter_Row__c rowParent = new NE__Matrix_Parameter_Row__c( );
        NE__Matrix_Parameter_Row__c rowParent1 = new NE__Matrix_Parameter_Row__c( );
        NE__Matrix_Parameter__c matrixParameter = new NE__Matrix_Parameter__c( );

        rowParent.NE__Start_Date__c = myDate;

        rowParent1.NE__Start_Date__c = newDate;

        List<NE__Matrix_Parameter_Row__c> rowChildren = new List<NE__Matrix_Parameter_Row__c>( );
        rowChildren.add( rowParent );
        rowChildren.add( rowParent1 );

        Test.startTest( );
        OB_ConfigurationDetailsCABController.insertCloneRow( rowParent, rowChildren );
        Test.stopTest( );
    }

    @isTest
    public static void getChildCatalogItems_test( )
    {
        Test.startTest( );
        OB_ConfigurationDetailsCABController.getChildCatalogItems( null );
        Test.stopTest( );
    }

    @isTest
    public static void updateRows_test( )
    {
        List<NE__Matrix_Parameter_Row__c> rowList = new List<NE__Matrix_Parameter_Row__c>( );
        NE__Matrix_Parameter_Row__c rowParent = new NE__Matrix_Parameter_Row__c( );
        NE__Matrix_Parameter__c matrixParameter = new NE__Matrix_Parameter__c( );
        rowList.add( rowParent );

        Test.startTest( );
        OB_ConfigurationDetailsCABController.updateRows( rowList );
        Test.stopTest( );
    }

    @isTest
    public static void insertNewRowServer_test( )
    {
        NE__Matrix_Parameter__c matrixParameter = new NE__Matrix_Parameter__c( );
        NE__Matrix_Parameter_Row__c newRow = new NE__Matrix_Parameter_Row__c( );

        Test.startTest( );
        OB_ConfigurationDetailsCABController.insertNewRowServer( newRow, null, matrixParameter );
        Test.stopTest( );
    }

    @isTest
    public static void deleteSelectedRow_test( )
    {
        Test.startTest( );
        OB_ConfigurationDetailsCABController.deleteSelectedRow( new List<NE__Matrix_Parameter_Row__c>( ) );
        Test.stopTest( );
    }

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 27/03/2019
    * @description Method test insertCloneRow method. Parent Row is null
    */
    @isTest
    public static void insertCloneRowException_test( )
    {
        Test.startTest( );
        List<NE__Matrix_Parameter_Row__c> result = OB_ConfigurationDetailsCABController.insertCloneRow( null, null );
        Test.stopTest( );
        System.assertEquals( 0, result.size( ) );
    }
}