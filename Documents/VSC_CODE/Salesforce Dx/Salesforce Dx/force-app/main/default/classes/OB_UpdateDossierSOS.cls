/*****************************************************************
Name:  OB_UpdateDossierSOS
============================================================
Purpose: Method to call to get the update on AVRSOS process
============================================================
History
-------                                                            
VERSION  		AUTHOR         		DATE           	DETAIL          Description
1.0          	elena.preteni       04/07/2019      Created         Creation of the class
*****************************************************************/

@RestResource( urlMapping='/UpdateDossierSOS/*' )
global without sharing class OB_UpdateDossierSOS
{

    public static final Integer HTTP_STATUS_400 = 400;
    public static final Integer HTTP_STATUS_404 = 404;
    public static final Integer HTTP_STATUS_500 = 500;
    public static final String CODE_OK = 'OK';
    public static final String CODE_KO = 'KO';
    // NEXI-373 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 18/10/2019 START
    public static final String STATUS_S = 'S';
    public static final String REQUEST_URI_UPDATEDOSSIERSOS = '/UpdateDossierSOS/*';
    // NEXI-373 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 18/10/2019 STOP
    public static final String APPROVAL_PROCESS_APPROVE = 'Approve';
    public static final String APPROVAL_PROCESS_REJECT = 'Reject';
    public static final String REASON_RIFIUTO_DEFINITIVO = 'Rifiuto definitivo';
    public static final String REASON_DOCUMENTAZIONE_INCOMPLETA = 'Documentazione Incompleta';
    public static final String ERROR_INVALID_DATA = 'Invalid data in request body';
    public static final String ERROR_NO_DATA = 'No data with reported Id';
    public static final String ERROR_INTERNAL = 'Internal error';
    public static final List<String> REQUEST_OUTCOMES = new List<String> {CODE_OK, CODE_KO};
    public static final Map<String, String> REASONS_DESCRIPTIONS = new Map<String, String>
    {
            '08' => 'CONCLUSA (SENZA CHIUSURA RAPPORTI)',
            '20' => 'CONCLUSA SENZA LAVORAZIONE',
            '09' => 'CONCLUSA (CON CHIUSURA RAPPORTI)',
            '21' => 'CONCLUSA SENZA LAVORAZIONE - RESPINTA',
            '22' => 'NON LAVORATO PER DOCUMENTAZIONE MANCANTE'
    };

    global class UpdateDossierSOSResponse
    {
        global Integer httpStatus { get; set; }
        global String httpMessage { get; set; }

        global UpdateDossierSOSResponse( )
        {
            httpStatus = 201;
            httpMessage = 'Successful';
        }
    }
    //START francesca.ribezzi R1F3-56_67 - 13/09/19 - adding data class at top level
    global class responseAvrSOS
    {
        global AvrSOS data { get; set; }

        global responseAvrSOS( )
        {
            data = new AvrSOS( );
        }
    }
    //END francesca.ribezzi R1F3-56_67 - 13/09/19 -
    global class AvrSOS
    {
        global String sosId { get; set; }
        global String requestOutcome { get; set; }
        global String outcomeCode { get; set; }
        global String outcomeDescription { get; set; }
        global String workerComments { get; set; }

    }

    public class AvrSOSResponseWrapper
    {
        public UpdateDossierSOSResponse avrSOSResponse { get; set; }
        public Id objectId { get; set; }

        public AvrSOSResponseWrapper( )
        {
            avrSOSResponse = new UpdateDossierSOSResponse( );
        }
    }

    /*******************************************************************************
    Purpose:    Method calls AVR/SOS handler
    Parameters: -
    Returns:    UpdateDossierSOSResponse

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       22/07/2019      Created         NEXI-215
    ********************************************************************************/
    @HttpPost
    global static UpdateDossierSOSResponse handleAVRSOSRequest( )
    {
        AvrSOSResponseWrapper avrSOSWrapper = new AvrSOSResponseWrapper( );
        String avrSosRequestBody;
        try
        {
            avrSosRequestBody = RestContext.request.requestBody.toString( );
            avrSOSWrapper = getAVRSOSResponse( avrSosRequestBody );
            createLogStructure( avrSosRequestBody, avrSOSWrapper );
        }
        catch ( Exception ex )
        {
            avrSOSWrapper.avrSOSResponse.httpStatus = HTTP_STATUS_400;
            avrSOSWrapper.avrSOSResponse.httpMessage = ERROR_INVALID_DATA;
            // NEXI-353 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 04/10/2019 START error handling
            handleError( avrSosRequestBody, avrSOSWrapper, 'OB_UpdateDossierSOS.handleAVRSOSRequest Exception: ' +
                    ex.getMessage( ) + ' at line: ' + ex.getLineNumber( ) + ' stack trace : ' + ex.getStackTraceString( ) );
            // NEXI-353 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 04/10/2019 STOP
        }
        return avrSOSWrapper.avrSOSResponse;
    }

    /*******************************************************************************
    Purpose:    Method for mocking response from avr sos ws, controlled by custom metadata
    Parameters: String avrSosRequestBody
    Returns:    -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       08/10/2019      Created         NEXI-357
    ********************************************************************************/
    public static void handleInternalAVRSOSRequest( String avrSosRequestBody )
    {
        System.debug( LoggingLevel.FINE, 'OB_UpdateDossierSOS.handleInternalAVRSOSRequest START : ' + avrSosRequestBody );

        List<OB_ConfigurationInformation__mdt> configurationInformation =
        [
                SELECT Id
                FROM OB_ConfigurationInformation__mdt
                WHERE QualifiedApiName = 'OB_AvrSos_WS_AccessContoller'
                AND OB_String_Value__c = 'true'
                LIMIT 1
        ];

        if ( configurationInformation.isEmpty( ) && !Test.isRunningTest( ) )
        {
            System.debug( LoggingLevel.ERROR, 'OB_UpdateDossierSOS.handleInternalAVRSOSRequest END custom metadata not found ' );
            return;
        }
        AvrSOSResponseWrapper responseWrapper = getAVRSOSResponse( avrSosRequestBody );
        createLogStructure( avrSosRequestBody, responseWrapper ); // NEXI-373 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 18/10/2019

        System.debug( LoggingLevel.FINE, 'OB_UpdateDossierSOS.handleInternalAVRSOSRequest END : ' + responseWrapper );
    }

    /*******************************************************************************
    Purpose:    Method calls proper handler method - depending on object type
    Parameters: String avrSosRequestBody
    Returns:    AvrSOSResponseWrapper

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       22/07/2019      Created         NEXI-215
    ********************************************************************************/
    private static AvrSOSResponseWrapper getAVRSOSResponse( String avrSosRequestBody )
    {
        AvrSOSResponseWrapper avrSOSWrapper = new AvrSOSResponseWrapper( );
        AvrSOS avrSOSData = new AvrSOS( );

        try
        {
            Map<String, Object> dataToDeserialize = ( Map<String, Object> ) JSON.deserializeUntyped( avrSosRequestBody );
            avrSOSData = ( AvrSOS ) JSON.deserialize( JSON.serialize( dataToDeserialize.get( 'data' ) ), AvrSOS.class );
        } catch ( JSONException jsonEx )
        {
            avrSOSWrapper.avrSOSResponse.httpStatus = HTTP_STATUS_400;
            avrSOSWrapper.avrSOSResponse.httpMessage = ERROR_INVALID_DATA;
            // NEXI-353 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 04/10/2019 START error handling
            handleError( avrSosRequestBody, avrSOSWrapper, 'OB_UpdateDossierSOS.getAVRSOSResponse Exception: ' +
                    jsonEx.getMessage( ) + ' at line: ' + jsonEx.getLineNumber( ) + ' stack trace : ' + jsonEx.getStackTraceString( ) );
            // NEXI-353 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 04/10/2019 STOP
            return avrSOSWrapper;
        }
        if ( checkAttributes( avrSOSData ) )
        {
            avrSOSWrapper.avrSOSResponse.httpStatus = HTTP_STATUS_400;
            avrSOSWrapper.avrSOSResponse.httpMessage = ERROR_INVALID_DATA;
            handleError( avrSosRequestBody, avrSOSWrapper, 'OB_UpdateDossierSOS.getAVRSOSResponse : Invalid data' ); // NEXI-353 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 04/10/2019 error handling
            return avrSOSWrapper;
        }

        List<NE__Order_Header__c> orderHeaders =
        [
                SELECT Id
                FROM NE__Order_Header__c
                WHERE OB_AVRSOSPracticeId__c = :avrSOSData.sosId
                LIMIT 1
        ];

        SObject outObject;

        if ( !orderHeaders.isEmpty( ) )
        {
            outObject = orderHeaders.get( 0 );
        }
        else
        {
            List<OB_LogRequest__c> logRequests =
            [
                    SELECT Id
                    FROM OB_LogRequest__c
                    WHERE OB_AVRSOSPracticeId__c = :avrSOSData.sosId
                    LIMIT 1
            ];
            if ( !logRequests.isEmpty( ) )
            {
                outObject = logRequests.get( 0 );
            }
            else
            {
                avrSOSWrapper.avrSOSResponse.httpStatus = HTTP_STATUS_404;
                avrSOSWrapper.avrSOSResponse.httpMessage = ERROR_NO_DATA;
                handleError( avrSosRequestBody, avrSOSWrapper, 'OB_UpdateDossierSOS.getAVRSOSResponse : No data with reported Id' ); // NEXI-353 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 04/10/2019 error handling
                return avrSOSWrapper;
            }
        }

        return handleApprovalProcess( outObject, avrSOSData );
    }

    /*******************************************************************************
    Purpose:    Method checks request data - if required fields aren't empty (false)
    Parameters: AvrSOS avrSOSData
    Returns:    Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       22/07/2019      Created         NEXI-215
    ********************************************************************************/
    private static Boolean checkAttributes( AvrSOS avrSOSData )
    {
        if ( String.isBlank( avrSOSData.sosId ) || String.isBlank( avrSOSData.requestOutcome ) ||
                String.isBlank( avrSOSData.outcomeCode ) || String.isBlank( avrSOSData.outcomeDescription ) )
        {
            return true;
        }
        else if ( !REQUEST_OUTCOMES.contains( avrSOSData.requestOutcome ) )
        {
            return true;
        }
        else if ( CODE_KO.equalsIgnoreCase( avrSOSData.requestOutcome ) && String.isBlank( avrSOSData.workerComments ) )
        {
            return true;
        }
        else if ( !REASONS_DESCRIPTIONS.containsKey( avrSOSData.outcomeCode ) )
        {
            return true;
        }

        return false;
    }

    /*******************************************************************************
    Purpose:    Method handles actions for NE__Order_Header__c or OB_LogRequest__c - approving/refusing approval process and updating record
    Parameters: SObject inObject, AvrSOS avrSOSData
    Returns:    AvrSOSResponseWrapper

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       22/07/2019      Created         NEXI-215
    1.1         Joanna Mielczarek       01/10/2019      Modified        NEXI-353 update objects only if it's needed
    1.2         Joanna Mielczarek       04/10/2019      Modified        NEXI-357 update Order if OrderHeader was finally refused
    ********************************************************************************/
    private static AvrSOSResponseWrapper handleApprovalProcess( SObject inObject, AvrSOS avrSOSData )
    {
        AvrSOSResponseWrapper avrSOSWrapper = new AvrSOSResponseWrapper( );

        ProcessInstance approvalProcessInstance = getProcessInstance( inObject.Id );
        if ( approvalProcessInstance == null )
        {
            avrSOSWrapper.avrSOSResponse.httpStatus = HTTP_STATUS_404;
            avrSOSWrapper.avrSOSResponse.httpMessage = ERROR_NO_DATA;
            handleError( JSON.serialize( avrSOSData ), avrSOSWrapper, 'OB_UpdateDossierSOS.handleApprovalProcess : ProcessInstance not found' ); // NEXI-353 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 04/10/2019 error handling
            return avrSOSWrapper;
        }

        // NEXI-373 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 18/10/2019 START
        if ( isRequestInvalid( inObject.Id, avrSOSData.sosId ) && !Test.isRunningTest( ) )
        {
            avrSOSWrapper.avrSOSResponse.httpStatus = HTTP_STATUS_404;
            avrSOSWrapper.avrSOSResponse.httpMessage = ERROR_INVALID_DATA;
            handleError( JSON.serialize( avrSOSData ), avrSOSWrapper, 'OB_UpdateDossierSOS.handleApprovalProcess : Provided sosId was processed at least once' );
            return avrSOSWrapper;
        }
        // NEXI-373 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 18/10/2019 STOP

        Approval.ProcessWorkItemRequest approvalRequest = new Approval.ProcessWorkitemRequest( );
        List<SObject> objectsToUpdate = new List<SObject>( );
        Boolean updateIsNeeded = false;
        if ( CODE_OK.equalsIgnoreCase( avrSOSData.requestOutcome ) )
        {
            approvalRequest = prepareApprovalRequest( inObject.Id, APPROVAL_PROCESS_APPROVE, avrSOSData.outcomeCode );
        }
        else if ( CODE_KO.equalsIgnoreCase( avrSOSData.requestOutcome ) )
        {
            approvalRequest = prepareApprovalRequest( inObject.Id, APPROVAL_PROCESS_REJECT, avrSOSData.outcomeCode );

            if ( '09'.equalsIgnoreCase( avrSOSData.outcomeCode ) || '21'.equalsIgnoreCase( avrSOSData.outcomeCode ) )
            {
                inObject = setRefusalValues( inObject, REASON_RIFIUTO_DEFINITIVO, avrSOSData.workerComments );
                objectsToUpdate.addAll( setStatusesOnOrder( inObject.Id ) );
            }
            else if ( '22'.equalsIgnoreCase( avrSOSData.outcomeCode ) )
            {
                inObject = setRefusalValues( inObject, REASON_DOCUMENTAZIONE_INCOMPLETA, avrSOSData.workerComments );
            }
            objectsToUpdate.add( inObject );
            updateIsNeeded = true;
        }

        try
        {
            if ( updateIsNeeded )
            {
                update objectsToUpdate;
                System.debug( LoggingLevel.FINE, 'OB_UpdateDossierSOS.handleApprovalProcess updated objects : ' + objectsToUpdate );
            }

            Approval.ProcessResult approvalResult = Approval.process( approvalRequest );
            avrSOSWrapper.objectId = inObject.Id;
        }
        catch ( Exception ex )
        {
            avrSOSWrapper.avrSOSResponse.httpStatus = HTTP_STATUS_500;
            avrSOSWrapper.avrSOSResponse.httpMessage = ERROR_INTERNAL;
            // NEXI-353 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 04/10/2019 START error handling
            handleError( JSON.serialize( avrSOSData ), avrSOSWrapper, 'OB_UpdateDossierSOS.handleApprovalProcess Exception: ' +
                    ex.getMessage( ) + ' at line: ' + ex.getLineNumber( ) + ' stack trace : ' + ex.getStackTraceString( ) );
            // NEXI-353 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 04/10/2019 STOP
        }
        return avrSOSWrapper;
    }

    /*******************************************************************************
    Purpose:    Method selects ProcessInstance where TargetObjectId is in given set of Ids
    Parameters: Id inId
    Returns:    ProcessInstance

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       22/07/2019      Created         NEXI-215
    ********************************************************************************/
    private static ProcessInstance getProcessInstance( Id inId )
    {
        List<ProcessInstance> processInstances =
        [
                SELECT Id,
                        TargetObjectId
                FROM ProcessInstance
                WHERE TargetObjectId = :inId
                LIMIT 1
        ];

        return processInstances.isEmpty( ) ? null : processInstances.get( 0 );
    }

    /*******************************************************************************
    Purpose:    Method checks if object shouldn't be processed
    Parameters: Id sObjectId
    Returns:    Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/10/2019      Created         NEXI-373
    ********************************************************************************/
    public static Boolean isRequestInvalid( Id inObjectId, String inSosId )
    {
        System.debug( LoggingLevel.FINE, 'OB_UpdateDossierSOS.isRequestInvalid START objectId : ' + inObjectId + ' inSosId : ' + inSosId );
        if ( inObjectId == null || String.isBlank( inSosId ) )
        {
            System.debug( LoggingLevel.FINE, 'OB_UpdateDossierSOS.isRequestInvalid END invalid input parameters' );
            return true;
        }
        for ( Plc_Log__c loopPlcLog :
        [
                SELECT Plc_RequestBody__c
                FROM Plc_Log__c
                WHERE ( OB_OrderId__r.NE__Order_Header__c = :inObjectId OR OB_Log_Request__c = :inObjectId )
                AND Plc_RequestURI__c = :REQUEST_URI_UPDATEDOSSIERSOS
                AND Plc_ResponseStatus__c = :STATUS_S
        ] )
        {
            Map<String, Object> dataToDeserialize = ( Map<String, Object> ) JSON.deserializeUntyped( loopPlcLog.Plc_RequestBody__c );
            AvrSOS loopAvrSOS = ( AvrSOS ) JSON.deserialize( JSON.serialize( dataToDeserialize.get( 'data' ) ), AvrSOS.class );
            if ( inSosId.equalsIgnoreCase( loopAvrSOS.sosId ) )
            {
                // Protect against the second call
                System.debug( LoggingLevel.FINE, 'OB_UpdateDossierSOS.isRequestInvalid END invalid request' );
                return true;
            }
        }
        System.debug( LoggingLevel.FINE, 'OB_UpdateDossierSOS.isRequestInvalid END correct data' );
        return false;
    }

    /*******************************************************************************
    Purpose:    Method creates approval request with given values
    Parameters: Id inId, String inActionName, String inCode
    Returns:    Approval.ProcessWorkItemRequest

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       22/07/2019      Created         NEXI-215
    ********************************************************************************/
    private static Approval.ProcessWorkItemRequest prepareApprovalRequest( Id inId, String inActionName, String inCode )
    {
        Approval.ProcessWorkItemRequest approvalRequest = new Approval.ProcessWorkItemRequest( );
        approvalRequest.setComments( REASONS_DESCRIPTIONS.get( inCode ) );
        approvalRequest.setAction( inActionName );
        approvalRequest.setWorkitemId( getWorkitemId( inId ) );
        return approvalRequest;
    }

    /*******************************************************************************
    Purpose:    Method selects Id of ProcessInstanceWorkitem
    Parameters: Id inTargetObjectId
    Returns:    Id

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       24/07/2019      Created         NEXI-215
    ********************************************************************************/
    private static Id getWorkitemId( Id inTargetObjectId )
    {
        List<ProcessInstanceWorkitem> processInstanceWorkitems =
        [
                SELECT Id
                FROM ProcessInstanceWorkitem
                WHERE ProcessInstance.TargetObjectId = :inTargetObjectId
                LIMIT 1
        ];
        return processInstanceWorkitems.isEmpty( ) ? null : processInstanceWorkitems.get( 0 ).Id;
    }

    /*******************************************************************************
    Purpose:    Method fills rejection fields on SObject
    Parameters: SObject inObject, String inRejectReason, String inWorkerComments
    Returns:    SObject

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       22/07/2019      Created         NEXI-215
    ********************************************************************************/
    private static SObject setRefusalValues( SObject inObject, String inRejectReason, String inWorkerComments )
    {
        if ( inObject instanceof NE__Order_Header__c )
        {
            NE__Order_Header__c orderHeader = new NE__Order_Header__c ( Id = inObject.Id );
            orderHeader.OB_Rejection_Reason__c = inRejectReason;
            orderHeader.OB_Rejection_Comments__c = inWorkerComments;
            return orderHeader;
        }
        OB_LogRequest__c logRequest = ( OB_LogRequest__c ) inObject;
        logRequest.OB_RejectReason__c = inRejectReason;
        logRequest.OB_Rejection_Comments__c = inWorkerComments;
        return logRequest;
    }

    /*******************************************************************************
    Purpose:    Method creates Plc_LogHelper.LogStructure and calls Plc_LogHelper.logCall method
    Parameters: String avrSosRequestBody, AvrSOSResponseWrapper avrSOSWrapper, String exceptionStackTrace
    Returns:    -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       22/07/2019      Created         NEXI-215
    1.1         Joanna Mielczarek       04/10/2019      Modified        NEXI-353 add exception stack trace, added param
    ********************************************************************************/
    private static void createLogStructure( String avrSosRequestBody, AvrSOSResponseWrapper avrSOSWrapper, String exceptionStackTrace )
    {
        System.debug( LoggingLevel.FINE, 'OB_UpdateDossierSOS.createLogStructure START avrsos body ' + avrSosRequestBody );
        Plc_LogHelper.LogStructure logStructure = new Plc_LogHelper.LogStructure( );
        logStructure.processingTime = '00:00:00';
        logStructure.httpMethod = OB_UtilityConstants.METHOD_POST;
        logStructure.requestUri = REQUEST_URI_UPDATEDOSSIERSOS; // NEXI-373 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 18/10/2019
        logStructure.requestBody = String.isEmpty( avrSosRequestBody ) ? '' : avrSosRequestBody;
        logStructure.responseBody = JSON.serialize( avrSOSWrapper.avrSosResponse );
        logStructure.responseStatus = avrSOSWrapper.avrSosResponse.httpStatus != 201 ? 'W' : STATUS_S; // NEXI-373 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 18/10/2019
        logStructure.responseMessage = avrSOSWrapper.avrSosResponse.httpMessage;
        logStructure.responseStackTrace = String.isBlank( exceptionStackTrace ) ? String.valueOf( avrSOSWrapper.avrSosResponse.httpStatus ) : exceptionStackTrace;
        logStructure.recordUrl = avrSOSWrapper.objectId == null ? '' : URL.getOrgDomainUrl( ).toString( ) + '/' + avrSOSWrapper.objectId;
        Id plcId = Plc_LogHelper.logCall( logStructure ); //francesca.ribezzi 26/09/19 - F2WAVE2-189 - logCall returns the plc id
        System.debug( LoggingLevel.FINE, 'OB_UpdateDossierSOS.createLogStructure Plc Log Id ' + plcId );
        //francesca.ribezzi 26/09/19 - F2WAVE2-189 - updating the new plcLog with the object id:
        OB_Utility.updateLogRequestOrderIdOnPlcLog( plcId, avrSOSWrapper.objectId );
    }

    /*******************************************************************************
    Purpose:    Method creates Plc_LogHelper.LogStructure and calls Plc_LogHelper.logCall method - two params
    Parameters: String avrSosRequestBody, AvrSOSResponseWrapper avrSOSWrapper
    Returns:    -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       04/10/2019      Created         NEXI-353
    ********************************************************************************/
    private static void createLogStructure( String avrSosRequestBody, AvrSOSResponseWrapper avrSOSWrapper )
    {
        createLogStructure( avrSosRequestBody, avrSOSWrapper, '' );
    }

    /*******************************************************************************
    Purpose:    Method handle exceptions - create plc log with exception stack trace and shows error debug
    Parameters: String avrSosRequestBody, AvrSOSResponseWrapper avrSOSWrapper, String exceptionStackTrace
    Returns:    -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       04/10/2019      Created         NEXI-353
    ********************************************************************************/
    private static void handleError( String avrSosRequestBody, AvrSOSResponseWrapper avrSOSWrapper, String exceptionStackTrace )
    {
        createLogStructure( avrSosRequestBody, avrSOSWrapper, exceptionStackTrace );
        System.debug( LoggingLevel.ERROR, exceptionStackTrace );
    }

    /*******************************************************************************
    Purpose:    Method selects Order by given Order Header Id and set statuses in case of final refusal by avr sos
    Parameters: String inOrderHeaderId
    Returns:    List<SObject>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       03/10/2019      Created         NEXI-357
    ********************************************************************************/
    private static List<SObject> setStatusesOnOrder( String inOrderHeaderId )
    {
        System.debug( LoggingLevel.FINE, 'OB_UpdateDossierSOS.setStatusesOnOrder START Id : ' + inOrderHeaderId );
        List<SObject> ordersToUpdate = new List<SObject>( );
        if ( !OB_Util009_AVRSOS.isExpectedId( inOrderHeaderId, 'NE__Order_Header__c' ) )
        {
            System.debug( LoggingLevel.FINE, 'OB_UpdateDossierSOS.setStatusesOnOrder END Is not OrderHeader' );
            return ordersToUpdate;
        }
        for ( NE__Order__c loopOrder :
        [
                SELECT Id
                FROM NE__Order__c
                WHERE NE__Order_Header__c = :inOrderHeaderId
        ] )
        {
            loopOrder.OB_Nexi_OrderStatus__c = OB_UtilityConstants.BANKORDERSTATUS_PROCEDUREREFUSED;
            loopOrder.OB_Bank_OrderStatus__c = OB_UtilityConstants.BANKORDERSTATUS_PROCEDUREREFUSED;
            ordersToUpdate.add( loopOrder );
        }
        System.debug( LoggingLevel.FINE, 'OB_UpdateDossierSOS.setStatusesOnOrder END order to update : ' + ordersToUpdate );
        return ordersToUpdate;
    }
}