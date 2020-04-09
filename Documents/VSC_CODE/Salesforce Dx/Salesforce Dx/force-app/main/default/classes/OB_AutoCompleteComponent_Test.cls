/*******************************************************************************
Purpose:  ?

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         ?                       ?               Created         ?
1.1         Adrian Dlugolecki       11/04/2019      Refactor        Format, delete not necessary code and add System Asserts
********************************************************************************/
@isTest
public class OB_AutoCompleteComponent_Test
{
    @isTest
    public static void getResultTest( )
    {
        System.assertEquals( null, AutoCompleteComponentController.getResult( 'response', 'url' ) );
    }

    @isTest
    public static void getCapsTest( )
    {
        System.assertEquals( 1, AutoCompleteComponentController.getCaps( 'via%20Colbricon', '7985' ).size( ) );
    }


    @isTest
    public static void getProvinceTest( )
    {
        System.assertEquals( 1, AutoCompleteComponentController.getProvince( ).size( ) );
    }

    @isTest
    public static void getCitiesTest( )
    {
        System.assertEquals( 1, AutoCompleteComponentController.getCities( 'input', 'idField' ).size( ) );
    }

    @isTest
    public static void getDistrictTest( )
    {
        System.assertEquals( 1, AutoCompleteComponentController.getDistrict( null, null ).size( ) );
    }

    @isTest
    public static void getStreetTest( )
    {
        System.assertEquals( 1, AutoCompleteComponentController.getStreet( 'input', 'idField' ).size( ) );
    }

    @isTest
    public static void getCadastrialCodeTest( )
    {
        OB_Integration_Configuration__c intConfig = new OB_Integration_Configuration__c( );
        intConfig.Name = 'DEV1';
        intConfig.OB_Token_1__c = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.qa0AjHQKKaYZp6c2zuNOYdz2yGwwzg94HPEur7qFs6TXBN9d30f77fE2-miROIogX56Y_KFRr-iS2K2-la_GrYuM-D-IZoWaL4QeHUlbiS5FRCGJ_SH18IsIU4nM_TavRiVpwMEgIBnvxSUTfk0cOGW-SgbkGTWptZnDC6hM';
        intConfig.OB_timestamp__c = '2389990';
        insert intConfig;
        Test.setMock( HttpCalloutMock.class, new MockGetCadastrialCode( ) );
        Test.startTest( );
        System.assert( !String.isBlank( AutoCompleteComponentController.getCadastrialCode( 'url' ) ) );
        Test.stopTest( );
    }
}