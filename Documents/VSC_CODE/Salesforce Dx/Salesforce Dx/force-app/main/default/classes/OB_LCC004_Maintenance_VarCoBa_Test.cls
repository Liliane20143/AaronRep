/**
 * Created by adrian.dlugolecki on 10.05.2019.
 */
@IsTest
public with sharing class OB_LCC004_Maintenance_VarCoBa_Test
{

    /*******************************************************************************
    Purpose:  Method prepare data for all test from this class
    Parameters: -
    Returns: Id
  
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       10/05/2019      Created         NEXI-33
    1.1         Joanna Mielczarek       02/07/2019      Modified        NEXI-157 removed order and order item
    1.2         Joanna Mielczarek       02/07/2019      Modified        NEXI-143 added RAC SIA to asset
    ********************************************************************************/
    private static Id dataPreparation( )
    {
        NE__Service_Point__c sServicePoint = OB_TestDataFactory.getServicePoint( );
        insert sServicePoint;

        NE__Product__c pProduct = OB_TestDataFactory.getProduct( );
        pProduct.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.POS_RT ).getRecordTypeId( );
        insert pProduct;

        Asset aAsset = OB_TestDataFactory.getAsset( );
        aAsset.NE__Service_Point__c = sServicePoint.id;
        aAsset.NE__ProdId__c = pProduct.id;
        aAsset.NE__Status__c = 'Active';
        aAsset.OB_RAC_SIA__c = '1';
        insert aAsset;

        return sServicePoint.Id;
    }

    /*******************************************************************************
    Purpose:  Method test B_LCC004_Maintenance_VarCoBa.searchForRacSia
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       10/05/2019      Created         NEXI-33
    ********************************************************************************/
    @IsTest
    private static void searchForRacSiaTest( )
    {
        OB_LCC004_Maintenance_VarCoBa.searchForRacSia( dataPreparation( ) );
        System.assert( true );
    }

    /*******************************************************************************
    Purpose:  Method test B_LCC004_Maintenance_VarCoBa.getRelatedOrderItemsForRacSia
    Parameters: -
    Returns: -
 
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       16/05/2019      Created         NEXI-33
    1.1         Joanna Mielczarek       02/07/2019      Modified        NEXI-157 changed method name
    1.2         Joanna Mielczarek       02/07/2019      Modified        NEXI-143 changed assert to 1 value
    ********************************************************************************/
    @IsTest
    private static void getRelatedAssetsForRacSiaTest( )
    {
        System.assertEquals( 1, OB_LCC004_Maintenance_VarCoBa.getRelatedAssetsForRacSia( dataPreparation( ), '1' ).size( ) );
    }

    /*******************************************************************************
    Purpose:  Method test B_LCC004_Maintenance_VarCoBa.searchForRacSia exception
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       04/07/2019      Created         NEXI-163
    1.1         Adrian Dlugolecki       08/07/2019      Update          NEXI-188
    ********************************************************************************/
    @IsTest
    private static void searchForRacSiaExceptionTest( )
    {
        System.assert( OB_LCC004_Maintenance_VarCoBa.searchForRacSia( 'Give Me an error' ).racSiaCodes.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method test B_LCC004_Maintenance_VarCoBa.getRelatedAssetsForRacSia exception
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       04/07/2019      Created         NEXI-163
    ********************************************************************************/
    @IsTest
    private static void getRelatedAssetsForRacSiaExceptionTest( )
    {
        System.assert( OB_LCC004_Maintenance_VarCoBa.getRelatedAssetsForRacSia( 'Wrong Id', '123' ).isEmpty( ) );
    }
}