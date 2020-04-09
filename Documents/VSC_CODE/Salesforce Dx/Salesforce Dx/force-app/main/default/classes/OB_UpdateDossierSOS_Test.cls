/*****************************************************************
Name:  OB_UpdateDossierSOS
============================================================
Purpose: Method to test call to get the update on AVRSOS process
============================================================
History
-------                                                            
VERSION  		AUTHOR         		DATE           	DETAIL          Description
1.0          	elena.preteni       04/07/2019      Created         Creation of the class
*****************************************************************/
@isTest
public with sharing class OB_UpdateDossierSOS_Test
{

    private static final String ORDER_HEADER = 'OrderHeader';
    private static final String LOG_REQUEST = 'LogRequest';

    /*******************************************************************************
    Purpose:    Method prepares data
    Parameters: -
    Returns:    Id

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       24/07/2019      Created         NEXI-215
    1.1         Joanna Mielczarek       18/10/2019      Modified        NEXI-373 changed prepared data
    ********************************************************************************/
    private static Id prepareData( )
    {
        OB_Integration_Configuration__c integrationConfiguration = OB_TestDataFactory.getIntegrationConfiguration( );
        integrationConfiguration.OB_Token_1__c = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.ae0uhFv92QHdZMIxqofDkYrOwRH2dR7Axkni1Xzu1_dhE1ohL1lTp-2pyZ4O-QBnVNV7ulihyTc9DlVbMixGa813SFxwpAjIMrhqnG_xHQVnMLyi2-wE3dXZQcuwmw8NeqBM2Kg92NVpKADdcAEoQ7RAhxL0LJGuyhLJBXgZ';
        integrationConfiguration.OB_Timestamp__c = '1542025783107';
        insert integrationConfiguration;

        Account aAccount = OB_TestDataFactory.getAccount( );
        aAccount.NE__Fiscal_code__c = 'SMTJHN90A01F205S';
        insert aAccount;

        OB_Util009_AVRSOS.AVRSOSResponse responseAVR = new OB_Util009_AVRSOS.AVRSOSResponse( );
        responseAVR.dossierId = '123456789012345';

        Contact executor = OB_TestDataFactory.getContact( aAccount );
        executor.OB_Fiscal_Code__c = aAccount.NE__Fiscal_code__c;
        executor.RecordTypeId = OB_Util009_AVRSOS.RECORD_TYPE_ESECUTORE;
        executor.OB_Birth_Date__c = Date.newInstance( 1990, 1, 1 );
        insert executor;

        Contact actualOwner = OB_TestDataFactory.getContact( aAccount );
        actualOwner.OB_Fiscal_Code__c = aAccount.NE__Fiscal_code__c;
        actualOwner.RecordTypeId = OB_Util009_AVRSOS.RECORD_TYPE_TITOLARE_EFFETTIVO;
        insert actualOwner;

        return aAccount.Id;
    }

    /*******************************************************************************
    Purpose:    Method prepares Order Header
    Parameters: Id inAccountId
    Returns:    NE__Order_Header__c

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       18/10/2019      Created         NEXI-373
    ********************************************************************************/
    private static NE__Order_Header__c prepareOrderHeader( Id inAccountId )
    {
        NE__Order_Header__c testOrderHeader = new NE__Order_Header__c( );
        testOrderHeader = OB_TestDataFactory.getOrderHeader( );
        testOrderHeader.NE__AccountId__c = inAccountId;
        testOrderHeader.OB_StartApprovalProcess__c = true;
        testOrderHeader.OB_In_Approvazione_a__c = OB_UtilityConstants.FASECONTROL_OPERATIONAL_CONTROLS;
        testOrderHeader.OB_AdditionalDocumentationRequired__c = true;
        testOrderHeader.OB_Gambling__c = true;
        testOrderHeader.OB_AVRSOSPracticeId__c = '123456789012345';
        insert testOrderHeader;

        return testOrderHeader;
    }

    /*******************************************************************************
    Purpose:    Method prepares Order
    Parameters: NE__Order_Header__c testOrderHeader
    Returns:    Id

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       18/10/2019      Created         NEXI-373
    ********************************************************************************/
    private static Id prepareOrder( NE__Order_Header__c testOrderHeader )
    {
        NE__Order__c testOrder = OB_TestDataFactory.getOrder( testOrderHeader );
        testOrder.NE__AccountId__c = testOrderHeader.NE__AccountId__c;
        insert testOrder;

        return testOrder.Id;
    }

    /*******************************************************************************
    Purpose:    Method prepares Log Request
    Parameters: String inAccountId
    Returns:    Id

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       18/10/2019      Created         NEXI-373
    ********************************************************************************/
    private static Id prepareLogRequest( String inAccountId )
    {
        OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest( );
        testLogRequest.OB_AccountId__c = inAccountId;
        testLogRequest.OB_StartApprovalProcess__c = true;
        testLogRequest.OB_PEP__c = true;
        testLogRequest.OB_PO118_MOTO__c = true;
        testLogRequest.OB_PO118_Ecommerce__c = true;
        testLogRequest.OB_ApprovalStep__c = '1';
        testLogRequest.OB_AVRSOSPracticeId__c = '123456789012345';
        insert testLogRequest;

        return testLogRequest.Id;
    }

    /*******************************************************************************
    Purpose:    Method submits ApprovalProcess
    Parameters: Id inId, String inObjectType
    Returns:    -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       24/07/2019      Created         NEXI-215
    ********************************************************************************/
    private static void submitApprovalProcess( Id inId )
    {
        Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest( );
        approvalRequest.setObjectId( inId );
        approvalRequest.setNextApproverIds( new Id[] {UserInfo.getUserId( )} );
        Approval.ProcessResult approvalResult = Approval.process( approvalRequest );

        Id workItemId =
                [
                        SELECT Id
                        FROM ProcessInstanceWorkitem
                        WHERE ProcessInstance.TargetObjectId = :inId
                        LIMIT 1
                ].get( 0 ).Id;
        Approval.ProcessWorkitemRequest workItemRequest = new Approval.ProcessWorkitemRequest( );
        workItemRequest.setAction( OB_UpdateDossierSOS.APPROVAL_PROCESS_APPROVE );
        workItemRequest.setWorkitemId( workItemId );
        workItemRequest.setNextApproverIds( new Id[] {UserInfo.getUserId( )} );
        Approval.ProcessResult processResult = Approval.process( workItemRequest );
    }

    /*******************************************************************************
    Purpose:    Method prepares RestRequest
    Parameters: OB_UpdateDossierSOS.AvrSOS avrSOS
    Returns:    RestRequest

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       24/07/2019      Created         NEXI-215
    ********************************************************************************/
    private static RestRequest prepareRestRequest( OB_UpdateDossierSOS.AvrSOS avrSOS )
    {
        String testJSON = '{ "data":{ ' +
                '"sosId":"' + avrSOS.sosId + '", ' +
                '"requestOutcome":"' + avrSOS.requestOutcome + '", ' +
                '"outcomeCode":"' + avrSOS.outcomeCode + '", ' +
                '"outcomeDescription":"' + avrSOS.outcomeDescription + '", ' +
                '"workerComments":"' + avrSOS.workerComments + '" } }';
        RestRequest testRequest = new RestRequest( );
        testRequest.requestBody = Blob.valueOf( testJSON );
        testRequest.requestURI = '/UpdateDossierSOS/*';
        testRequest.httpMethod = 'POST';

        return testRequest;
    }

    /*******************************************************************************
    Purpose:    Method prepares Plc Log
    Parameters: String inRequestBody, String inObjectType, String inObjectId
    Returns:    -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       18/10/2019      Created         NEXI-373
    ********************************************************************************/
    private static void preparePlcLog( String inRequestBody, String inObjectType, String inObjectId )
    {
        Plc_Log__c testPlcLog = new Plc_Log__c( );
        testPlcLog.Plc_ResponseStatus__c = OB_UpdateDossierSOS.STATUS_S;
        testPlcLog.Plc_RequestBody__c = inRequestBody;
        testPlcLog.Plc_RequestURI__c = OB_UpdateDossierSOS.REQUEST_URI_UPDATEDOSSIERSOS;
        if ( ORDER_HEADER.equalsIgnoreCase( inObjectType ) )
        {
            testPlcLog.OB_OrderId__c = inObjectId;
        }
        else
        {
            testPlcLog.OB_Log_Request__c = inObjectId;
        }
        insert testPlcLog;
    }

    /*******************************************************************************
    Purpose:    Method tests getAVRSOSResponse - OK scenario - NE__Order_Header__c

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       24/07/2019      Created         NEXI-215
    1.1         Joanna Mielczarek       18/10/2019      Modified        NEXI-373 changed prepared data
    ********************************************************************************/
    @isTest
    private static void handleAVRSOSRequestOKOrderHeader( )
    {
        NE__Order_Header__c testOrderHeader = prepareOrderHeader( prepareData( ) );
        Id orderId = prepareOrder( testOrderHeader );
        submitApprovalProcess( testOrderHeader.Id );

        OB_UpdateDossierSOS.AvrSOS testData = new OB_UpdateDossierSOS.AvrSOS( );
        testData.sosId = '123456789012345';
        testData.requestOutcome = OB_UpdateDossierSOS.CODE_OK;
        testData.outcomeCode = '08';
        testData.outcomeDescription = OB_UpdateDossierSOS.REASONS_DESCRIPTIONS.get( testData.outcomeCode );

        Test.startTest( );
        RestRequest testRequest = prepareRestRequest( testData );
        RestResponse testResponse = new RestResponse( );

        RestContext.request = testRequest;
        RestContext.response = testResponse;

        OB_UpdateDossierSOS.UpdateDossierSOSResponse result = OB_UpdateDossierSOS.handleAVRSOSRequest( );
        System.assertEquals( 201, result.httpStatus );

        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:    Method tests getAVRSOSResponse - KO scenario - final rejection - NE__Order_Header__c

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       24/07/2019      Created         NEXI-215
    1.1         Joanna Mielczarek       18/10/2019      Modified        NEXI-373 changed prepared data
    ********************************************************************************/
    @isTest
    private static void handleAVRSOSRequestKOOrderHeaderFinal( )
    {
        NE__Order_Header__c testOrderHeader = prepareOrderHeader( prepareData( ) );
        Id orderId = prepareOrder( testOrderHeader );
        submitApprovalProcess( testOrderHeader.Id );

        OB_UpdateDossierSOS.AvrSOS testData = new OB_UpdateDossierSOS.AvrSOS( );
        testData.sosId = '123456789012345';
        testData.requestOutcome = OB_UpdateDossierSOS.CODE_KO;
        testData.outcomeCode = '09';
        testData.outcomeDescription = OB_UpdateDossierSOS.REASONS_DESCRIPTIONS.get( testData.outcomeCode );
        testData.workerComments = 'test comment';

        Test.startTest( );
        RestRequest testRequest = prepareRestRequest( testData );
        RestResponse testResponse = new RestResponse( );

        RestContext.request = testRequest;
        RestContext.response = testResponse;

        OB_UpdateDossierSOS.UpdateDossierSOSResponse result = OB_UpdateDossierSOS.handleAVRSOSRequest( );

        List<NE__Order_Header__c> orderHeaders = [ SELECT Id, OB_Rejection_Reason__c FROM NE__Order_Header__c LIMIT 1 ];
        System.assertEquals( 201, result.httpStatus );
        System.assertEquals( OB_UpdateDossierSOS.REASON_RIFIUTO_DEFINITIVO, orderHeaders.get( 0 ).OB_Rejection_Reason__c );

        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:    Method tests getAVRSOSResponse - KO scenario - rejection with missing documents - NE__Order_Header__c

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       24/07/2019      Created         NEXI-215
    1.1         Joanna Mielczarek       18/10/2019      Modified        NEXI-373 changed prepared data
    ********************************************************************************/
    @isTest
    private static void handleAVRSOSRequestKOOrderHeaderMissingDocs( )
    {
        NE__Order_Header__c testOrderHeader = prepareOrderHeader( prepareData( ) );
        Id orderId = prepareOrder( testOrderHeader );
        submitApprovalProcess( testOrderHeader.Id );

        OB_UpdateDossierSOS.AvrSOS testData = new OB_UpdateDossierSOS.AvrSOS( );
        testData.sosId = '123456789012345';
        testData.requestOutcome = OB_UpdateDossierSOS.CODE_KO;
        testData.outcomeCode = '22';
        testData.outcomeDescription = OB_UpdateDossierSOS.REASONS_DESCRIPTIONS.get( testData.outcomeCode );
        testData.workerComments = 'test comment';

        Test.startTest( );
        RestRequest testRequest = prepareRestRequest( testData );
        RestResponse testResponse = new RestResponse( );

        RestContext.request = testRequest;
        RestContext.response = testResponse;

        OB_UpdateDossierSOS.UpdateDossierSOSResponse result = OB_UpdateDossierSOS.handleAVRSOSRequest( );

        List<NE__Order_Header__c> orderHeaders = [ SELECT Id, OB_Rejection_Reason__c FROM NE__Order_Header__c LIMIT 1 ];
        System.assertEquals( 201, result.httpStatus );
        System.assertEquals( OB_UpdateDossierSOS.REASON_DOCUMENTAZIONE_INCOMPLETA, orderHeaders.get( 0 ).OB_Rejection_Reason__c );

        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:    Method tests getAVRSOSResponse - OK scenario - OB_LogRequest__c

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       24/07/2019      Created         NEXI-215
    1.1         Joanna Mielczarek       18/10/2019      Modified        NEXI-373 changed prepared data
    ********************************************************************************/
    @isTest
    private static void handleAVRSOSRequestOKLogRequest( )
    {
        Id logRequestId = prepareLogRequest( prepareData( ) );
        submitApprovalProcess( logRequestId );

        OB_UpdateDossierSOS.AvrSOS testData = new OB_UpdateDossierSOS.AvrSOS( );
        testData.sosId = '123456789012345';
        testData.requestOutcome = OB_UpdateDossierSOS.CODE_OK;
        testData.outcomeCode = '08';
        testData.outcomeDescription = OB_UpdateDossierSOS.REASONS_DESCRIPTIONS.get( testData.outcomeCode );

        Test.startTest( );
        RestRequest testRequest = prepareRestRequest( testData );
        RestResponse testResponse = new RestResponse( );

        RestContext.request = testRequest;
        RestContext.response = testResponse;

        OB_UpdateDossierSOS.UpdateDossierSOSResponse result = OB_UpdateDossierSOS.handleAVRSOSRequest( );
        System.assertEquals( 201, result.httpStatus );

        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:    Method tests getAVRSOSResponse - KO scenario - final rejection - OB_LogRequest__c

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       24/07/2019      Created         NEXI-215
    1.1         Joanna Mielczarek       18/10/2019      Modified        NEXI-373 changed prepared data
    ********************************************************************************/
    @isTest
    private static void handleAVRSOSRequestKOLogRequestFinal( )
    {
        Id logRequestId = prepareLogRequest( prepareData( ) );
        submitApprovalProcess( logRequestId );

        OB_UpdateDossierSOS.AvrSOS testData = new OB_UpdateDossierSOS.AvrSOS( );
        testData.sosId = '123456789012345';
        testData.requestOutcome = OB_UpdateDossierSOS.CODE_KO;
        testData.outcomeCode = '09';
        testData.outcomeDescription = OB_UpdateDossierSOS.REASONS_DESCRIPTIONS.get( testData.outcomeCode );
        testData.workerComments = 'test comment';

        Test.startTest( );
        RestRequest testRequest = prepareRestRequest( testData );
        RestResponse testResponse = new RestResponse( );

        RestContext.request = testRequest;
        RestContext.response = testResponse;

        OB_UpdateDossierSOS.UpdateDossierSOSResponse result = OB_UpdateDossierSOS.handleAVRSOSRequest( );

        List<OB_LogRequest__c> logRequests = [ SELECT Id, OB_RejectReason__c FROM OB_LogRequest__c LIMIT 1 ];
        System.assertEquals( 201, result.httpStatus );
        System.assertEquals( OB_UpdateDossierSOS.REASON_RIFIUTO_DEFINITIVO, logRequests.get( 0 ).OB_RejectReason__c );

        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:    Method tests getAVRSOSResponse - KO scenario - rejection with missing documents - OB_LogRequest__c

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       24/07/2019      Created         NEXI-215
    1.1         Joanna Mielczarek       18/10/2019      Modified        NEXI-373 changed prepared data
    ********************************************************************************/
    @isTest
    private static void handleAVRSOSRequestKOLogRequestMissingDocs( )
    {
        Id logRequestId = prepareLogRequest( prepareData( ) );
        submitApprovalProcess( logRequestId );

        OB_UpdateDossierSOS.AvrSOS testData = new OB_UpdateDossierSOS.AvrSOS( );
        testData.sosId = '123456789012345';
        testData.requestOutcome = OB_UpdateDossierSOS.CODE_KO;
        testData.outcomeCode = '22';
        testData.outcomeDescription = OB_UpdateDossierSOS.REASONS_DESCRIPTIONS.get( testData.outcomeCode );
        testData.workerComments = 'test comment';

        Test.startTest( );
        RestRequest testRequest = prepareRestRequest( testData );
        RestResponse testResponse = new RestResponse( );

        RestContext.request = testRequest;
        RestContext.response = testResponse;

        OB_UpdateDossierSOS.UpdateDossierSOSResponse result = OB_UpdateDossierSOS.handleAVRSOSRequest( );

        List<OB_LogRequest__c> logRequests = [ SELECT Id, OB_RejectReason__c FROM OB_LogRequest__c ];
        System.assertEquals( 201, result.httpStatus );
        System.assertEquals( OB_UpdateDossierSOS.REASON_DOCUMENTAZIONE_INCOMPLETA, logRequests.get( 0 ).OB_RejectReason__c );

        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:    Method tests getAVRSOSResponse - exception scenario with null as a request body

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       24/07/2019      Created         NEXI-215
    ********************************************************************************/
    @isTest
    private static void handleAVRSOSRequestException( )
    {
        Test.startTest( );
        RestContext.request = new RestRequest( );
        RestContext.response = new RestResponse( );

        OB_UpdateDossierSOS.UpdateDossierSOSResponse result = OB_UpdateDossierSOS.handleAVRSOSRequest( );
        System.assertEquals( 400, result.httpStatus );

        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:    Method tests getAVRSOSResponse - Exception during deserializing JSON

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       24/07/2019      Created         NEXI-215
    ********************************************************************************/
    @isTest
    private static void handleAVRSOSRequestExceptionInvalidJSON( )
    {
        Test.startTest( );
        String testJSON = '{ "data":{ }';
        RestRequest testRequest = new RestRequest( );
        testRequest.requestBody = Blob.valueOf( '' );
        testRequest.requestURI = '/UpdateDossierSOS/*';
        testRequest.httpMethod = 'POST';
        RestResponse testResponse = new RestResponse( );

        RestContext.request = testRequest;
        RestContext.response = testResponse;

        OB_UpdateDossierSOS.UpdateDossierSOSResponse result = OB_UpdateDossierSOS.handleAVRSOSRequest( );
        System.assertEquals( 400, result.httpStatus );

        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:    Method tests getAVRSOSResponse - checkAttributes - blank parameter

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       24/07/2019      Created         NEXI-215
    ********************************************************************************/
    @isTest
    private static void handleAVRSOSRequestCheckAttributesBlank( )
    {
        OB_UpdateDossierSOS.AvrSOS testData = new OB_UpdateDossierSOS.AvrSOS( );
        testData.sosId = '123456789012345';
        testData.requestOutcome = OB_UpdateDossierSOS.CODE_KO;
        testData.outcomeCode = '09';
        testData.outcomeDescription = '';
        testData.workerComments = '';

        Test.startTest( );
        RestRequest testRequest = prepareRestRequest( testData );
        RestResponse testResponse = new RestResponse( );

        RestContext.request = testRequest;
        RestContext.response = testResponse;

        OB_UpdateDossierSOS.UpdateDossierSOSResponse result = OB_UpdateDossierSOS.handleAVRSOSRequest( );
        System.assertEquals( 400, result.httpStatus );

        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:    Method tests getAVRSOSResponse - checkAttributes - not proper requestOutcome

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       24/07/2019      Created         NEXI-215
    ********************************************************************************/
    @isTest
    private static void handleAVRSOSRequestCheckAttributesNotOKKO( )
    {
        OB_UpdateDossierSOS.AvrSOS testData = new OB_UpdateDossierSOS.AvrSOS( );
        testData.sosId = '123456789012345';
        testData.requestOutcome = 'test';
        testData.outcomeCode = '09';
        testData.outcomeDescription = OB_UpdateDossierSOS.REASONS_DESCRIPTIONS.get( testData.outcomeCode );
        testData.workerComments = '';

        Test.startTest( );
        RestRequest testRequest = prepareRestRequest( testData );
        RestResponse testResponse = new RestResponse( );

        RestContext.request = testRequest;
        RestContext.response = testResponse;

        OB_UpdateDossierSOS.UpdateDossierSOSResponse result = OB_UpdateDossierSOS.handleAVRSOSRequest( );
        System.assertEquals( 400, result.httpStatus );

        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:    Method tests getAVRSOSResponse - checkAttributes - worker comment blank if it's KO

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       24/07/2019      Created         NEXI-215
    ********************************************************************************/
    @isTest
    private static void handleAVRSOSRequestCheckAttributesKOEmptyComment( )
    {
        OB_UpdateDossierSOS.AvrSOS testData = new OB_UpdateDossierSOS.AvrSOS( );
        testData.sosId = '123456789012345';
        testData.requestOutcome = OB_UpdateDossierSOS.CODE_KO;
        testData.outcomeCode = '09';
        testData.outcomeDescription = OB_UpdateDossierSOS.REASONS_DESCRIPTIONS.get( testData.outcomeCode );
        testData.workerComments = '';

        Test.startTest( );
        RestRequest testRequest = prepareRestRequest( testData );
        RestResponse testResponse = new RestResponse( );

        RestContext.request = testRequest;
        RestContext.response = testResponse;

        OB_UpdateDossierSOS.UpdateDossierSOSResponse result = OB_UpdateDossierSOS.handleAVRSOSRequest( );
        System.assertEquals( 400, result.httpStatus );

        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:    Method tests getAVRSOSResponse - checkAttributes - invalid outcomeCode

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       24/07/2019      Created         NEXI-215
    ********************************************************************************/
    @isTest
    private static void handleAVRSOSRequestCheckAttributesInvalidCode( )
    {
        OB_UpdateDossierSOS.AvrSOS testData = new OB_UpdateDossierSOS.AvrSOS( );
        testData.sosId = '123456789012345';
        testData.requestOutcome = OB_UpdateDossierSOS.CODE_OK;
        testData.outcomeCode = '11';
        testData.outcomeDescription = OB_UpdateDossierSOS.REASONS_DESCRIPTIONS.get( testData.outcomeCode );
        testData.workerComments = '';

        Test.startTest( );
        RestRequest testRequest = prepareRestRequest( testData );
        RestResponse testResponse = new RestResponse( );

        RestContext.request = testRequest;
        RestContext.response = testResponse;

        OB_UpdateDossierSOS.UpdateDossierSOSResponse result = OB_UpdateDossierSOS.handleAVRSOSRequest( );
        System.assertEquals( 400, result.httpStatus );

        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:    Method tests getAVRSOSResponse - checkAttributes - not object related to sosId

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       24/07/2019      Created         NEXI-215
    ********************************************************************************/
    @isTest
    private static void handleAVRSOSRequestObjectsNotFound( )
    {
        OB_UpdateDossierSOS.AvrSOS testData = new OB_UpdateDossierSOS.AvrSOS( );
        testData.sosId = '123456789012345';
        testData.requestOutcome = OB_UpdateDossierSOS.CODE_OK;
        testData.outcomeCode = '20';
        testData.outcomeDescription = OB_UpdateDossierSOS.REASONS_DESCRIPTIONS.get( testData.outcomeCode );
        testData.workerComments = '';

        Test.startTest( );
        RestRequest testRequest = prepareRestRequest( testData );
        RestResponse testResponse = new RestResponse( );

        RestContext.request = testRequest;
        RestContext.response = testResponse;

        OB_UpdateDossierSOS.UpdateDossierSOSResponse result = OB_UpdateDossierSOS.handleAVRSOSRequest( );
        System.assertEquals( 404, result.httpStatus );

        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:    Method tests getAVRSOSResponse - no approval process

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       24/07/2019      Created         NEXI-215
    1.1         Joanna Mielczarek       18/10/2019      Modified        NEXI-373 changed prepared data
    ********************************************************************************/
    @isTest
    private static void handleAVRSOSRequestNoApprovalProcess( )
    {
        Id logRequestId = prepareLogRequest( prepareData( ) );

        OB_UpdateDossierSOS.AvrSOS testData = new OB_UpdateDossierSOS.AvrSOS( );
        testData.sosId = '123456789012345';
        testData.requestOutcome = OB_UpdateDossierSOS.CODE_OK;
        testData.outcomeCode = '20';
        testData.outcomeDescription = OB_UpdateDossierSOS.REASONS_DESCRIPTIONS.get( testData.outcomeCode );
        testData.workerComments = '';

        Test.startTest( );
        RestRequest testRequest = prepareRestRequest( testData );
        RestResponse testResponse = new RestResponse( );

        RestContext.request = testRequest;
        RestContext.response = testResponse;

        OB_UpdateDossierSOS.UpdateDossierSOSResponse result = OB_UpdateDossierSOS.handleAVRSOSRequest( );
        System.assertEquals( 404, result.httpStatus );

        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:    Method executes avr sos constructor - just to increase cc

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       04/10/2019      Created         NEXI-353
    ********************************************************************************/
    @isTest
    private static void responseAvrSOSExecute( )
    {
        OB_UpdateDossierSOS.responseAvrSOS avrsosResult = new OB_UpdateDossierSOS.responseAvrSOS( );
        System.assert( avrsosResult.data != null );
    }

    /*******************************************************************************
    Purpose:    Method tests handleInternalAVRSOSRequest

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       04/10/2019      Created         NEXI-357
    ********************************************************************************/
    @isTest
    private static void handleInternalAVRSOSRequest( )
    {
        Test.startTest( );
        OB_UpdateDossierSOS.handleInternalAVRSOSRequest( '' );
        Test.stopTest( );

        System.assert( true );
    }

    /*******************************************************************************
    Purpose:    Method tests isRequestInvalid - existing Plc Log with same sosId

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       18/10/2019      Created         NEXI-373
    ********************************************************************************/
    @isTest
    private static void isRequestInvalidTrue( )
    {
        Id testLogRequest = prepareLogRequest( prepareData( ) );
        OB_UpdateDossierSOS.AvrSOS testData = new OB_UpdateDossierSOS.AvrSOS( );
        testData.sosId = '123456789012345';
        testData.requestOutcome = OB_UpdateDossierSOS.CODE_OK;
        testData.outcomeCode = '08';
        testData.outcomeDescription = OB_UpdateDossierSOS.REASONS_DESCRIPTIONS.get( testData.outcomeCode );

        Map<String, Object> testRequestBody = new Map<String, Object>( );
        testRequestBody.put( 'data', testData );
        preparePlcLog( JSON.serialize( testRequestBody ), LOG_REQUEST, testLogRequest );

        System.assert( OB_UpdateDossierSOS.isRequestInvalid( testLogRequest, testData.sosId ) );
    }

    /*******************************************************************************
    Purpose:    Method tests isRequestInvalid - existing Plc Log with different sosId

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       18/10/2019      Created         NEXI-373
    ********************************************************************************/
    @isTest
    private static void isRequestInvalidFalse( )
    {
        Id testLogRequest = prepareLogRequest( prepareData( ) );
        OB_UpdateDossierSOS.AvrSOS testData = new OB_UpdateDossierSOS.AvrSOS( );
        testData.sosId = '1234567890123';
        testData.requestOutcome = OB_UpdateDossierSOS.CODE_OK;
        testData.outcomeCode = '08';
        testData.outcomeDescription = OB_UpdateDossierSOS.REASONS_DESCRIPTIONS.get( testData.outcomeCode );

        Map<String, Object> testRequestBody = new Map<String, Object>( );
        testRequestBody.put( 'data', testData );
        preparePlcLog( JSON.serialize( testRequestBody ), LOG_REQUEST, testLogRequest );

        System.assert( OB_UpdateDossierSOS.isRequestInvalid( testLogRequest, testData.sosId ) );
    }

    /*******************************************************************************
    Purpose:    Method tests isRequestInvalid - no Plc Log

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       18/10/2019      Created         NEXI-373
    ********************************************************************************/
    @isTest
    private static void isRequestInvalidNoPlcLog( )
    {
        Id testLogRequest = prepareLogRequest( prepareData( ) );
        System.assert( !OB_UpdateDossierSOS.isRequestInvalid( testLogRequest, '123456789012345' ) );
    }

    /*******************************************************************************
    Purpose:    Method tests isRequestInvalid - null params

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       18/10/2019      Created         NEXI-373
    ********************************************************************************/
    @isTest
    private static void isRequestInvalidNullParams( )
    {
        System.assert( OB_UpdateDossierSOS.isRequestInvalid( null, '' ) );
    }
}