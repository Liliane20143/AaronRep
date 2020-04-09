/*******************************************************************************
Purpose:  Class that tests OB_Util009_AVRSOS
Parameters: -
Returns: -

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         Damian Krzyzaniak       19/07/2019      Created         NEXI-214
1.1         Damian Krzyzaniak       22/08/2019      Modified        NEXI-214-AVRSOS-Fixes
********************************************************************************/
@isTest
private class OB_Util009_AVRSOS_Test
{
    // NEXI-281 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 28/08/2019 START
    private static final String DOSSIER_ID = 'dossierId';
    private static final String ACCOUNT_ID = 'accountId';
    private static final String ORDERHEADER_ID = 'orderHeaderId';
    private static final String LOGREQUEST_ID = 'logRequestId';
    // NEXI-281 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 28/08/2019 STOP

    /*******************************************************************************
       Purpose: Data preparation method for all test of OB_Util009_AVRSOS class
       Parameters: -
       Returns: -

       History
       --------
       VERSION     AUTHOR                  DATE            DETAIL          Description
       1.0         Damian Krzyzaniak       19/07/2019      Created         NEXI-214
       1.1         Damian Krzyzaniak       22/07/2019      Modified        NEXI-214-AVRSOS-Fixes - Changed data creation
       1.2         Kinga Fornal            23/09/2019      Modified        NEXI-345 added expirationDate for test
       ********************************************************************************/
    private static Map<String, String> prepareDataForAVRSOS( Boolean isLogRequest )
    {
        OB_Integration_Configuration__c integrationConfiguration = OB_TestDataFactory.getIntegrationConfiguration( );
        integrationConfiguration.OB_Token_1__c = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.ae0uhFv92QHdZMIxqofDkYrOwRH2dR7Axkni1Xzu1_dhE1ohL1lTp-2pyZ4O-QBnVNV7ulihyTc9DlVbMixGa813SFxwpAjIMrhqnG_xHQVnMLyi2-wE3dXZQcuwmw8NeqBM2Kg92NVpKADdcAEoQ7RAhxL0LJGuyhLJBXgZ';
        integrationConfiguration.OB_Timestamp__c = '1542025783107';
        insert integrationConfiguration;

        Account testAccount = OB_TestDataFactory.getAccount( );
        testAccount.NE__Fiscal_code__c = 'SMTJHN90A01F205S';
        insert testAccount;

        NE__Order_Header__c testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        testOrderHeader.OB_Main_Process__c = OB_UtilityConstants.SETUP; // NEXI-281 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 28/08/2019
        testOrderHeader.NE__AccountId__c = testAccount.Id;
        insert testOrderHeader;

        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        testOrder.NE__AccountId__c = testAccount.Id;
        insert testOrder;

        // NEXI-367 Wojciech Szuba, <wojciech.szuba@accenture.com>, 15/10/2019, START
        Contact testContact = OB_TestDataFactory.getContact( testAccount );
        insert testContact;
        // NEXI-367 Wojciech Szuba, <wojciech.szuba@accenture.com>, 15/10/2019, STOP

        OB_LogRequest__c testLogRequest = new OB_LogRequest__c( );
        testLogRequest.OB_AccountId__c = testAccount.Id;
        testLogRequest.OB_MaintenanceType__c = OB_UtilityConstants.ANAGRAFICA; // NEXI-281 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 28/08/2019
        // NEXI-367 Wojciech Szuba, <wojciech.szuba@accenture.com>, 15/10/2019, START
        testLogRequest.OB_ReducedNewData__c = '{"obj":[{"attributes":{"type":"Contact","url":"/services/data/v47.0/sobjects/Contact/0031X00000IX5zcQAD"},"OB_Contact_State__c":"Active","Id":null}]}';
        testLogRequest.OB_ReducedOldData__c= '{"obj":[{"attributes":{"type":"Contact","url":"/services/data/v47.0/sobjects/Contact/0031X00000IX5zcQAD"},"OB_Contact_State__c":"Inactive","Id":"' + testContact.Id + '"}]}';
        // NEXI-367 Wojciech Szuba, <wojciech.szuba@accenture.com>, 15/10/2019, STOP
        insert testLogRequest;

        OB_Util009_AVRSOS.AVRSOSResponse responseAVR = new OB_Util009_AVRSOS.AVRSOSResponse( );
        if ( isLogRequest )
        {
            responseAVR.dossierId = testLogRequest.Id;
        }
        else
        {
            responseAVR.dossierId = testOrderHeader.Id;
        }

        Contact executor = OB_TestDataFactory.getContact( testAccount );
        executor.OB_Fiscal_Code__c = testAccount.NE__Fiscal_code__c;
        executor.RecordTypeId = OB_Util009_AVRSOS.RECORD_TYPE_ESECUTORE;
        executor.OB_Birth_Date__c = Date.newInstance( 1990, 1, 1 );
        executor.OB_Document_Expiration_Date__c = Date.newInstance( 2029, 1, 1 );
        insert executor;

        Contact actualOwner = OB_TestDataFactory.getContact( testAccount );
        actualOwner.OB_Fiscal_Code__c = testAccount.NE__Fiscal_code__c;
        actualOwner.RecordTypeId = OB_Util009_AVRSOS.RECORD_TYPE_TITOLARE_EFFETTIVO;
        actualOwner.OB_Document_Expiration_Date__c = Date.newInstance( 2029, 1, 1 );
        insert actualOwner;

        OB_Util009_AVRSOS_Mock.dataResponse = responseAVR;
        OB_Util009_AVRSOS_Mock.statusCode = 200;
        OB_Util009_AVRSOS_Mock.status = OB_UtilityConstants.TECHOUTCOME_OK;
        Map<String, String> dataMap = new Map<String, String>( );
        dataMap.put( ORDERHEADER_ID, testOrderHeader.Id );
        dataMap.put( LOGREQUEST_ID, testLogRequest.Id );
        dataMap.put( ACCOUNT_ID, testAccount.Id );
        dataMap.put( DOSSIER_ID, responseAVR.dossierId );
        return dataMap;
    }

    /*******************************************************************************
    Purpose:  Method test call to AVR/SOS - Log Request Object
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Damian Krzyzaniak       19/07/2019      Created         NEXI-214
    1.1         Damian Krzyzaniak       22/08/2019      Modified        NEXI-214-AVRSOS-Fixes - modified assert to check if DossierID is same as objectId with mocked data
    ********************************************************************************/
    @isTest
    private static void callToAVRSOSForLogRequest( )
    {
        Map<String, String> dataMap = prepareDataForAVRSOS( true );
        Id logRequestId = dataMap.get( LOGREQUEST_ID );
        Id accountId = dataMap.get( ACCOUNT_ID );
        Id dossierId = dataMap.get( DOSSIER_ID );
        Test.setMock( HttpCalloutMock.class, new OB_Util009_AVRSOS_Mock( ) );
        Test.startTest( );
        OB_Util009_AVRSOS.calloutAVRSOS( accountId, logRequestId, OB_UtilityConstants.MAINTENANCE );
        Test.stopTest( );
        OB_LogRequest__c result =
        [
                SELECT Id, OB_AVRSOSPracticeId__c
                FROM OB_LogRequest__c
                WHERE Id = :logRequestId
                LIMIT 1
        ].get( 0 );
        System.assertEquals( dossierId, result.OB_AVRSOSPracticeId__c );
    }

    /*******************************************************************************
    Purpose:  Method test call to AVR/SOS - Order Header Object
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Damian Krzyzaniak       19/07/2019      Created         NEXI-214
    1.1         Damian Krzyzaniak       22/08/2019      Modified        NEXI-214-AVRSOS-Fixes - modified assert to check if DossierID is same as objectId with mocked data
    ********************************************************************************/
    @isTest
    private static void callToAVRSOSForOrderHeader( )
    {
        Map<String, String> dataMap = prepareDataForAVRSOS( false );
        Id orderHeaderId = dataMap.get( ORDERHEADER_ID );
        Id accountId = dataMap.get( ACCOUNT_ID );
        Id dossierId = dataMap.get( DOSSIER_ID );
        Test.setMock( HttpCalloutMock.class, new OB_Util009_AVRSOS_Mock( ) );
        Test.startTest( );
        OB_Util009_AVRSOS.calloutAVRSOS( accountId, orderHeaderId, OB_UtilityConstants.SETUP );
        Test.stopTest( );
        NE__Order_Header__c result =
        [
                SELECT Id, OB_AVRSOSPracticeId__c
                FROM NE__Order_Header__c
                WHERE Id = :orderHeaderId
                LIMIT 1
        ].get( 0 );
        System.assertEquals( dossierId, result.OB_AVRSOSPracticeId__c );
    }

    /*******************************************************************************
    Purpose:  Method test call to AVR/SOS - Order Header Object - Maintenance Consistenza Flow scenario

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       28/08/2019      Created         NEXI-281
    ********************************************************************************/
    @isTest
    private static void callToAVRSOSForOrderHeaderConsistenza( )
    {
        Map<String, String> dataMap = prepareDataForAVRSOS( false );
        Id orderHeaderId = dataMap.get( ORDERHEADER_ID );
        NE__Order_Header__c testOrderHeader = [ SELECT Id FROM NE__Order_Header__c WHERE Id = :orderHeaderId ];
        testOrderHeader.OB_Main_Process__c = OB_UtilityConstants.MAINTENANCE;
        update testOrderHeader;
        Id accountId = dataMap.get( ACCOUNT_ID );
        Id dossierId = dataMap.get( DOSSIER_ID );
        Test.setMock( HttpCalloutMock.class, new OB_Util009_AVRSOS_Mock( ) );
        Test.startTest( );
        OB_Util009_AVRSOS.calloutAVRSOS( accountId, orderHeaderId, OB_UtilityConstants.SETUP );
        Test.stopTest( );
        NE__Order_Header__c result =
                [
                        SELECT Id, OB_AVRSOSPracticeId__c
                        FROM NE__Order_Header__c
                        WHERE Id = :orderHeaderId
                        LIMIT 1
                ].get( 0 );
        System.assertEquals( dossierId, result.OB_AVRSOSPracticeId__c );
    }
}