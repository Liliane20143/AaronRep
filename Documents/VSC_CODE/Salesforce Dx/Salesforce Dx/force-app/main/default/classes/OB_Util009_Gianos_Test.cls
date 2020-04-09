/*******************************************************************************
Purpose:  Class that test OB_Util009_Gianos
Parameters: -
Returns: -

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-202
********************************************************************************/
@isTest
public with sharing class OB_Util009_Gianos_Test
{
    /*******************************************************************************
    Purpose:  Core preparation method for all test of OB_Util009_Gianos
    Parameters: -
    Returns: Id

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-202
    1.1         Joanna Mielczarek       28/08/2019      Modified        NEXI-281 changed to public
    ********************************************************************************/
    public static Id coreDataPreparationForGianos( )
    {
        OB_Integration_Configuration__c integrationConfiguration = OB_TestDataFactory.getIntegrationConfiguration( );
        integrationConfiguration.OB_Token_1__c = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.ae0uhFv92QHdZMIxqofDkYrOwRH2dR7Axkni1Xzu1_dhE1ohL1lTp-2pyZ4O-QBnVNV7ulihyTc9DlVbMixGa813SFxwpAjIMrhqnG_xHQVnMLyi2-wE3dXZQcuwmw8NeqBM2Kg92NVpKADdcAEoQ7RAhxL0LJGuyhLJBXgZ';
        integrationConfiguration.OB_Timestamp__c = '1542025783107';
        insert integrationConfiguration;

        Account aAccount = OB_TestDataFactory.getAccount( );
        aAccount.NE__Fiscal_code__c = 'SMTJHN90A01F205S';
        aAccount.OB_No_Profit_Recipient_Class__c = 'Altro';
        aAccount.OB_No_Profit_Recipient_Other__c = 'TEST';
        aAccount.OB_No_Profit_Class__c = 'Associazioni riconosciute e non';
        aAccount.OB_Legal_Form__c = 'ORGANIZZAZIONE NON PROFIT/STRUTTURE ANALOGHE';
        aAccount.OB_Legal_Address_Country_Code__c = 'ITA';
        aAccount.OB_ATECO__c = '100';
        aAccount.OB_SAE_Code__c = '430';
        aAccount.OB_Annual_Revenue__c = 1;
        aAccount.OB_Annual_Negotiated__c = 1;
        aAccount.OB_Employees_Number__c = 'Minore di 10';
        aAccount.OB_Administrative_Office_Country__c = 'ITA';
        aAccount.OB_Legal_Address_Country__c = 'ITA';
        aAccount.NE__VAT__c = '11111111111';
        aAccount.OB_CCIAA_Province__c = 'MILANO';
        aAccount.OB_Legal_Address_State__c = 'MILANO';
        aAccount.OB_Legal_Address_State_Code__c = 'MI';//NEXI-319 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 09/09/2019
        insert aAccount;

        OB_Util009_Gianos.GianosResponseMerchant mockResponseMerchant = new OB_Util009_Gianos.GianosResponseMerchant( );
        mockResponseMerchant.vatNumber = aAccount.NE__VAT__c;
        mockResponseMerchant.taxCode = aAccount.NE__Fiscal_code__c;
        mockResponseMerchant.range = '1';
        mockResponseMerchant.score = '24';

        Contact executor = OB_TestDataFactory.getContact( aAccount );
        executor.OB_Fiscal_Code__c = aAccount.NE__Fiscal_code__c;
        executor.RecordTypeId = OB_Util009_Gianos.RECORD_TYPE_ESECUTORE;
        executor.OB_Birth_Date__c = Date.newInstance( 1990, 1, 1 );
        executor.OB_PEP__c = false;
        executor.OB_Citizenship__c = 'ITALIA';
        executor.OB_Country_Birth_Code__c = 'ITA';
        executor.OB_Address_Country_Code__c = 'ITA';
        executor.OB_Company_Link_Type__c = 'PROCURATORE/DELEGATO';
        executor.OB_Address_State__c = 'Milano';
        executor.OB_Address_State_Code__c = 'MI';//NEXI-319 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 09/09/2019
        insert executor;

        OB_Util009_Gianos.GianosResponseExecutorOrOwner mockResponseExecutor = new OB_Util009_Gianos.GianosResponseExecutorOrOwner( );
        mockResponseExecutor.fiscalCode = executor.OB_Fiscal_Code__c;
        mockResponseExecutor.range = '1';
        mockResponseExecutor.score = '25';

        Contact actualOwner = OB_TestDataFactory.getContact( aAccount );
        actualOwner.OB_Fiscal_Code__c = aAccount.NE__Fiscal_code__c;
        actualOwner.RecordTypeId = OB_Util009_Gianos.RECORD_TYPE_TITOLARE_EFFETTIVO;
        actualOwner.OB_Birth_Date__c = Date.newInstance( 1990, 1, 1 );
        actualOwner.OB_PEP__c = false;
        actualOwner.OB_Citizenship__c = 'ITALIA';
        actualOwner.OB_Country_Birth_Code__c = 'ITA';
        actualOwner.OB_Address_Country_Code__c = 'ITA';
        actualOwner.OB_Company_Link_Type__c = 'PROCURATORE/DELEGATO';
        actualOwner.OB_Address_State__c = 'Milano';
        insert actualOwner;
        //NEXI-319 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 09/09/2019 Start
        NE__Lov__c love = new NE__Lov__c( );
        love.Name = 'COUNTRY';
        love.NE__Value1__c = 'ITALIA';
        love.NE__Value2__c = 'ITA';
        love.NE__Value3__c = '380';
        insert love;
        //NEXI-319 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 09/09/2019 Stop

        OB_Util009_Gianos.GianosResponseExecutorOrOwner mockResponseOwner = new OB_Util009_Gianos.GianosResponseExecutorOrOwner( );
        mockResponseOwner.fiscalCode = actualOwner.OB_Fiscal_Code__c;
        mockResponseOwner.range = '1';
        mockResponseOwner.score = '26';

        OB_Util009_Gianos.GianosResponse response = new OB_Util009_Gianos.GianosResponse( );
        response.merchant = mockResponseMerchant;
        response.executor = mockResponseExecutor;
        response.actualOwners = new List<OB_Util009_Gianos.GianosResponseExecutorOrOwner> {mockResponseOwner};

        OB_Util009_Gianos_Mock.dataResponse = response;
        OB_Util009_Gianos_Mock.statusCode = 200;
        OB_Util009_Gianos_Mock.status = OB_UtilityConstants.TECHOUTCOME_OK;

        return aAccount.id;
    }

    /*******************************************************************************
    Purpose:  Method test call to Gianos from Log Request Object
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-202
    ********************************************************************************/
    @isTest
    private static void callToGianosForLogRequest( )
    {
        OB_Util009_Gianos.mockResponse = false;
        OB_LogRequest__c logRequest = new OB_LogRequest__c( );
        logRequest.OB_AccountId__c = coreDataPreparationForGianos( );
        insert logRequest;
        Test.setMock( HttpCalloutMock.class, new OB_Util009_Gianos_Mock( ) );
        Test.startTest( );
        OB_Util009_Gianos.callToGianos( logRequest.id, true );
        Test.stopTest( );
        OB_LogRequest__c result = [ SELECT OB_Gianos__c FROM OB_LogRequest__c WHERE id = :logRequest.id ].get( 0 );
        System.assertEquals( '26.0', result.OB_Gianos__c );
        OB_Util009_Gianos.mockResponse = true;
    }

    /*******************************************************************************
    Purpose:  Method test call to Gianos from Order Header Object
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-202
    ********************************************************************************/
    @isTest
    private static void callToGianosForOrderHeader( )
    {
        OB_Util009_Gianos.mockResponse = false;
        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader( );
        orderHeader.NE__AccountId__c = coreDataPreparationForGianos( );
        insert orderHeader;
        Test.setMock( HttpCalloutMock.class, new OB_Util009_Gianos_Mock( ) );
        Test.startTest( );
        OB_Util009_Gianos.callToGianos( orderHeader.id, false );
        Test.stopTest( );
        NE__Order_Header__c result = [ SELECT OB_Gianos__c FROM NE__Order_Header__c WHERE Id = :orderHeader.id ].get( 0 );
        System.assertEquals( '26.0', result.OB_Gianos__c );
        OB_Util009_Gianos.mockResponse = true;
    }

    /*******************************************************************************
    Purpose:  Method test checkRequiredFields when field does not exist in object
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       22/07/2019      Created         NEXI-202
    ********************************************************************************/
    @isTest
    private static void checkRequiredFieldsNoField( )
    {
        final String fieldName = 'Bad field';
        Account aAccount = OB_TestDataFactory.getAccount( );
        List<String> result = OB_Util009_Gianos.checkRequiredFields( JSON.serialize( aAccount ), new List<String> {fieldName} );
        System.assertEquals( fieldName, result.get( 0 ) );
    }

    /*******************************************************************************
    Purpose:  Method test checkRequiredFields when object josn is wrong
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       22/07/2019      Created         NEXI-202
    ********************************************************************************/
    @isTest
    private static void checkRequiredFieldsException( )
    {
        Account aAccount = OB_TestDataFactory.getAccount( );
        List<String> result = OB_Util009_Gianos.checkRequiredFields( 'Bad JSON', null );
        System.assertEquals( OB_Util009_Gianos.FATAL_ERROR, result.get( 0 ) );
    }

    /*******************************************************************************
    Purpose:  Method test mockResponse for log request
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       22/07/2019      Created         NEXI-202
    ********************************************************************************/
    @isTest
    private static void mockResponseLogRequest( )
    {
        OB_LogRequest__c logRequest = OB_TestDataFactory.getLogRequest( );
        insert logRequest;
        System.assert( OB_Util009_Gianos.mockResponse( logRequest.id, true, '20' ) );
    }

    /*******************************************************************************
    Purpose:  Method test mockResponse for log request
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       22/07/2019      Created         NEXI-202
    ********************************************************************************/
    @isTest
    private static void mockResponseOrderHeader( )
    {
        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader( );
        insert orderHeader;
        System.assert( OB_Util009_Gianos.mockResponse( orderHeader.id, false, '20' ) );
    }
}