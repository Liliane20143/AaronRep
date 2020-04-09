public with sharing class OB_LogRequestTriggerHandler
{
    public static final Id MAINTENANCE_ANAGRAFICA_RECORD_TYPE = Schema.SObjectType.OB_LogRequest__c.getRecordTypeInfosByDeveloperName( ).get( 'OB_Anagrafica' ).getRecordTypeId( );//NEXI-64 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 06/06/2019
    /*****************************************************************
	Purpose: Method to check Log Request when pass the approval process
	Throws [Exceptions]: [optional]

	History
	--------
	VERSION AUTHOR 				DATE 		    DETAIL 		Description
	1.0 	Salvatore Pianura 	13/05/2019 	    Created 	CSR:
	1.1     Marta Stempien      02/10/2019      Modified    NEXI-354 - method changed to static
	*****************************************************************/
    public static void checkApprovalAction( Map<Id, OB_LogRequest__c> oldOrds, Map<Id, OB_LogRequest__c> newOrds )
    {
        if ( oldOrds.size( ) > 0 && newOrds.size( ) > 0 )
        {
            List<OB_LogRequest__c> listOfLogRequest = new List<OB_LogRequest__c>( );
            for ( OB_LogRequest__c currentLogRequest : newOrds.values( ) )
            {
                if ( currentLogRequest.OB_ApprovalProcess__c == true &&
                        currentLogRequest.OB_SIAToBeApproved__c == false &&
                        currentLogRequest.OB_EquensMoneticaToBeApproved__c == false )
                {
                    OB_Utility.serializeAnagrafica( currentLogRequest.Id );
                }
                else if ( currentLogRequest.OB_ApprovalProcess__c == true &&
                        ( currentLogRequest.OB_SIAToBeApproved__c == true ||
                                currentLogRequest.OB_EquensMoneticaToBeApproved__c == true ) &&
                        currentLogRequest.OB_Status__c != OB_UtilityConstants.CONFERMATO ) // antonio.vatrano wn-234 01/08/2019
                {
                    currentLogRequest.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA;
                }
            }
        }
    }

    /*******************************************************************************
    Purpose:  Method check if log reuests was resolved and execute proper logic on this resolution
    Parameters: Map<Id,OB_LogRequest__c> inNewLogRequests, Map<Id,OB_LogRequest__c> inOldLogRequests
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       06/06/2019      Created         NEXI-64
    1.1         Marta Stempien          10/06/2019      Modified        NEXI-97
    1.2         Marta Stempien          13/06/2019      Modified        NEXI-94
    1.3         Marta Stempien          17/06/2019      Modified        NEXI-97
	1.4         Zuzanna Urban           19/06/2019      Modified        NEXI-109
	1.5  	    Zuzanna Urban		     01/07/2019      Modified		  NEXI-148
    ********************************************************************************/
    @AuraEnabled
    public static void logRequestResolution( Map<Id, OB_LogRequest__c> inNewLogRequests, Map<Id, OB_LogRequest__c> inOldLogRequests )
    {
        List<SObject> objectsToUpdate = new List<SObject>( );
        List<SObject> objectsToInsert = new List<SObject>( );
        List<SObject> objectsToDelete = new List<SObject>( );

        Map <Id, ExternalSourceMapping__c> externalSourceMappingsByServicePointsIds = new Map<Id, ExternalSourceMapping__c>( );

        for ( Id objectId : inNewLogRequests.keySet( ) )
        {
            OB_LogRequest__c newLogRequest = inNewLogRequests.get( objectId );
            OB_LogRequest__c oldLogRequest = inOldLogRequests.get( objectId );
            if ( ( newLogRequest.OB_Status__c == oldLogRequest.OB_Status__c ) || !OB_UtilityConstants.CONFERMATO.equalsIgnoreCase( newLogRequest.OB_Status__c ) )
            {
                continue;
            }
            if ( MAINTENANCE_ANAGRAFICA_RECORD_TYPE == newLogRequest.RecordTypeId )
            {
                if ( newLogRequest.OB_Change_of_data_of_beneficial_owners__c )
                {
                    OB_Util006_MaintenanceAnagrafica.LogRequestResolutionWrapper sortedData = OB_Util006_MaintenanceAnagrafica.prepareDataForResolution( newLogRequest );
                    objectsToUpdate.addAll( sortedData.objectsToUpdate );
                    objectsToInsert.addAll( sortedData.objectsToInsert );
                    objectsToUpdate.addAll( setContactEndDate( sortedData.objectsToDelete ) ); // NEXI-60 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 17/06/2019
                }
                else if ( newLogRequest.OB_ChangeCompanyData__c )
                {
                    OB_Util006_MaintenanceAnagrafica.LogRequestResolutionWrapper sortedData = OB_Util006_MaintenanceAnagrafica.prepareDataForResolutionUpdate( newLogRequest, true );
                    objectsToUpdate.addAll( sortedData.objectsToUpdate );
                }
                // NEXI-94 Marta Stempien <marta.stempien@accenture.com> 17/06/2019 - Start
                else if ( newLogRequest.OB_ChangeLegalRepresentative__c )
                {
                    OB_Util006_MaintenanceAnagrafica.LogRequestResolutionWrapper sortedData = OB_Util006_MaintenanceAnagrafica.prepareDataForResolution( newLogRequest );
                    objectsToUpdate.addAll( sortedData.objectsToUpdate );
                }
                else if ( newLogRequest.OB_NewLegalRepresentative__c )
                {
                    OB_Util006_MaintenanceAnagrafica.LogRequestResolutionWrapper sortedData = OB_Util006_MaintenanceAnagrafica.prepareDataForResolution( newLogRequest );
                    objectsToInsert.addAll( sortedData.objectsToInsert );
                    objectsToUpdate.addAll( sortedData.objectsToUpdate ); // NEXI-137 Marta Stempien <marta.stempien@accenture.com> 28/06/2019 Added
                }
                // NEXI-94 Marta Stempien <marta.stempien@accenture.com> 17/06/2019 - Stop
                // NEXI-87 Marta Stempien <marta.stempien@accenture.com> 17/06/2019 - Start
                else if ( newLogRequest.OB_ChangeServicePointData__c )
                {
                    OB_Util006_MaintenanceAnagrafica.LogRequestResolutionWrapper sortedData = OB_Util006_MaintenanceAnagrafica.prepareDataForResolutionUpdate( newLogRequest, false );
                    objectsToUpdate.addAll( sortedData.objectsToUpdate );
                    externalSourceMappingsByServicePointsIds.putAll( OB_Util006_MaintenanceAnagrafica.prepareDataForAssetsUpdate( newLogRequest ) );
                    //NEXI-109 Zuzanna Urban <z.urban@accenture.com> 19/06/2019 - Start
                    OB_Util006_MaintenanceAnagrafica.prepareContact( newLogRequest );
                    //NEXI-109 Zuzanna Urban <z.urban@accenture.com> 19/06/2019 - Stop
                }
            }
        }

        List <Asset> assetsToUpdate =
        [
                SELECT ID,
                        OB_MCC__c,
                        OB_MCCL2__c,
                        NE__Service_Point__c
                FROM Asset
                WHERE NE__Service_Point__c IN :externalSourceMappingsByServicePointsIds.keySet( )
        ];

        for ( Asset aAsset : assetsToUpdate )
        {
            aAsset.OB_MCC__c = externalSourceMappingsByServicePointsIds.get( aAsset.NE__Service_Point__c ).OB_MCC__c;
            aAsset.OB_MCCL2__c = externalSourceMappingsByServicePointsIds.get( aAsset.NE__Service_Point__c ).OB_MCCL2__c;
        }
        objectsToUpdate.addAll( assetsToUpdate );
        List <NE__Service_Point__c> servicePointsToUpdate = [ SELECT Id FROM NE__Service_Point__c WHERE Id IN :externalSourceMappingsByServicePointsIds.keySet( ) ];
        for ( NE__Service_Point__c servicePointToUpdate : servicePointsToUpdate )
        {
            servicePointToUpdate.OB_MCC__c = externalSourceMappingsByServicePointsIds.get( servicePointToUpdate.Id ).OB_MCC__c;
        }
        objectsToUpdate.addAll( servicePointsToUpdate );
        // NEXI-87 Marta Stempien <marta.stempien@accenture.com> 17/06/2019 - Stop

        Savepoint sSavePoint = Database.setSavepoint( );
        try
        {
            update objectsToUpdate;
            delete objectsToDelete;
            insert objectsToInsert;
            System.debug( LoggingLevel.INFO, 'OB_LogRequestTriggerHandler.logRequestResolution end objectsToUpdate '
                    + objectsToUpdate + ' objectsToDelete ' + objectsToDelete + ' objectsToInsert ' + objectsToInsert );
        } catch ( DmlException ex )
        {
            System.debug( LoggingLevel.ERROR, '[EXC] Exception ' + ex.getMessage( ) + ' stacktrace ' + ex.getStackTraceString( ) );
            Database.rollback( sSavePoint );
            // NEXI-148 Zuzanna Urban <z.urban@accenture.com> 01/07/2019 - Start
            String dmlExceptionValue = ex.getMessage( ) + '\r\n' + ex.getStackTraceString( ) + '\r\n';
            AuraHandledException e = new AuraHandledException( dmlExceptionValue );
            e.setMessage( dmlExceptionValue );
            throw e;
            // NEXI-148 Zuzanna Urban <z.urban@accenture.com> 01/07/2019 - Stop
        }
    }

    // NEXI-181 Marta Stempien <marta.stempien@accenture.com> 17/07 Deleted unnecessary method

    /*******************************************************************************
    Purpose:  Method sets OB_EndDate__c of Contact's from removal list
    Parameters: List<SObject> objectsToDelete
    Returns: List<SObject>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/06/2019      Created         NEXI-60
    1.1         Joanna Mielczarek       28/06/2019      Modified        NEXI-142 added OB_Contact_State__c setting
    ********************************************************************************/
    private static List<SObject> setContactEndDate( List<SObject> objectsToDelete )
    {
        for ( SObject loopObject : objectsToDelete )
        {
            loopObject.put( 'OB_EndDate__c', System.today( ) );
            loopObject.put( 'OB_Contact_State__c', OB_UtilityConstants.STATUS_INACTIVE ); // NEXI-142 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 28.06.2019
        }
        return objectsToDelete;
    }

    /*******************************************************************************
    Purpose:  Method is hanlder after log request insert. Special logic for Settlement Procedure (modalità di liquidazione)
    Parameters: List<OB_LogRequest__c> inLogRequest
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       10/07/2019      Created         NEXI-185
    1.1         Marta Stempien          25/07/2019      Modified        NEXI-181
    ********************************************************************************/
    public static void afterInsertHandler( List<OB_LogRequest__c> inLogRequest )
    {
        System.debug( LoggingLevel.INFO, 'OB_LogRequestTriggerHandler.afterInsertHandler ' + inLogRequest );
        if ( inLogRequest == null )return;
        List<OB_LogRequest__c> settlementProcedureLogRequests = new List<OB_LogRequest__c>( );
        List<OB_LogRequest__c> changeReportTypesLogRequests = new List<OB_LogRequest__c>( );

        for ( OB_LogRequest__c loopLogRequest : inLogRequest )
        {
            System.debug( LoggingLevel.INFO, 'OB_LogRequestTriggerHandler.afterInsertHandler in loop ' + loopLogRequest.Id + ' , ' + loopLogRequest.OB_Settlement_Procedure__c );
            if ( loopLogRequest.OB_Settlement_Procedure__c )
            {
                settlementProcedureLogRequests.add( loopLogRequest );
            }
            //NEXI-181 Marta Stempien <marta.stempien@accenture.com> 16/07/2019 Start
            else if ( loopLogRequest.OB_change_of_reporting_type__c )
            {
                changeReportTypesLogRequests.add( loopLogRequest );
            }
            //NEXI-181 Marta Stempien <marta.stempien@accenture.com> 16/07/2019 Stop

        }
        System.debug( LoggingLevel.INFO, 'OB_LogRequestTriggerHandler.afterInsertHandler settlementProcedureLogRequests ' + settlementProcedureLogRequests );
        System.debug( LoggingLevel.INFO, 'OB_LogRequestTriggerHandler.afterInsertHandler changeReportTypesLogRequests ' + changeReportTypesLogRequests );
        if ( !settlementProcedureLogRequests.isEmpty( ) )
        {
            OB_Util006_MaintenanceAnagrafica.resolveSettlementProcedures( settlementProcedureLogRequests );
        }
        //NEXI-181 Marta Stempien <marta.stempien@accenture.com> 31/07/2019 Start
        if ( !changeReportTypesLogRequests.isEmpty( ) )
        {
            OB_Util006_MaintenanceAnagrafica.resolveExternalSourceMappingChangeReportTypeLogRequest( changeReportTypesLogRequests );
        }
        //NEXI-181 Marta Stempien <marta.stempien@accenture.com> 31/07/2019 Stop
    }

    /*******************************************************************************
    Purpose: Restart approval process
    Parameters: Map<Id,OB_LogRequest__c> oldLogs, Map<Id,OB_LogRequest__c> newLogs
    Returns: -
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0			Zuzanna Urban		 25/07/2019		   Created			 NEXI-217
    2.0        Marta Stempien       13/09/2019         Modified          NEXI-326
    2.1        Adrian Dlugolecki    20/09/2019         Changed          NEXI-343
    ********************************************************************************/
    public static void restartApproval( Map<Id, OB_LogRequest__c> oldLogs, Map<Id, OB_LogRequest__c> newLogs )
    {
        System.debug( LoggingLevel.FINE, 'OB_LogRequestTriggerHandler.restartApproval Start ' + newLogs );
        Map<Id, OB_LogRequest__c> newLogsMap = new Map<Id, OB_LogRequest__c>( );

        if ( oldLogs == null || newLogs == null || oldLogs.size( ) == 0 || newLogs.size( ) == 0 )
        {
            return;
        }
        Set<Id> newLogRequestIds = new Set<Id>( newLogs.keySet( ) );
        Map<Id, String> lastStepsById = getApprovalStep( newLogRequestIds );
        System.debug( LoggingLevel.FINE, 'OB_LogRequestTriggerHandler.restartApproval lastStepsById ' + lastStepsById );
        for ( OB_LogRequest__c newLog : newLogs.values( ) )
        {
            String oldRejectReason = '';
            String currentStep = lastStepsById.get( newLog.id ) != null ? lastStepsById.get( newLog.id ) : '';
            OB_LogRequest__c oldLog = oldLogs.get( newLog.id );
            if ( oldLog != null && !String.isBlank( oldLog.OB_RejectReason__c ) )
            {
                oldRejectReason = oldLog.OB_RejectReason__c;
            }
            System.debug( LoggingLevel.FINE, 'OB_LogRequestTriggerHandler.restartApproval oldRejectReason ' + oldRejectReason );
            System.debug( LoggingLevel.FINE, 'OB_LogRequestTriggerHandler.restartApproval newRejectReason ' + newLog.OB_RejectReason__c );
            Boolean isRejectReasonCHanged = !oldRejectReason.equalsIgnoreCase( newLog.OB_RejectReason__c );
            System.debug( LoggingLevel.FINE, 'OB_LogRequestTriggerHandler.restartApproval isRejectReasonCHanged ' + isRejectReasonCHanged );
            //NEXI-326 Marta Stempien <marta.stempien@accenture.com> 13/09/2019 Start
            Boolean isStartApprovalOriginalValue = newLog.OB_StartApprovalProcess__c;
            newLog.OB_StartApprovalProcess__c = true;
            Boolean isStepOk = currentStep.equalsIgnoreCase( 'Controlli Sicurezza Maintenance' )
                    || currentStep.equalsIgnoreCase( 'Responsabile risk evaluation' )
                    || currentStep.equalsIgnoreCase( 'Responsabile frauds and credits' ) ;
            System.debug( LoggingLevel.FINE, 'OB_LogRequestTriggerHandler.restartApproval isStepOk ' + isStepOk );
            Boolean isProperRejectReason = OB_UtilityConstants.REJECTION_ABSENT_DOCUMENTATION.equalsIgnoreCase( newLog.OB_RejectReason__c ) || OB_UtilityConstants.REJECTION_INCOMPLETE_DOCUMENTATION.equalsIgnoreCase( newLog.OB_RejectReason__c );
            System.debug( LoggingLevel.FINE, 'OB_LogRequestTriggerHandler.restartApproval isProperRejectReason ' + isProperRejectReason );
            Boolean standardCheck = OB_Utility.checkStepsEntryCriteriaLogRequest( newLog );
            System.debug( LoggingLevel.FINE, 'OB_LogRequestTriggerHandler.restartApproval standardCheck ' + standardCheck );

            //NEXI-326 Marta Stempien <marta.stempien@accenture.com> 13/09/2019 Stop
            if ( ( ( isStepOk && isProperRejectReason ) || newLog.OB_ApprovalStep__c == '3' )  //NEXI-344 Kinga Fornal <kinga.fornal@accenture.com>, 24.09.2019
                    && isRejectReasonCHanged
                    && String.isNotBlank( newLog.OB_RejectReason__c ) //NEXI-344 Kinga Fornal <kinga.fornal@accenture.com>, 24.09.2019
                    && standardCheck )  //NEXI-287 Marta Stempien <marta.stempien@accenture.com> 29/08/2019 Added check for meeting steps entry criteria
            {
                newLogsMap.put( newLog.Id, newLog );
            }
            //NEXI-326 Marta Stempien <marta.stempien@accenture.com> 13/09/2019 Start
            else
            {
                newLog.OB_StartApprovalProcess__c = isStartApprovalOriginalValue;
            }
            //NEXI-326 Marta Stempien <marta.stempien@accenture.com> 13/09/2019 Stop
        }
        System.debug( LoggingLevel.FINE, 'OB_LogRequestTriggerHandler.restartApproval newLogsMap ' + newLogsMap );
        if ( newLogsMap.size( ) > 0 )
        {
            startApproval( JSON.serialize( newLogsMap ) );
        }
    }

    /*******************************************************************************
    Purpose:  Method Chack what was last approval process ( before reject)
    Parameters: Set<Id> inLogRequestsIds
    Returns: Map<Id, String>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       20/09/2019      Created         NEXI-343
    ********************************************************************************/
    public static Map<Id, String> getApprovalStep( Set<Id> inLogRequestsIds )
    {
        Map<Id, String> result = new Map<Id, String>( );
        for ( ProcessInstance loopProcessInstance :
        [
                SELECT
                        TargetObjectId,
                ( SELECT ActorId,Comments,OriginalActor.Name FROM StepsAndWorkitems )
                FROM ProcessInstance
                WHERE TargetObjectId IN :inLogRequestsIds
                AND Status = 'Rejected'
                Order by CreatedDate DESC
        ] )
        {
            if ( !result.containsKey( loopProcessInstance.TargetObjectId ) )
            {
                result.put( loopProcessInstance.TargetObjectId, loopProcessInstance.StepsAndWorkitems.get( loopProcessInstance.StepsAndWorkitems.size( ) - 1 ).OriginalActor.Name );
            }
        }
        return result;
    }

    /*******************************************************************************
    Purpose: New approval process
	Parameters: String logRequestJSON
	Returns: -
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0			Zuzanna Urban		 26/07/2019		   Created			 NEXI-217
	2.0        Marta Stempien       13/09/2019         Modified          NEXI-326
	2.1        Adrian Dlugolecki    20/09/2019         Changed          NEXI-343 add test visible
    ********************************************************************************/
    @future
    @TestVisible
    private static void startApproval( String logRequestJSON )
    {
        Map<Id, OB_LogRequest__c> currentLogsMap = ( Map<Id, OB_LogRequest__c> ) JSON.deserialize( logRequestJSON, Map<Id, OB_LogRequest__c>.class );
        List<Approval.ProcessSubmitRequest> requestsApprovalList = new List<Approval.ProcessSubmitRequest>( );
        List<OB_LogRequest__c> logRequestList = new List<OB_LogRequest__c>( );
        for ( Id currentLogId : currentLogsMap.keySet( ) )
        {
            Approval.ProcessSubmitRequest requstApproval = new Approval.ProcessSubmitRequest( );
            requstApproval.setComments( 'Submitting request for approval.' );
            requstApproval.setObjectId( currentLogId );
            requstApproval.setProcessDefinitionNameOrId( Label.OB_MAINTENANCE_APPROVALPROCESS );
            requstApproval.setSubmitterId( UserInfo.getUserId( ) );
            requstApproval.setSkipEntryCriteria( true );
            requestsApprovalList.add( requstApproval );
            logRequestList.add( currentLogsMap.get( currentLogId ) );
        }
        Approval.ProcessResult[] processResults = Approval.process( requestsApprovalList );
    }

    /*******************************************************************************
    Purpose: Set Bozza status for approved integrated logrequest and Confermato status for not integrated ones
	Parameters: Map<Id, OB_LogRequest__c> inNewLogRequests, Map<Id, OB_LogRequest__c> inOldLogRequests
	Returns: -
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0        Marta Stempien          02/10/2019       Created         NEXI-354
    ********************************************************************************/
    public static void setStatuses( Map<Id, OB_LogRequest__c> inNewLogRequests, Map<Id, OB_LogRequest__c> inOldLogRequests )
    {
        System.debug( LoggingLevel.FINE, 'OB_LogRequestTriggerHandler.setStatuses Start new: ' + inNewLogRequests + ' old: ' + inOldLogRequests );
        if ( inNewLogRequests == null || inOldLogRequests == null )
        {
            System.debug( LoggingLevel.FINE, 'OB_LogRequestTriggerHandler.setStatuses Stop null');
            return;
        }
        for ( Id logRequestId : inNewLogRequests.keySet( ) )
        {
            OB_LogRequest__c newLogRequest = inNewLogRequests.get( logRequestId );
            OB_LogRequest__c oldLogRequest = inOldLogRequests.get( logRequestId );

            if ( OB_Utility.isBooleanTrue( newLogRequest.OB_ApprovalProcess__c ) && oldLogRequest != null && !OB_Utility.isBooleanTrue( oldLogRequest.OB_ApprovalProcess__c ) )
            {
                if ( OB_Utility.isBooleanTrue( newLogRequest.OB_isNotIntegrated__c ) )
                {
                    newLogRequest.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA;//Simone Misani fix 17/10/ 20.14
                }
                else
                {
                    newLogRequest.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT;
                }
            }
        }
        System.debug( LoggingLevel.FINE, 'OB_LogRequestTriggerHandler.setStatuses Stop - inNewLogRequests: ' + inNewLogRequests );
    }
}