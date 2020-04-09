/**************************************************************
* Date Created       : 13/11/2018  
* Author             : Doris Tatiana
* Class name to test : OB_ConfigurationDetailsController
***************************************************************
*/

@isTest
public with sharing class OB_ConfigurationDetailsController_Test
{
    @isTest
    public static void getRowsByMatrixParameterId_Test( )
    {
        Id recordTypeId = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName( ).get( 'OB_PriceNexi' ).getRecordTypeId( );

        String offerName = 'test';
        List<NE__Matrix_Parameter_Row__c> rowList = new List<NE__Matrix_Parameter_Row__c>( );
        NE__Matrix_Parameter_Row__c rowParent = new NE__Matrix_Parameter_Row__c( );
        NE__Matrix_Parameter__c matrixParameter = new NE__Matrix_Parameter__c( Name = 'test' );

        matrixParameter.NE__Active__c = true;
        matrixParameter.NE__Start_Date__c = Date.newInstance( 2018, 2, 9 );
        insert matrixParameter;

        rowParent.NE__Matrix_Parameter__c = matrixParameter.id;
        rowParent.RecordTypeId = recordTypeId;
        rowList.add( rowParent );
        insert rowList;

        Test.startTest( );
        OB_ConfigurationDetailsController.getRowsByMatrixParameterId( offerName, matrixParameter );
        Test.stopTest( );
    }

    @isTest
    public static void calculateDate_test( )
    {
        Date myDate = Date.newInstance( 1990, 11, 21 );
        Date newDate = myDate.addMonths( -1 );
        String startDate = String.valueOf( newDate );

        Test.startTest( );
        OB_ConfigurationDetailsController.calculateDate( startDate );
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
        //insert rowParent;

        rowParent1.NE__Start_Date__c = newDate;
        rowParent1.NE__Matrix_Parameter__c = matrixParameter.id;

        List<NE__Matrix_Parameter_Row__c> rowChildren = new List<NE__Matrix_Parameter_Row__c>( );
        rowChildren.add( rowParent );
        rowChildren.add( rowParent1 );
        insert rowChildren;

        Test.startTest( );
        OB_ConfigurationDetailsController.insertCloneRow( rowParent, rowChildren );
        Test.stopTest( );
    }

    @isTest
    public static void getCatalogItems_test( )
    {
        String searchText;
        String itemHeader;

        Test.startTest( );
        OB_ConfigurationDetailsController.getCatalogItems( searchText, itemHeader );
        Test.stopTest( );
    }

    @isTest
    public static void getChildCatalogItems_test( )
    {
        String rootCatalogItem;

        Test.startTest( );
        OB_ConfigurationDetailsController.getChildCatalogItems( rootCatalogItem );
        Test.stopTest( );
    }

    @isTest
    public static void updateRows_test( )
    {
        //String itemHeader;
        NE__Item_Header__c itemHeader = new NE__Item_Header__c( );
        itemHeader.Name = 'Test';
        insert itemHeader;
        NE__Product__c product = new NE__Product__c( );
        product.OB_Codice_sfdc__c = 'PRE-AUT';
        insert product;

        NE__Catalog__c catalog = new NE__Catalog__c( );
        catalog.Name = 'Nexi';
        catalog.NE__Active__c = false;
        insert catalog;

        Id recordTypePricing = Schema.SObjectType.NE__Catalog_Item__c.getRecordTypeInfosByName( ).get( 'Pricing' ).getRecordTypeId( );
        List<NE__Catalog_Item__c> catalogItems = new List<NE__Catalog_Item__c>( );

        NE__Catalog_Item__c catalogItem = new NE__Catalog_Item__c( );
        catalogItem.NE__Type__c = 'Child-Product';
        catalogItem.NE__Catalog_Id__c = catalog.id ;
        catalogItem.RecordTypeId = recordTypePricing;
        catalogItem.NE__ProductId__c = product.id;
        catalogItem.NE__Product_Category_Name__c = 'COMPONENTI DI PREZZO';
        insert catalogItem;

        NE__Catalog_Item__c catalogItem2 = new NE__Catalog_Item__c( );
        catalogItem2.NE__Type__c = 'Child-Product';
        catalogItem2.NE__Item_Header__c = itemHeader.Id ;
        catalogItem2.NE__Catalog_Id__c = catalog.id;
        catalogItem2.NE__Parent_Catalog_Item__c = catalogItem.Id ;
        catalogItem2.NE__ProductId__c = product.id;

        NE__Catalog_Item__c catalogItem3 = new NE__Catalog_Item__c( );
        catalogItem3.NE__Type__c = 'Category';
        catalogItem3.NE__Item_Header__c = itemHeader.Id ;
        catalogItem3.NE__Product_Category_Name__c = 'COMPONENTI DI PREZZO';
        catalogItem3.NE__Catalog_Id__c = catalog.id;
        catalogItem3.NE__Parent_Catalog_Item__c = catalogItem.Id ;
        catalogItem3.NE__ProductId__c = product.id;

        catalogItems.add( catalogItem2 );
        catalogItems.add( catalogItem3 );
        insert catalogItems;

        List<NE__Matrix_Parameter_Row__c> rowList = new List<NE__Matrix_Parameter_Row__c>( );
        NE__Matrix_Parameter_Row__c rowParent = new NE__Matrix_Parameter_Row__c( );
        rowParent.OB_product__c = product.id;
        rowParent.OB_Componente__c = null;
        rowParent.OB_SelfLookup__c = null;
        rowParent.NE__Active__c = true;

        NE__Matrix_Parameter__c matrixParameter = new NE__Matrix_Parameter__c( );
        matrixParameter.NE__Active__c = true;
        matrixParameter.NE__Start_Date__c = Date.newInstance( 2018, 2, 9 );
        insert matrixParameter;
        rowParent.NE__Matrix_Parameter__c = matrixParameter.id;
        rowList.add( rowParent );
        insert rowList;

        Map<String, List<NE__Matrix_Parameter_Row__c>> mapProductIdRows = new Map<String, List<NE__Matrix_Parameter_Row__c>>( );
        mapProductIdRows.put( string.valueOf( rowParent.OB_product__c ), rowList );

        Test.startTest( );
        OB_ConfigurationDetailsController.updateRows( rowList, itemHeader.id );
        Test.stopTest( );
    }

    @isTest
    public static void insertNewRowServer_test( )
    {
        String componente;
        Id recordTypeId = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName( ).get( 'OB_PriceNexi' ).getRecordTypeId( );

        NE__Matrix_Parameter__c matrixParameter = new NE__Matrix_Parameter__c( );
        //insert matrixParameter;
        NE__Matrix_Parameter_Row__c newRow = new NE__Matrix_Parameter_Row__c( );
        newRow.RecordTypeId = recordTypeId;
        //insert newRow;

        Test.startTest( );
        OB_ConfigurationDetailsController.insertNewRowServer( newRow, componente, matrixParameter );
        Test.stopTest( );
    }

    @isTest
    public static void getFamiliesServer_test( )
    {
        Test.startTest( );
        OB_ConfigurationDetailsController.getFamiliesServer( null );
        Test.stopTest( );
    }

    @isTest
    public static void getFamiliesForChildrenRowsServer_test( )
    {
        List<NE__Product__c> products = new List<NE__Product__c>( );
        NE__Product__c product = new NE__Product__c( );
        product.Name = 'OneClick';
        products.add( product );
        insert products;

        NE__Family__c famille = new NE__Family__c( );
        famille.NE__Hidden__c = false;
        insert famille;

        List<NE__ProductFamily__c> listToReturn = new List<NE__ProductFamily__c>( );
        NE__ProductFamily__c productFamily = new NE__ProductFamily__c( );
        productFamily.NE__ProdId__c = product.id;
        productFamily.NE__FamilyId__c = famille.id;
        listToReturn.add( productFamily );
        insert listToReturn;

        Test.startTest( );
        OB_ConfigurationDetailsController.getFamiliesForChildrenRowsServer( products );
        Test.stopTest( );
    }

    @isTest
    public static void retrieveAttributesFromFamilies_test( )
    {
        List<NE__family__c> families = new List<NE__family__c>( );
        NE__Family__c famille = new NE__Family__c( );
        families.add( famille );
        insert families;

        Test.startTest( );
        OB_ConfigurationDetailsController.retrieveAttributesFromFamilies( families );
        Test.stopTest( );
    }

    @isTest
    public static void deleteSelectedRow_test( )
    {
        List<NE__Matrix_Parameter_Row__c> listToDelete = new List<NE__Matrix_Parameter_Row__c>( );

        Test.startTest( );
        OB_ConfigurationDetailsController.deleteSelectedRow( listToDelete );
        Test.stopTest( );
    }

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 25/03/2019
    * @description Method test insertNewRowsServer method. Happy flow
    */
    @isTest
    public static void insertNewRowsServer_test( )
    {
        NE__Matrix_Parameter__c matrixParameter = OB_TestDataFactory.getMatrixParameter( );
        insert matrixParameter;

        NE__Matrix_Parameter_Row__c parentMatrixParameter = new NE__Matrix_Parameter_Row__c( );

        List<NE__Matrix_Parameter_Row__c> childMatrixParameterRows = new List<NE__Matrix_Parameter_Row__c>( );
        childMatrixParameterRows.add( new NE__Matrix_Parameter_Row__c( ) );

        Test.startTest( );
        List<NE__Matrix_Parameter_Row__c> result = OB_ConfigurationDetailsController.insertNewRowsServer( childMatrixParameterRows, parentMatrixParameter, matrixParameter.id, matrixParameter );
        Test.stopTest( );

        System.assertEquals( 1, result.size( ) );
    }

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 25/03/2019
    * @description Method test insertNewRowsServer method. Exception on parent MPR
    */
    @isTest
    public static void insertNewRowsServerBadParentMpr_test( )
    {
        NE__Matrix_Parameter__c matrixParameter = OB_TestDataFactory.getMatrixParameter( );
        insert matrixParameter;

        Account badData = OB_TestDataFactory.getAccount( );
        insert badData;

        NE__Matrix_Parameter_Row__c parentMatrixParameter = OB_TestDataFactory.getMatrixParameterRow( matrixParameter.id );
        parentMatrixParameter.OB_Product__c = badData.id;
        Test.startTest( );
        List<NE__Matrix_Parameter_Row__c> result = OB_ConfigurationDetailsController.insertNewRowsServer( new List<NE__Matrix_Parameter_Row__c>( ), parentMatrixParameter, matrixParameter.id, matrixParameter );
        Test.stopTest( );
        System.assertEquals( null, result );
    }

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 25/03/2019
    * @description Method test insertNewRowsServer method. Exception on child MPR
    */
    @isTest
    public static void insertNewRowsServerBadChildMpr_test( )
    {
        NE__Matrix_Parameter__c matrixParameter = OB_TestDataFactory.getMatrixParameter( );
        insert matrixParameter;

        Account badData = OB_TestDataFactory.getAccount( );
        insert badData;

        List<NE__Matrix_Parameter_Row__c> childMatrixParameterRows = new List<NE__Matrix_Parameter_Row__c>( );
        childMatrixParameterRows.add( new NE__Matrix_Parameter_Row__c( OB_Product__c = badData.id ) );

        Test.startTest( );
        List<NE__Matrix_Parameter_Row__c> result = OB_ConfigurationDetailsController.insertNewRowsServer( childMatrixParameterRows, new NE__Matrix_Parameter_Row__c( ), matrixParameter.id, matrixParameter );
        Test.stopTest( );
        System.assertEquals( null, result );
    }


    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 25/03/2019
    * @description Method test updateRows method. Product mapped
    */
    @isTest
    public static void updateRowsProductMapped_test( )
    {
        NE__Product__c product = new NE__Product__c( );
        product.OB_Codice_sfdc__c = 'PRE-AUT';
        insert product;

        NE__Item_Header__c itemHeader = new NE__Item_Header__c( );
        itemHeader.Name = 'Test';
        insert itemHeader;

        NE__Catalog__c catalog = new NE__Catalog__c( );
        catalog.Name = 'Nexi';
        catalog.NE__Active__c = false;
        insert catalog;

        NE__Catalog_Item__c catalogItem = new NE__Catalog_Item__c( );
        catalogItem.NE__Type__c = 'Category';
        catalogItem.NE__Catalog_Id__c = catalog.id ;
        catalogItem.NE__ProductId__c = product.id;
        catalogItem.NE__Product_Category_Name__c = 'COMPONENTI DI PREZZO';
        catalogItem.NE__Item_Header__c = itemHeader.id;
        insert catalogItem;

        NE__Matrix_Parameter__c matrixParameter = OB_TestDataFactory.getMatrixParameter( );
        matrixParameter.NE__Active__c = true;
        matrixParameter.NE__Start_Date__c = Date.newInstance( 2018, 2, 9 );
        insert matrixParameter;

        List<NE__Matrix_Parameter_Row__c> rowList = new List<NE__Matrix_Parameter_Row__c>( );

        NE__Matrix_Parameter_Row__c rowParent = OB_TestDataFactory.getMatrixParameterRow( matrixParameter.id );
        rowParent.OB_product__c = product.id;
        rowParent.OB_Componente__c = null;
        rowParent.OB_SelfLookup__c = null;
        rowParent.NE__Active__c = true;
        insert rowParent;
        rowList.add( rowParent );

        Test.startTest( );
        List<NE__Matrix_Parameter_Row__c> result = OB_ConfigurationDetailsController.updateRows( rowList, itemHeader.id );
        Test.stopTest( );
        System.assertEquals( 1, result.size( ) );
    }

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 25/03/2019
    * @description Method test updateRows method. Empty input list
    */
    @isTest
    public static void updateRowsEmpty_test( )
    {
        List<NE__Matrix_Parameter_Row__c> rowList = new List<NE__Matrix_Parameter_Row__c>( );
        Test.startTest( );
        List<NE__Matrix_Parameter_Row__c> result = OB_ConfigurationDetailsController.updateRows( rowList, '' );
        Test.stopTest( );
        System.assertEquals( 0, result.size( ) );
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
        List<NE__Matrix_Parameter_Row__c> result = OB_ConfigurationDetailsController.insertCloneRow( null, null );
        Test.stopTest( );
        System.assertEquals( 0, result.size( ) );
    }
}