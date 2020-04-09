/**************************************************************
* Date Created       : 13/11/2018  
* Author             : Doris Tatiana
* Class name to test : OB_ConfigurationDetailsNexiController
***************************************************************
*/

@isTest
public class OB_ConfigurationDetailsNexi_Test
{
    @isTest
    public static void getRowsByMatrixParameterId_Test( )
    {
        String offerName = 'test';
        String abi;
        List<NE__Matrix_Parameter_Row__c> rowList = new List<NE__Matrix_Parameter_Row__c>( );
        NE__Matrix_Parameter_Row__c rowParent = new NE__Matrix_Parameter_Row__c( );
        NE__Matrix_Parameter__c matrixParameter = new NE__Matrix_Parameter__c( );
        rowParent.NE__Matrix_Parameter__c = matrixParameter.id;

        rowList.add( rowParent );

        Test.startTest( );
        OB_ConfigurationDetailsNexiController.getRowsByMatrixParameterId( offerName, abi, matrixParameter );
        Test.stopTest( );
    }

    @isTest
    public static void calculateDate_test( )
    {
        NE__Matrix_Parameter__c matrixParameter = new NE__Matrix_Parameter__c( );
        Date myDate = Date.newInstance( 1990, 11, 21 );
        Date newDate = myDate.addMonths( -1 );
        String startDate = String.valueOf( newDate );

        Test.startTest( );
        OB_ConfigurationDetailsNexiController.calculateDate( startDate );
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
        insert matrixParameter;

        rowParent.NE__Start_Date__c = myDate;
        rowParent.NE__Matrix_Parameter__c = matrixParameter.id;

        rowParent1.NE__Start_Date__c = newDate;
        rowParent1.NE__Matrix_Parameter__c = matrixParameter.id;

        List<NE__Matrix_Parameter_Row__c> rowChildren = new List<NE__Matrix_Parameter_Row__c>( );
        rowChildren.add( rowParent );
        rowChildren.add( rowParent1 );
        insert rowChildren;

        Test.startTest( );
        OB_ConfigurationDetailsNexiController.insertCloneRow( rowParent, rowChildren );
        Test.stopTest( );
    }

    @isTest
    public static void getChildCatalogItems_test( )
    {
        List<NE__Catalog_Item__c> catalogItems = new List<NE__Catalog_Item__c>( );
        String productId;

        Test.startTest( );
        OB_ConfigurationDetailsNexiController.getChildCatalogItems( productId );
        Test.stopTest( );
    }

    @isTest
    public static void updateRows_test( )
    {
        List<NE__Matrix_Parameter_Row__c> rowList = new List<NE__Matrix_Parameter_Row__c>( );
        NE__Matrix_Parameter_Row__c rowParent = new NE__Matrix_Parameter_Row__c( );
        NE__Matrix_Parameter__c matrixParameter = new NE__Matrix_Parameter__c( );
        rowParent.NE__Matrix_Parameter__c = matrixParameter.id;
        rowList.add( rowParent );

        Test.startTest( );
        OB_ConfigurationDetailsNexiController.updateRows( rowList );
        Test.stopTest( );
    }

    @isTest
    public static void insertNewRowServer_test( )
    {
        String componente;
        NE__Matrix_Parameter__c matrixParameter = new NE__Matrix_Parameter__c( );
        NE__Matrix_Parameter_Row__c newRow = new NE__Matrix_Parameter_Row__c( );

        Test.startTest( );
        OB_ConfigurationDetailsNexiController.insertNewRowServer( newRow, componente, matrixParameter );
        Test.stopTest( );
    }

    @isTest
    public static void deleteSelectedRow_test( )
    {
        List<NE__Matrix_Parameter_Row__c> listToDelete = new List<NE__Matrix_Parameter_Row__c>( );
        Test.startTest( );
        OB_ConfigurationDetailsNexiController.deleteSelectedRow( listToDelete );
        Test.stopTest( );
    }

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 27/03/2019
    * @task Nex-005
    * @description Method test deleteSelectedRow method. Exception flow
    */
    @isTest
    public static void deleteSelectedRowException_test( )
    {
        NE__Matrix_Parameter__c matrixParameter = OB_TestDataFactory.getMatrixParameter( );
        insert matrixParameter;
        List<NE__Matrix_Parameter_Row__c> listToDelete = new List<NE__Matrix_Parameter_Row__c>( );
        listToDelete.add( OB_TestDataFactory.getMatrixParameterRow( matrixParameter.id ) );
        insert listToDelete;
        delete listToDelete;
        Test.startTest( );
        OB_ConfigurationDetailsNexiController.deleteSelectedRow( listToDelete );
        Test.stopTest( );
    }

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 27/03/2019
    * @task Nex-005
    * @description Method test insertNewRowServer method. Happy flow
    */
    @isTest
    public static void insertNewRowServerHappy_test( )
    {
        NE__Matrix_Parameter__c matrixParameter = OB_TestDataFactory.getMatrixParameter( );
        insert matrixParameter;
        NE__Matrix_Parameter_Row__c newRow = OB_TestDataFactory.getMatrixParameterRow( matrixParameter.id );
        Test.startTest( );
        OB_ConfigurationDetailsNexiController.insertNewRowServer( newRow, null, matrixParameter );
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
        List<NE__Matrix_Parameter_Row__c> result = OB_ConfigurationDetailsNexiController.insertCloneRow( null, null );
        Test.stopTest( );
        System.assertEquals( 0, result.size( ) );
    }
}