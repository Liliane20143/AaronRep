/*****************************************************************
Name:  ModalLookupController_Test
Copyright © 2016 ITC
============================================================
Purpose:  Class tests ModalLookupController methods
History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0      Kinga Fornal            1406/2019         Created              ---
********************************************************************************/
@isTest
public with sharing class ModalLookupController_Test
{
    /*******************************************************************************
    Purpose:  Method creates and inserts Lov
    Parameters: Id lovId
    Returns: NE__Lov__c

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       12/06/2019      Created         NEXI-81
    ********************************************************************************/
    private static NE__Lov__c coreDataToGetLovs( Id lovId )
    {
        NE__Lov__c testLov = new NE__Lov__c( Name = 'testLov', NE__Type__c = 'MCC', NE__Active__c = true );
        if ( lovId != null )
        {
            testLov.NE__Lov__c = lovId;
        }
        insert testLov;

        return testLov;
    }

    /*******************************************************************************
    Purpose:  Method creates and inserts Account, Contact and User
    Parameters: -
    Returns: User

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       12/06/2019      Created         NEXI-81
    1.1         Joanna Mielczarek       02/07/2019      Modified        NEXI-143 create community user as admin
    ********************************************************************************/
    private static User coreDataToGetUser( )
    {
        User portalAccountOwner = OB_TestDataFactory.getPortalAccountOwner( );
        insert portalAccountOwner;

        User testCommunityUser;

        System.runAs( portalAccountOwner )
        {
            Account testAccount = OB_TestDataFactory.getAccount( );
            insert testAccount;
            Contact testContact = OB_TestDataFactory.getContact( testAccount );
            insert testContact;
            testCommunityUser = OB_TestDataFactory.getCommunityUser( testContact );
            testCommunityUser.ProfileId = OB_TestDataFactory.getNexiPartnerUserProfile( ).Id;
            insert testCommunityUser;

        }
        return testCommunityUser;
    }

    /*******************************************************************************
    Purpose:  Method tests retrieving Lovs - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               ?               ?
    2.0         Joanna Mielczarek       12/06/2019      Modified        NEXI-81 added assertion
    ********************************************************************************/
    @isTest static void getLovsByTypeTest( )
    {
        NE__Lov__c testLov = new NE__Lov__c( Name = 'test', NE__Active__c = true, NE__Type__c = '', NE__Sub_Type__c = '' );
        insert testLov;

        Map<String, String> mapOfSourceFieldTargetField = new Map<String, String>( );
        mapOfSourceFieldTargetField.put( 'myKey', 'Name' );
        Map<String, String> mapLabelColumns = new Map<String, String>( );
        mapLabelColumns.put( 'NE__Country__c', 'myValue' );

        Test.startTest( );
        List<NE__LOV__c> result = ModalLookupController.getLovsByType( '', 'test', 'Name', '',
                mapOfSourceFieldTargetField, mapLabelColumns, 'NE__Sequence__c', 'DESC', '', '', '' );
        System.assertEquals( 1, result.size( ) );
        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:  Method tests retrieving Lovs - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               ?               ?
    2.0         Joanna Mielczarek       12/06/2019      Modified        NEXI-81 added assertion
    ********************************************************************************/
    @isTest static void getLovsByTypeTest1( )
    {
        NE__Lov__c testLov = new NE__Lov__c( Name = 'test', NE__Active__c = true, NE__Type__c = '', NE__Sub_Type__c = '',
                NE__Value3__c = 'L1' );
        insert testLov;

        Map<String, String> mapOfSourceFieldTargetField = new Map<String, String>( );
        mapOfSourceFieldTargetField.put( 'myKey', 'Name' );
        Map<String, String> mapLabelColumns = new Map<String, String>( );
        mapLabelColumns.put( 'NE__Country__c', 'myValue' );

        Test.startTest( );
        List<NE__LOV__c> result = ModalLookupController.getLovsByType( '', '', '', '',
                mapOfSourceFieldTargetField, mapLabelColumns, 'NE__Sequence__c', 'DESC', '', 'L1', '' );
        System.assertEquals( 1, result.size( ) );
        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:  Method tests retrieving Lovs - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               ?               ?
    2.0         Joanna Mielczarek       12/06/2019      Modified        NEXI-81 added assertion
    ********************************************************************************/
    @isTest static void getLovsByTypeTest2( )
    {
        NE__Lov__c testLovL1 = new NE__Lov__c( Name = 'ALL', NE__Value3__c = 'L1' );
        insert testLovL1;
        NE__Lov__c testLovL2 = new NE__Lov__c( Name = 'test', NE__Active__c = true, NE__Type__c = '', NE__Sub_Type__c = '',
                NE__Value3__c = 'L2', NE__Lov__c = testLovL1.Id );
        insert testLovL2;

        Map<String, String> mapOfSourceFieldTargetField = new Map<String, String>( );
        mapOfSourceFieldTargetField.put( 'myKey', 'Name' );
        Map<String, String> mapLabelColumns = new Map<String, String>( );
        mapLabelColumns.put( 'NE__Country__c', 'myValue' );

        Test.startTest( );
        List<NE__LOV__c> result = ModalLookupController.getLovsByType( '', '', '', '',
                mapOfSourceFieldTargetField, mapLabelColumns, 'NE__Sequence__c', 'DESC', '', 'L2', '' );
        System.assertEquals( 1, result.size( ) );
        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:  Method tests retrieving Lovs - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               ?               ?
    2.0         Joanna Mielczarek       12/06/2019      Modified        NEXI-81 added assertion
    ********************************************************************************/
    @isTest static void getLovsByTypeTest3( )
    {
        NE__Lov__c testLovL2 = new NE__Lov__c( Name = 'test', NE__Active__c = true, NE__Type__c = '',
                NE__Sub_Type__c = '', NE__Value3__c = 'L2' );
        insert testLovL2;
        NE__Lov__c testLovL3 = new NE__Lov__c( Name = 'test', NE__Active__c = true, NE__Type__c = '',
                NE__Sub_Type__c = '', NE__Value3__c = 'L3', NE__Lov__c = testLovL2.Id );
        insert testLovL3;

        Map<String, String> mapOfSourceFieldTargetField = new Map<String, String>( );
        mapOfSourceFieldTargetField.put( 'myKey', 'Name' );
        Map<String, String> mapLabelColumns = new Map<String, String>( );
        mapLabelColumns.put( 'NE__Country__c', 'myValue' );

        Test.startTest( );
        List<NE__LOV__c> result = ModalLookupController.getLovsByType( '', '', '', '',
                mapOfSourceFieldTargetField, mapLabelColumns, 'NE__Sequence__c', 'DESC', '', 'L3', '' );
        System.assertEquals( 1, result.size( ) );
        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:  Method tests retrieving Lovs - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               ?               ?
    2.0         Joanna Mielczarek       12/06/2019      Modified        NEXI-81 added assertion
    ********************************************************************************/
    @isTest static void getLovsByTypeTestInput( )
    {
        NE__Lov__c testLov = new NE__Lov__c( Name = 'test', NE__Active__c = true, NE__Type__c = '', NE__Sub_Type__c = '' );
        insert testLov;

        Map<String, String> mapOfSourceFieldTargetField = new Map<String, String>( );
        mapOfSourceFieldTargetField.put( 'myKey', 'Name' );
        Map<String, String> mapLabelColumns = new Map<String, String>( );
        mapLabelColumns.put( 'NE__Country__c', 'myValue' );

        Test.startTest( );
        List<NE__LOV__c> result = ModalLookupController.getLovsByType( '', '', '', 'test',
                mapOfSourceFieldTargetField, mapLabelColumns, 'NE__Sequence__c', 'DESC', '', '', '' );
        System.assertEquals( 1, result.size( ) );
        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:  Method tests retrieving Lovs - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               ?               ?
    2.0         Joanna Mielczarek       12/06/2019      Modified        NEXI-81 added assertion
    ********************************************************************************/
    @isTest static void getLovsByTypeTestInputL1( )
    {
        NE__Lov__c testLov = new NE__Lov__c( Name = 'test', NE__Active__c = true, NE__Type__c = '',
                NE__Sub_Type__c = 'subType', NE__Value3__c = 'L1' );
        insert testLov;

        Map<String, String> mapOfSourceFieldTargetField = new Map<String, String>( );
        mapOfSourceFieldTargetField.put( 'myKey', 'Name' );
        Map<String, String> mapLabelColumns = new Map<String, String>( );
        mapLabelColumns.put( 'NE__Country__c', 'myValue' );

        Test.startTest( );
        List<NE__LOV__c> result = ModalLookupController.getLovsByType( '', 'subType', 'NE__Sub_Type__c', 'test',
                mapOfSourceFieldTargetField, mapLabelColumns, 'NE__Sequence__c', 'DESC', '', 'L1', '' );
        System.assertEquals( 1, result.size( ) );
        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:  Method tests retrieving Lovs - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               ?               ?
    2.0         Joanna Mielczarek       12/06/2019      Modified        NEXI-81 added assertion
    ********************************************************************************/
    @isTest static void getLovsByTypeTestInputL2( )
    {
        NE__Lov__c testLovL1 = new NE__Lov__c( Name = 'ALL', NE__Value3__c = 'L1' );
        insert testLovL1;
        NE__Lov__c testLovL2 = new NE__Lov__c( Name = 'test', NE__Active__c = true, NE__Type__c = '', NE__Sub_Type__c = '',
                NE__Value3__c = 'L2', NE__Lov__c = testLovL1.Id );
        insert testLovL2;

        Map<String, String> mapOfSourceFieldTargetField = new Map<String, String>( );
        mapOfSourceFieldTargetField.put( 'myKey', 'Name' );
        Map<String, String> mapLabelColumns = new Map<String, String>( );
        mapLabelColumns.put( 'NE__Country__c', 'myValue' );

        Test.startTest( );
        List<NE__LOV__c> result = ModalLookupController.getLovsByType( '', '', '', 'test',
                mapOfSourceFieldTargetField, mapLabelColumns, 'NE__Sequence__c', 'DESC', '', 'L2', '' );
        System.assertEquals( 1, result.size( ) );
        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:  Method tests retrieving Lovs - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                       ?               ?               ?
    2.0         Joanna Mielczarek       12/06/2019      Modified        NEXI-81 added assertion
    ********************************************************************************/
    @isTest static void getLovsByTypeTestInputL3( )
    {
        NE__Lov__c testLov = new NE__Lov__c( Name = 'test', NE__Active__c = true, NE__Type__c = '', NE__Sub_Type__c = '', NE__Value3__c = 'L3' );
        insert testLov;

        Map<String, String> mapOfSourceFieldTargetField = new Map<String, String>( );
        mapOfSourceFieldTargetField.put( 'myKey', 'Name' );
        Map<String, String> mapLabelColumns = new Map<String, String>( );
        mapLabelColumns.put( 'NE__Country__c', 'myValue' );

        Test.startTest( );
        List<NE__LOV__c> result = ModalLookupController.getLovsByType( '', '', '', 'test',
                mapOfSourceFieldTargetField, mapLabelColumns, 'NE__Sequence__c', 'DESC', '', 'L3', '' );
        System.assertEquals( 1, result.size( ) );
        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:  Method tests retrieving Lovs - fail scenario with not existing field in query

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       12/06/2019      Created         NEXI-81
    ********************************************************************************/
    @isTest static void getLovsByTypeTestFail( )
    {
        Test.startTest( );
        List<NE__LOV__c> result = ModalLookupController.getLovsByType( '', '', '', 'failInput',
                new Map<String, String>( ), new Map<String, String>( ), '', '', 'failField', '', '' );
        System.assertEquals( 0, result.size( ) );
        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:  Method tests retrieving Lovs - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       12/06/2019      Created         NEXI-81
    1.1         Joanna Mielczarek       02/07/2019      Modified        NEXI-143 create lov as test user
    ********************************************************************************/
    @isTest static void getCabForApproverLevelServerSuccess( )
    {
        User testUser = coreDataToGetUser( );

        System.runAs( testUser )
        {
            NE__Lov__c testLov = new NE__Lov__c( Name = 'testL', NE__Active__c = true,
                    NE__Type__c = 'test', NE__Sub_Type__c = 'test', NE__Value1__c = 'test' );
            insert testLov;

            List<NE__Lov__c> result = ModalLookupController.getCabForApproverLevelServer( 'test', 'testL', 'test', 'test', 'testL' );
            System.assertEquals( 1, result.size( ) );
        }
    }

    /*******************************************************************************
    Purpose:  Method tests retrieving Lovs - fail scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       12/06/2019      Created         NEXI-81
    ********************************************************************************/
    @isTest static void getCabForApproverLevelServerFail( )
    {
        User testUser = coreDataToGetUser( );

        System.runAs( testUser )
        {
            System.assert( null == ModalLookupController.getCabForApproverLevelServer( 'test', '', 'test', 'test', '' ) );
        }
    }

    /*******************************************************************************
    Purpose:  Method tests retrieving Lovs - L2 level and existing records - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       12/06/2019      Created         NEXI-81
    ********************************************************************************/
    @isTest static void getLovsL2Success( )
    {
        NE__Lov__c testLov = coreDataToGetLovs( null );

        List<NE__Lov__c> result = ModalLookupController.getLovs( 'L2', String.valueOf( testLov.Id ) );
        System.assertEquals( 1, result.size( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests retrieving Lovs - L2 level and null Lov Id - fail scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       12/06/2019      Created         NEXI-81
    ********************************************************************************/
    @isTest static void getLovsL2EmptyId( )
    {
        List<NE__Lov__c> result = ModalLookupController.getLovs( 'L2', '' );
        System.assertEquals( 0, result.size( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests retrieving Lovs - L3 level and existing records - success scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       12/06/2019      Created         NEXI-81
    ********************************************************************************/
    @isTest static void getLovsL3Success( )
    {
        NE__Lov__c testLovL2 = coreDataToGetLovs( null );
        NE__Lov__c testLovL3 = coreDataToGetLovs( testLovL2.Id );

        List<NE__Lov__c> result = ModalLookupController.getLovs( 'L3', String.valueOf( testLovL2.Id ) );
        System.assertEquals( 1, result.size( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests retrieving Lovs - L3 level and null Lov Id - fail scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       12/06/2019      Created         NEXI-81
    ********************************************************************************/
    @isTest static void getLovsL3NullId( )
    {
        List<NE__Lov__c> result = ModalLookupController.getLovs( 'L3', '' );
        System.assertEquals( 0, result.size( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests retrieving Lovs - null level - fail scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       12/06/2019      Created         NEXI-81
    ********************************************************************************/
    @isTest static void getLovsNullLevel( )
    {
        NE__Lov__c testLov = coreDataToGetLovs( null );

        List<NE__Lov__c> result = ModalLookupController.getLovs( '', String.valueOf( testLov.Id ) );
        System.assertEquals( 0, result.size( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests retrieving Lovs - null level and Lov Id - fail scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       12/06/2019      Created         NEXI-81
    ********************************************************************************/
    @isTest static void getLovsNullParams( )
    {
        List<NE__Lov__c> result = ModalLookupController.getLovs( '', '' );
        System.assertEquals( 0, result.size( ) );
    }
}