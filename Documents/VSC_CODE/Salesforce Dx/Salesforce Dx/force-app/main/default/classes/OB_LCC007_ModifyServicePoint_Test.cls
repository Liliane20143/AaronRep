/*
 * Created by damian krzyzaniak on 15.07.2019
*/
@IsTest
public with sharing class OB_LCC007_ModifyServicePoint_Test
{
    /*******************************************************************************
    Purpose:  Method to prepare data for tests
    Parameters: -
    Returns: OB_LCC007_ModifyServicePoint.SearchResultWrapper

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Damian Krzyzaniak       16/07/2019      Created         NEXI-184
    ********************************************************************************/
    private static OB_LCC007_ModifyServicePoint.SearchResultWrapper prepareTestData( )
    {

        NE__Service_Point__c testServicePoint = OB_TestDataFactory.getServicePoint( );
        testServicePoint.NE__City__c = 'test city';
        insert testServicePoint;

        OB_LCC007_ModifyServicePoint.SearchResultWrapper testResultWrapper = new OB_LCC007_ModifyServicePoint.SearchResultWrapper( );
        testResultWrapper.acc = null;
        testResultWrapper.errorMessage = 'test';
        testResultWrapper.listOfServicePoint = new List<NE__Service_Point__c>( );
        testResultWrapper.listOfServicePoint.add( testServicePoint );
        testResultWrapper.executor = null;
        testResultWrapper.selectedServicePoint = '';
        testResultWrapper.selectedServicePointExt = '';
        testResultWrapper.executorModifiedAllowed = true;
        testResultWrapper.lovList = null;
        testResultWrapper.outcome = '';
        testResultWrapper.legalOffice = null;
        testResultWrapper.selectedMerchantExt = '';
        testResultWrapper.selectedMerchantAsset = '';
        testResultWrapper.selectedServicePointAsset = '';
        testResultWrapper.selectedAsset = null;
        testResultWrapper.selectServicePointListId = null;

        return testResultWrapper;
    }

    /*******************************************************************************
    Purpose:  Method to check retrieval of service point in happy flow
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Damian Krzyzaniak       15/07/2019      Created         NEXI-184
    ********************************************************************************/
    @IsTest
    private static void retrieveServicePointTest( )
    {
        OB_LCC007_ModifyServicePoint.SearchResultWrapper preparedDataWrapper = OB_LCC007_ModifyServicePoint_Test.prepareTestData( );
        Map<String, String> testResponse = OB_LCC007_ModifyServicePoint.retrieveDataForServicePoint( preparedDataWrapper.listOfServicePoint.get( 0 ).Id );

        OB_LCC007_ModifyServicePoint.SearchResultWrapper testResultWrapper = ( OB_LCC007_ModifyServicePoint.SearchResultWrapper ) JSON.deserialize( testResponse.get( 'result' ), OB_LCC007_ModifyServicePoint.SearchResultWrapper.class );
        NE__Service_Point__c responseServicePoint = testResultWrapper.listOfServicePoint.get( 0 );
        System.assertEquals( 'test city', responseServicePoint.NE__City__c );
    }

    /*******************************************************************************
    Purpose:  Method to check retrieval of service point when param is blank string
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Damian Krzyzaniak       16/07/2019      Created         NEXI-184
    ********************************************************************************/
    @IsTest
    private static void retrieveServicePointNullTest( )
    {
        Map<String, String> testResponse = OB_LCC007_ModifyServicePoint.retrieveDataForServicePoint( null );
        OB_LCC007_ModifyServicePoint.SearchResultWrapper testResultWrapper = ( OB_LCC007_ModifyServicePoint.SearchResultWrapper ) JSON.deserialize( testResponse.get( 'result' ), OB_LCC007_ModifyServicePoint.SearchResultWrapper.class );
        System.assertEquals( 'OB_LCC007_ModifyServicePoint.retrieveServicePoint: Empty or null inServicePointId', testResultWrapper.errorMessage );
    }

    /*******************************************************************************
    Purpose:  Method to check retrieval of service point when param is invalid string
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Damian Krzyzaniak       16/07/2019      Created         NEXI-184
    ********************************************************************************/
    @IsTest
    private static void retrieveServicePointInvalidDataTest( )
    {
        Map<String, String> testResponse = OB_LCC007_ModifyServicePoint.retrieveDataForServicePoint( '123456789012345' );
        OB_LCC007_ModifyServicePoint.SearchResultWrapper testResultWrapper = ( OB_LCC007_ModifyServicePoint.SearchResultWrapper ) JSON.deserialize( testResponse.get( 'result' ), OB_LCC007_ModifyServicePoint.SearchResultWrapper.class );
        System.assert( testResultWrapper.listOfServicePoint.isEmpty( ) );
        System.assertEquals( 'OB_LCC007_ModifyServicePoint.retrieveServicePoint: Query returned nothing', testResultWrapper.errorMessage );
    }

}