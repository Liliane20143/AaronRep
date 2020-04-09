/**************************************************************
* Date Created       : 13/11/2018  
* Author             : Doris Tatiana
* Class name to test : OB_ConfigurationDetailsBankController
***************************************************************
*/

@isTest
public with sharing class OB_ConfigurationDetailsBank_Test
{
    @isTest
    public static void getUserABIServer_test( )
    {
        Test.startTest( );
        OB_ConfigurationDetailsBankController.getUserABIServer( UserInfo.getUserId( ) );
        Test.stopTest( );
    }

    @isTest
    public static void getRowsByMatrixParameterId_test( )
    {
        NE__Matrix_Parameter__c matrixParameter = new NE__Matrix_Parameter__c( Name = 'test' );
        insert matrixParameter;
        String abi = '21333';
        String offerName = 'test';

        Test.startTest( );
        OB_ConfigurationDetailsBankController.getRowsByMatrixParameterId( matrixParameter, abi, offerName );
        Test.stopTest( );
    }

    @isTest
    public static void calculateDate_test( )
    {
        Date myDate = Date.newInstance( 1990, 11, 21 );
        Date newDate = myDate.addMonths( -1 );
        String startDate = String.valueOf( newDate );

        Test.startTest( );
        OB_ConfigurationDetailsBankController.calculateDate( startDate );
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
        List<List<NE__Matrix_Parameter_Row__c>> rowChildrens = new List<List<NE__Matrix_Parameter_Row__c>>( );
        rowChildrens.add( rowChildren );
        Test.startTest( );
        OB_ConfigurationDetailsBankController.insertCloneRow( rowParent, rowChildren );
        Test.stopTest( );
    }

    @isTest
    public static void getChildCatalogItems_test( )
    {
        Test.startTest( );
        OB_ConfigurationDetailsBankController.getChildCatalogItems( null );
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
        OB_ConfigurationDetailsBankController.updateRows( rowList );
        Test.stopTest( );
    }

    @isTest
    public static void insertNewRowServer_test( )
    {
        NE__Matrix_Parameter__c matrixParameter = new NE__Matrix_Parameter__c( );
        NE__Matrix_Parameter_Row__c newRow = new NE__Matrix_Parameter_Row__c( );

        Test.startTest( );
        OB_ConfigurationDetailsBankController.insertNewRowServer( newRow, null, matrixParameter );
        Test.stopTest( );
    }

    @isTest
    public static void deleteSelectedRow_test( )
    {
        Test.startTest( );
        OB_ConfigurationDetailsBankController.deleteSelectedRow( new List<NE__Matrix_Parameter_Row__c>( ) );
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
        List<NE__Matrix_Parameter_Row__c> result = OB_ConfigurationDetailsBankController.insertCloneRow( null, null );
        Test.stopTest( );
        System.assertEquals( 0, result.size( ) );
    }
}