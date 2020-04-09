/**
 * Created by adrian.dlugolecki on 31.05.2019.
 */
//elena.preteni changed with sharing --> without sharing WN-101 13/07/2019
public without sharing class OB_Util006_MaintenanceAnagrafica
{
    public static final String MAINTENANCE_TYPE_TITOLARI_EFFETTTIVI = 'MaintenanceTE';
    public static final String MAINTENANCE_TYPE_MCC = 'MaintenanceMCC';
    public static final String DOCUMENT_SAE_ATECO_STATUO = 'Statuto e/o atto costitutitvo';
    public static final String DOCUMENT_SAE_ATECO_MODULO = 'Modulo scia';
    public static final String DOCUMENT_SAE_ATECO_VISURA = 'Visura camerale';
    //elena.preteni 12/07/2019 WN - 83
    //Start antonio.vatrano wn_326 05/09/2019 
    public static final String DOCUMENT_SAE_ATECO_TRIS = 'Visura o Atto Costitutivo o Modulo SCIA';
    public static final List<String> DOCUMENT_SAE_ATECO = new List<String> {DOCUMENT_SAE_ATECO_TRIS};
    public static final List<String> DOCUMENT_SAE_ATECO_DESCRIPTIONS = new List<String> {'STATUTO VISURA SCIA'};
    //End antonio.vatrano wn_326 05/09/2019 
    //elena.preteni 12/07/2019 WN - 83
    // NEXI-94 Marta Stempien <marta.stempien@accenture.com> 17/06/2019 - Fix for NEXI-97 - Start
    public static final String ASSET_STATUS_ACTIVE = 'Active';
    public static final String ASSET_STATUS_IN_PROGRESS = 'In progress';
    public static final String REQUEST_TYPOLOGY_MAINTENANCE = 'Maintenance';
    // NEXI-94 Marta Stempien <marta.stempien@accenture.com> 17/06/2019 - Stop
    // NEXI-131 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 27/06/2019 Start
    public static final List<String> DOCUMENT_TE = new List<String> {'Documento di identità legale rappresentante e titolari effettivi', 'Codice Fiscale legale rappresentante e titolari effettivi'};                                  //NEXI-153 Wojciech Kucharek<wojciech.kucharek@accenture.comm>, 04.07.2019 - remove redundant const
    public static final List<String> DOCUMENT_TE_DESCRIPTIONS = new List<String> {'DOCUMENTO DI IDENTITA', 'CARTA REGIONALE SERVIZI', 'STATUTO VISURA SCIA'};                                                                           //NEXI-153 Wojciech Kucharek<wojciech.kucharek@accenture.comm>, 04.07.2019 - remove redundant const
    public static final List<String> DOCUMENT_TE_ADD = new List<String> {'Documento di identità legale rappresentante e titolari effettivi', 'Codice Fiscale legale rappresentante e titolari effettivi', 'Visura o Atto Costitutivo o Modulo SCIA'};   //Vatrano Antonio //NEXI-153 Wojciech Kucharek<wojciech.kucharek@accenture.comm>, 04.07.2019 - remove redundant const
    public static final List<String> DOCUMENT_TE_DESCRIPTIONS_ADD = new List<String> {'DOCUMENTO DI IDENTITA', 'CARTA REGIONALE SERVIZI', 'STATUTO VISURA SCIA'};                                                                            //NEXI-153 Wojciech Kucharek<wojciech.kucharek@accenture.comm>, 04.07.2019 - remove redundant const
    // NEXI-60 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 19/06/2019 Stop
    // NEXI-131 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 27/06/2019 Stop
    // NEXI-83 Marta Stempien <marta.stempien@accenture.com>, 26/06/2019 Start
    public static final String MCC_TYPE_GAMBLING = 'Gambling';
    public static final String MCC_TYPE_PO118 = 'PO118';
    // NEXI-83 Marta Stempien <marta.stempien@accenture.com>, 26/06/2019 Stop
    // NEXI-120 Marta Stempien <marta.stempien@accenture.com>, 25/07/2019 Start
    public static final String TYPE_OF_LOV_ATECO = 'ATECO';
    public static final String TYPE_OF_LOV_SAE = 'SAE';
    // NEXI-120 Marta Stempien <marta.stempien@accenture.com>, 25/07/2019 Stop
    // NEXI-185 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 11/07/2019 Start
    public static final String SETTLEMENT_PROCEDURE_LORDO = 'ACCREDITO AL LORDO DELLE COMMISSIONI';
    public static final String SETTLEMENT_PROCEDURE_NETTO = 'ACCREDITO AL NETTO DELLE COMMISSIONI';
    public static final String SETTLEMENT_PROCEDURE_ASSET_BANCA_LORDO = 'BANCA (ACCREDITO AL LORDO DELLE COMMISSIONI)';
    public static final String SETTLEMENT_PROCEDURE_ASSET_NEXI_LORDO = 'NEXI (ACCREDITO AL LORDO DELLE COMMISSIONI)';
    public static final String SETTLEMENT_PROCEDURE_ASSET_BANCA_NETTO = 'BANCA (ACCREDITO AL NETTO DELLE COMMISSIONI)';
    public static final String SETTLEMENT_PROCEDURE_ASSET_NEXI_NETTO = 'NEXI (ACCREDITO AL NETTO DELLE COMMISSIONI)';
    // NEXI-185 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 27/06/2019 Stop

    /*******************************************************************************
    Purpose:  Method Select proper log request
    Parameters: List<String> inLogRequestIds
    Returns: List<OB_LogRequest__c>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       31/05/2019      Created         NEXI-85
    2.0         Wojciech Szuba          22/07/2019      Modified        NEXI-206
    ********************************************************************************/
    public static List<OB_LogRequest__c> getLogRequest( List<String> inLogRequestIds )
    {
        if ( inLogRequestIds == null || inLogRequestIds.isEmpty( ) )
        {
            return new List<OB_LogRequest__c>( );
        }
        return
        [
                SELECT Id,
                        OB_Gianos__c, // NEXI-206, Wojciech Szuba, <wojciech.szuba@accenture.com>, 22/07/2019, Added needed field
                        OB_ReducedOldData__c,
                        OB_ReducedNewData__c,
                        OB_AccountId__c,
                        OB_isGambling__c,
                        OB_isBlackList__c,
                        OB_Change_of_data_of_beneficial_owners__c,
                        OB_PO118_eCommerce__c,
                        OB_NewLegalRepresentative__c, //NEXI-342, Kinga Fornal, <kinga.fornal@gmail.com>, 19/09/2019
                        OB_PEP__c
                FROM OB_LogRequest__c
                WHERE Id IN :inLogRequestIds
                LIMIT 50000
        ];
    }

    /*******************************************************************************
    Purpose:  Method select proper assets and aggregate them by account id
    Parameters:  Set<Id> inAccountIds
    Returns: Map<Id,List<Asset>>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       04/06/2019      Created         NEXI-61
    ********************************************************************************/
    private static Map<Id, List<Asset>> getRelatedAssetsByAccountId( Set<Id> inAccountIds )
    {
        Map<Id, List<Asset>> result = new Map<Id, List<Asset>>( );
        for ( Asset loopAsset :
        [
                SELECT Id,
                        AccountId
                FROM Asset
                WHERE NE__CatalogItem__r.NE__ProductId__r.OB_Acquirer__c = :OB_UtilityConstants.PRODUCT_ACQUIRER_NEXI
                AND ( NE__Status__c = :ASSET_STATUS_ACTIVE OR NE__Status__c = :ASSET_STATUS_IN_PROGRESS) // NEXI-94 Marta Stempien <marta.stempien@accenture.com> 17/06/2019 - Fix for NEXI-97
                AND AccountId IN :inAccountIds
                LIMIT 50000
        ] )
        {
            if ( result.containsKey( loopAsset.AccountId ) )
            {
                result.get( loopAsset.AccountId ).add( loopAsset );
            }
            else
            {
                result.put( loopAsset.AccountId, new List<Asset> {loopAsset} );
            }
        }
        return result;
    }

    /*******************************************************************************
    Purpose:  Method invoke OB_Controlli_Maintenance approval process in maintenance anagrafica process
    Parameters: List<String> inLogRequestIds, String inMaintenanceType
    Returns: Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       30/05/2019      Created         NEXI-85
    2.0         Wojciech Szuba          19/07/2019      Modified        NEXI-206
    ********************************************************************************/
    public static Boolean startMaintenanceApprovalProcessIfNeeded( List<String> inLogRequestIds, String inMaintenanceType )
    {
        List<OB_LogRequest__c> mainLogRequests = getLogRequest( inLogRequestIds );
        if ( mainLogRequests.isEmpty( ) )
        {
            return false;
        }
        Set<Id> accountsIds = new Set<Id>( );
        // NEXI-206, Wojciech Szuba, <wojciech.szuba@accenture.com>, 19/07/2019, START
        List<Id> logRequestsIds = new List<Id>( );
        for ( OB_LogRequest__c loopLogRequest : mainLogRequests )
        {
            accountsIds.add( loopLogRequest.OB_AccountId__c );
            logRequestsIds.add( loopLogRequest.Id );
        }
        Map<Id, List<String>> specialCategories = OB_Util009_SpecialCategory.detectSpecialCategory( logRequestsIds );
        List<Id> listOfNexiProductsIds = getListSpecificOfNexiProductIds( );
        List<Id> listOfAssetAccountsId = getListOfAssetsAccountsIds( accountsIds, listOfNexiProductsIds );
        //NEXI-206, Wojciech Szuba, <wojciech.szuba@accenture.com>, 19/07/2019, STOP
        Map<Id, List<Asset>> assetsByAccountId = getRelatedAssetsByAccountId( accountsIds );
        List<OB_LogRequest__c> logRequestThatCanHaveApprovalProcess = new List<OB_LogRequest__c>( );
        for ( OB_LogRequest__c loopLogRequest : mainLogRequests )
        {
            if ( assetsByAccountId.containsKey( loopLogRequest.OB_AccountId__c ) )
            {
                logRequestThatCanHaveApprovalProcess.add( loopLogRequest );
            }
        }
        try
        {
            //NEXI-206, Wojciech Szuba, <wojciech.szuba@accenture.com>, 19/07/2019, START
            Set<Id> logRequestIdsAfterValidation = getFirstLogRequestValidation( logRequestThatCanHaveApprovalProcess, inMaintenanceType );
            Set<OB_LogRequest__c> logsForAnotherCheck = new Set<OB_LogRequest__c>( );
            Set<OB_LogRequest__c> logsAlreadyChecked = new Set<OB_LogRequest__c>( );
            for ( OB_LogRequest__c loopLogRequest : logRequestThatCanHaveApprovalProcess )
            {
                if ( ( loopLogRequest.OB_Change_of_data_of_beneficial_owners__c || loopLogRequest.OB_NewLegalRepresentative__c )
                        && logRequestIdsAfterValidation.contains( loopLogRequest.Id ) )
                {
                    logsForAnotherCheck.add( loopLogRequest );
                }
                else if ( !( loopLogRequest.OB_Change_of_data_of_beneficial_owners__c || loopLogRequest.OB_NewLegalRepresentative__c )
                        && logRequestIdsAfterValidation.contains( loopLogRequest.Id ) )
                {
                    logsAlreadyChecked.add( loopLogRequest );
                }
            }
            Boolean hasSpecialCategory;
            Integer gianosValue;
            Set<Id> logRequestIdsReadyForApproval = new Set<Id>( );
            for ( OB_LogRequest__c loopLogRequest : logsAlreadyChecked )
            {
                logRequestIdsReadyForApproval.add( loopLogRequest.Id );
            }
            for ( OB_LogRequest__c loopLogRequest : logsForAnotherCheck )
            {
                hasSpecialCategory = ( !specialCategories.get( loopLogRequest.Id ).isEmpty( ) ? true : false );
                if ( loopLogRequest.OB_Gianos__c != null )
                {
                    gianosValue = ( ( loopLogRequest.OB_Gianos__c ).isNumeric( ) ) ? Integer.valueOf( loopLogRequest.OB_Gianos__c ) : 0;
                    if ( listOfAssetAccountsId.contains( loopLogRequest.OB_AccountId__c )
                            && ( loopLogRequest.OB_isBlackList__c
                            || hasSpecialCategory
                            || loopLogRequest.OB_PO118_eCommerce__c
                            || loopLogRequest.OB_PEP__c
                            || gianosValue >= 25 ) )
                    {
                        logRequestIdsReadyForApproval.add( loopLogRequest.Id );
                    }
                }
                else
                {
                    if ( listOfAssetAccountsId.contains( loopLogRequest.OB_AccountId__c )
                            && ( loopLogRequest.OB_isBlackList__c
                            || hasSpecialCategory
                            || loopLogRequest.OB_PO118_eCommerce__c
                            || loopLogRequest.OB_PEP__c ) )
                    {
                        logRequestIdsReadyForApproval.add( loopLogRequest.Id );
                    }
                }
            }
            //NEXI-206, Wojciech Szuba, <wojciech.szuba@accenture.com>, 19/07/2019, STOP
            if ( logRequestIdsReadyForApproval.isEmpty( ) )
            {
                return false;
            }
            updateLogRequestForApprovalProcess( logRequestIdsReadyForApproval, inMaintenanceType );
            submitApprovalProcess( logRequestIdsReadyForApproval, Label.OB_MAINTENANCE_APPROVALPROCESS );
            //NEXI-214, Kinga Fornal, kinga.fornal@accenture.com, 22/07/2019, START
            List<OB_LogRequest__c> logRequestsForAVRSOS =
            [
                    SELECT Id, OB_AccountId__c
                    FROM OB_LogRequest__c
                    WHERE Id IN :logRequestIdsReadyForApproval
            ];
            if ( !logRequestsForAVRSOS.isEmpty( ) )
            {
                for ( OB_LogRequest__c logRequest : logRequestsForAVRSOS )
                {
                    OB_Util009_AVRSOS.calloutAVRSOS( logRequest.OB_AccountId__c, logRequest.Id, OB_UtilityConstants.MAINTENANCE );
                }
            }
            //NEXI-214, Kinga Fornal, kinga.fornal@accenture.com, 22/07/2019, STOP
        } catch ( Exception ex )
        {
            System.debug( LoggingLevel.ERROR, '[EXC] Exception ' + ex.getMessage( ) + ' stacktrace ' + ex.getStackTraceString( ) );
            return false;
            //NEXI-206, Wojciech Szuba, <wojciech.szuba@accenture.com>, 19/07/2019, STOP
        }
        return true;
    }

    /*******************************************************************************
    Purpose:  Method for first LogRequest's validation
    Parameters: List<OB_LogRequest__c> logRequestThatCanHaveApprovalProcess, String inMaintenanceType
    Returns: Set<Id>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba          29/07/2019      Created         NEXI-206
    ********************************************************************************/
    private static Set<Id> getFirstLogRequestValidation( List<OB_LogRequest__c> logRequestThatCanHaveApprovalProcess, String inMaintenanceType )
    {
        List<DeserializedLogRequestContent> deserializedLogRequestContents = new List<DeserializedLogRequestContent>( );
        for ( OB_LogRequest__c loopLogRequest : logRequestThatCanHaveApprovalProcess )
        {
            deserializedLogRequestContents.add( new DeserializedLogRequestContent( loopLogRequest ) );
        }
        if ( MAINTENANCE_TYPE_MCC.equalsIgnoreCase( inMaintenanceType ) )
        {
            return validationMCC( deserializedLogRequestContents );
        }
        else
        {
            return getNoValidation( deserializedLogRequestContents );
        }
    }

    /*******************************************************************************
    Purpose:  Method for creating the list of NEXI Products
    Parameters:
    Returns: List<Id>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba          29/07/2019      Created         NEXI-206
    ********************************************************************************/
    private static List<Id> getListSpecificOfNexiProductIds( )
    {
        List<Id> listOfProductIds = new List<Id>( );
        for ( NE__Product__c singleProduct :
        [
                SELECT Id
                FROM NE__Product__c
                WHERE OB_Acquirer__c = :OB_UtilityConstants.PRODUCT_ACQUIRER_NEXI
                LIMIT 50000
        ] )
        {
            listOfProductIds.add( singleProduct.Id );
        }
        return listOfProductIds;
    }

    /*******************************************************************************
    Purpose:  Method for creating the list of specific Assets
    Parameters: Set<Id> accountsIds, List<Id> listOfNexiProductsIds
    Returns: List<Id>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba          29/07/2019      Created         NEXI-206
    ********************************************************************************/
    private static List<Id> getListOfAssetsAccountsIds( Set<Id> accountsIds, List<Id> listOfNexiProductsIds )
    {
        List<Id> listOfAssetAccountsIds = new List<Id>( );
        for ( Asset singleAsset :
        [
                SELECT AccountId
                FROM Asset
                WHERE AccountId IN:accountsIds
                AND NE__ProdId__c IN:listOfNexiProductsIds
                AND NE__Status__c != :OB_UtilityConstants.ASSET_STATUS_DISCONNECTED
                AND NE__Root_Order_Item__c = null
                LIMIT 50000
        ] )
        {
            listOfAssetAccountsIds.add( singleAsset.AccountId );
        }
        return listOfAssetAccountsIds;
    }

    /*******************************************************************************
    Purpose:  Method execute validations for MCC
    Parameters: List<DeserializedLogRequestContent> inDContents
    Returns: Set<Id>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       05/06/2019      Created         NEXI-61
    ********************************************************************************/
    private static Set<Id> validationMCC( List<DeserializedLogRequestContent> inDContents )
    {
        Set<id> result = new Set<Id>( );
        for ( DeserializedLogRequestContent loopLRContent : inDContents )
        {
            OB_LogRequest__c logRequestToCheck = loopLRContent.logRequest;
            if
                            (
                            logRequestToCheck.OB_isBlackList__c ||
                                    logRequestToCheck.OB_isGambling__c ||
                                    logRequestToCheck.OB_PO118_eCommerce__c ||
                                    logRequestToCheck.OB_PEP__c
                            )
            {
                result.add( loopLRContent.logRequestId );
            }
        }
        return result;
    }

    /*******************************************************************************
    Purpose:  Method gather logRequests with no validatons
    Parameters: List<DeserializedLogRequestContent> inDContents
    Returns: Set<Id>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba          30/07/2019      Created         NEXI-206
    ********************************************************************************/
    private static Set<Id> getNoValidation( List<DeserializedLogRequestContent> inDContents )
    {
        Set<Id> result = new Set<Id>( );
        for ( DeserializedLogRequestContent loopLRContent : inDContents )
        {
            result.add( loopLRContent.logRequestId );
        }
        return result;
    }

    /*******************************************************************************
    Purpose:  Method update log request for which approval process start
    Parameters:  Set<Id> inLogRequestIds, String inMaintenanceType
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       05/06/2019      Created         NEXI-61
    ********************************************************************************/
    private static void updateLogRequestForApprovalProcess( Set<Id> inLogRequestIds, String inMaintenanceType )
    {
        List<OB_LogRequest__c> logRequestsToUpdate = new List<OB_LogRequest__c>( );
        if ( MAINTENANCE_TYPE_TITOLARI_EFFETTTIVI.equalsIgnoreCase( inMaintenanceType ) )
        {
            for ( Id lopLogRequestId : inLogRequestIds )
            {
                logRequestsToUpdate.add( prepareLogRequestUpdateForTE( lopLogRequestId ) );
            }
        }
        else if ( MAINTENANCE_TYPE_MCC.equalsIgnoreCase( inMaintenanceType ) )
        {
            for ( Id lopLogRequestId : inLogRequestIds )
            {
                logRequestsToUpdate.add( prepareLogRequestUpdateForMCC( lopLogRequestId ) );
            }
        }
        update logRequestsToUpdate;
    }

    /*******************************************************************************
    Purpose:  Method prepare log request object to update for Maintenance Titolari Effetivi
    Parameters:  Id inLogRequestId
    Returns: OB_LogRequest__c

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       05/06/2019      Created         NEXI-61
   ********************************************************************************/
    private static OB_LogRequest__c prepareLogRequestUpdateForTE( Id inLogRequestId )
    {
        return new OB_LogRequest__c
                (
                        Id = inLogRequestId,
                        OB_StartApprovalProcess__c = true,
                        OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_INAPPROVAZIONE,
                        OB_PEP__c = true
                );
    }

    /*******************************************************************************
    Purpose:  Method prepare log request object to update for Maintenance MCC
    Parameters:  Id inLogRequestId
    Returns: OB_LogRequest__c

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       05/06/2019      Created         NEXI-61
   ********************************************************************************/
    private static OB_LogRequest__c prepareLogRequestUpdateForMCC( Id inLogRequestId )
    {
        return new OB_LogRequest__c
                (
                        Id = inLogRequestId,
                        OB_StartApprovalProcess__c = true,
                        OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_INAPPROVAZIONE
                );
    }

    /*******************************************************************************
    Purpose:  Method start approval process for many log requests
    Parameters: Set<Id> inObjectIds, String inProcess
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       05/06/2019      Created         NEXI-61
    ********************************************************************************/
    private static void submitApprovalProcess( Set<Id> inObjectIds, String inProcess )
    {
        List<Approval.ProcessSubmitRequest> approvalProcessesToStart = new List<Approval.ProcessSubmitRequest>( );
        for ( Id loopId : inObjectIds )
        {
            Approval.ProcessSubmitRequest approvalProcessToStart = new Approval.ProcessSubmitRequest( );
            approvalProcessToStart.setComments( 'Submitting request for approval.' );
            approvalProcessToStart.setObjectId( loopId );
            approvalProcessToStart.setSubmitterId( UserInfo.getUserId( ) );
            approvalProcessToStart.setProcessDefinitionNameOrId( inProcess );
            approvalProcessToStart.setSkipEntryCriteria( false );
            approvalProcessesToStart.add( approvalProcessToStart );
        }
        List<Approval.ProcessResult> resultsOfApprovalProcessStart = Approval.process( approvalProcessesToStart, false );
        System.debug( LoggingLevel.INFO, 'submitApprovalProcess ends ' + resultsOfApprovalProcessStart );
    }

    /*******************************************************************************
    Purpose:  Class that contain deserialized content of log request
    Parameters: String inLogRequestId
    Returns: Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       04/06/2019      Created         NEXI-61
    1.1         Marta Stempien          10/06/2019      Modified        NEXI-97 Added logic for Log Requests related to Accounts
    1.2         Marta Stempien          14/06/2019      Modified        NEXI-87 Added logic for Log Requests related to Assets
    ********************************************************************************/
    public class DeserializedLogRequestContent
    {
        public List<Contact> newContactLists;
        public List<Contact> oldContactLists;
        public List<NE__Service_Point__c> newServicePointLists;
        public List<NE__Service_Point__c> oldServicePointLists;
        public List<Account> newAccountsList;
        public List<Account> oldAccountsList;
        public List<ExternalSourceMapping__c> newExternalSourceMappingsList;
        public List<ExternalSourceMapping__c> oldExternalSourceMappingsList;
        public List<Sobject> newOthers;
        public List<Sobject> oldOthers;
        public Id logRequestId;
        public OB_LogRequest__c logRequest;

        public DeserializedLogRequestContent( OB_LogRequest__c inLogRequest )
        {
            newContactLists = new List<Contact>( );
            oldContactLists = new List<Contact>( );
            newServicePointLists = new List<NE__Service_Point__c>( );
            oldServicePointLists = new List<NE__Service_Point__c>( );
            newAccountsList = new List<Account>( );
            oldAccountsList = new List<Account>( );
            newExternalSourceMappingsList = new List<ExternalSourceMapping__c>( );
            oldExternalSourceMappingsList = new List<ExternalSourceMapping__c>( );
            newOthers = new List<SObject>( );
            oldOthers = new List<SObject>( );
            logRequestId = inLogRequest.Id;
            logRequest = inLogRequest;
            Map<String, Object> newDataWrapper = ( Map<String, Object> ) JSON.deserializeUntyped( inLogRequest.OB_ReducedNewData__c );
            Map<String, Object> oldDataWrapper = ( Map<String, Object> ) JSON.deserializeUntyped( inLogRequest.OB_ReducedOldData__c );
            List<SObject> newDataSObjects = ( List<SObject> ) JSON.deserialize( JSON.serialize( newDataWrapper.get( 'obj' ) ), List<SObject>.class );
            List<SObject> oldDataSObjects = ( List<SObject> ) JSON.deserialize( JSON.serialize( oldDataWrapper.get( 'obj' ) ), List<SObject>.class );
            for ( Integer i = 0; i < newDataSObjects.size( ); i++ )
            {
                SObject newLoopSObject = newDataSObjects.get( i );
                SObject oldLoopSObject = oldDataSObjects.get( i );
                if ( newLoopSObject instanceof Contact && oldLoopSObject instanceof Contact )
                {
                    newContactLists.add( ( Contact ) newLoopSObject );
                    oldContactLists.add( ( Contact ) oldLoopSObject );
                }
                else if ( newLoopSObject instanceof NE__Service_Point__c && oldLoopSObject instanceof NE__Service_Point__c )
                {
                    newServicePointLists.add( ( NE__Service_Point__c ) newLoopSObject );
                    oldServicePointLists.add( ( NE__Service_Point__c ) oldLoopSObject );
                }
                else if ( newLoopSObject instanceof Account && oldLoopSObject instanceof Account )
                {
                    newAccountsList.add( ( Account ) newLoopSObject );
                    oldAccountsList.add( ( Account ) oldLoopSObject );
                }
                else if ( newLoopSObject instanceof ExternalSourceMapping__c && oldLoopSObject instanceof ExternalSourceMapping__c )
                {
                    newExternalSourceMappingsList.add( ( ExternalSourceMapping__c ) newLoopSObject );
                    oldExternalSourceMappingsList.add( ( ExternalSourceMapping__c ) oldLoopSObject );
                }
                else
                {
                    newOthers.add( newLoopSObject );
                    oldOthers.add( oldLoopSObject );
                }
            }
        }
    }

    /*******************************************************************************
    Purpose:  Class that is wrapper for sorted data for dml actions
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       06/06/2019      Created         NEXI-64
    ********************************************************************************/
    public class LogRequestResolutionWrapper
    {
        public List<SObject> objectsToUpdate;
        public List<SObject> objectsToInsert;
        public List<SObject> objectsToDelete;
        public logRequestResolutionWrapper( )
        {
            objectsToUpdate = new List<SObject>( );
            objectsToInsert = new List<SObject>( );
            objectsToDelete = new List<SObject>( );
        }
    }

    /*******************************************************************************
    Purpose:  Method prepare data ( sort it and put into wrapper) for proper dml action
    Parameters: OB_LogRequest__c inLogRequest
    Returns: LogRequestResolutionWrapper

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       06/06/2019      Created         NEXI-64
    ********************************************************************************/
    public static LogRequestResolutionWrapper prepareDataForResolution( OB_LogRequest__c inLogRequest )
    {
        LogRequestResolutionWrapper result = new LogRequestResolutionWrapper( );
        if ( inLogRequest == null )
        {
            return result;
        }
        DeserializedLogRequestContent dLogRequestContent;

        try
        {
            dLogRequestContent = new DeserializedLogRequestContent( inLogRequest );
        } catch ( Exception ex )
        {
            System.debug( LoggingLevel.ERROR, '[EXC] Exception ' + ex.getMessage( ) + ' stacktrace ' + ex.getStackTraceString( ) );
            return result;
        }
        for ( Integer i = 0; i < dLogRequestContent.newContactLists.size( ); i++ )
        {
            // NEXI-127 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 26/06/2019 START changed to String.isBlank ( from != )
            if ( String.isBlank( dLogRequestContent.newContactLists.get( i ).Id ) )
            {
                if ( !String.isBlank( dLogRequestContent.oldContactLists.get( i ).Id ) )
                // NEXI-127 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 26/06/2019 STOP
                {
                    result.objectsToDelete.add( dLogRequestContent.oldContactLists.get( i ) );
                }
                else
                {
                    result.objectsToInsert.add( dLogRequestContent.newContactLists.get( i ) );
                }
            }
            else
            {
                result.objectsToUpdate.add( dLogRequestContent.newContactLists.get( i ) );
            }
        }
        return result;
    }

    /*******************************************************************************
    Purpose:  Method prepare data ( sort it and put into wrapper) for proper dml action for Sae/Ateco
    Parameters: OB_LogRequest__c inLogRequest
    Returns: LogRequestResolutionWrapper

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       10/06/2019      Created         NEXI-97
    1.1         Marta Stempien          14/06/2019      Modified        NEXI-94
    1.2         Marta Stempien          17/06/2019      Modified        NEXI-87
    ********************************************************************************/
    public static LogRequestResolutionWrapper prepareDataForResolutionUpdate( OB_LogRequest__c inLogRequest, Boolean isSaeAteco )
    {
        LogRequestResolutionWrapper result = new LogRequestResolutionWrapper( );
        if ( inLogRequest == null )
        {
            return result;
        }
        DeserializedLogRequestContent dLogRequestContent;

        try
        {
            dLogRequestContent = new DeserializedLogRequestContent( inLogRequest );
        } catch ( Exception ex )
        {
            System.debug( LoggingLevel.ERROR, '[EXC] Exception ' + ex.getMessage( ) + ' stacktrace ' + ex.getStackTraceString( ) );
            return result;
        }
        if ( isSaeAteco )
        {
            for ( Integer i = 0; i < dLogRequestContent.newAccountsList.size( ); i++ )
            {
                if ( ( dLogRequestContent.newAccountsList.get( i ).Id != null ) )
                {
                    result.objectsToUpdate.add( dLogRequestContent.newAccountsList.get( i ) );
                }
            }
        }
        // NEXI-87 Marta Stempien <marta.stempien@accenture.com> 17/06/2019 - Start
        else
        {
            for ( Integer i = 0; i < dLogRequestContent.newExternalSourceMappingsList.size( ); i++ )
            {
                if ( ( dLogRequestContent.newExternalSourceMappingsList.get( i ).Id != null ) )
                {
                    result.objectsToUpdate.add( dLogRequestContent.newExternalSourceMappingsList.get( i ) );
                }
            }
        }
        // NEXI-87 Marta Stempien <marta.stempien@accenture.com> 17/06/2019 - Stop
        return result;
    }

    /*******************************************************************************
    Purpose: Prepare map required for update Assets related to service points
    Parameters: OB_LogRequest__c inLogRequest
    Returns: Map <Id, ExternalSourceMapping__c>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien          17/06/2019      Created         NEXI-87
    ********************************************************************************/
    public static Map <Id, ExternalSourceMapping__c> prepareDataForAssetsUpdate( OB_LogRequest__c inLogRequest )
    {
        Map <Id, ExternalSourceMapping__c> externalSourceMappingsByServicePointsIds = new Map<Id, ExternalSourceMapping__c>( );
        if ( inLogRequest == null )
        {
            return externalSourceMappingsByServicePointsIds;
        }
        DeserializedLogRequestContent dLogRequestContent;

        try
        {
            dLogRequestContent = new DeserializedLogRequestContent( inLogRequest );
        } catch ( Exception ex )
        {
            System.debug( LoggingLevel.ERROR, '[EXC] Exception ' + ex.getMessage( ) + ' stacktrace ' + ex.getStackTraceString( ) );
            return externalSourceMappingsByServicePointsIds;
        }

        for ( Integer i = 0; i < dLogRequestContent.newExternalSourceMappingsList.size( ); i++ )
        {
            if ( ( dLogRequestContent.newExternalSourceMappingsList.get( i ).Id != null ) && inLogRequest.OB_ServicePointId__c != null )
            {
                externalSourceMappingsByServicePointsIds.put( inLogRequest.OB_ServicePointId__c, dLogRequestContent.newExternalSourceMappingsList.get( i ) );
            }
        }
        return externalSourceMappingsByServicePointsIds;
    }

    /*******************************************************************************
    Purpose:  Method prepare map of documents used for SAE/ATECO document upload
    Parameters: -
    Returns: Map<String, List<OB_Product_Document__c>>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       10/06/2019      Created         NEXI-97
    1.1         Adrian Dlugolecki       19/06/2019      Parametrized    NEXI-60
    ********************************************************************************/
    public static Map<String, List<OB_Product_Document__c>> prepareDocumentMapByNames( List<String> inNames, List<String> inDocumentTypology )
    {
        System.debug( LoggingLevel.INFO, 'OB_Util006_MaintenanceAnagrafica.prepareDocumentMapByNames start inNames: ' + inNames + '    inDocumentTypology : ' + inDocumentTypology );
        Map<String, List<OB_Product_Document__c>> productDocumentsByName = new Map<String, List<OB_Product_Document__c>>( );
        for ( List<OB_Product_Document__c> productDocuments :
        [
                SELECT Name,
                        OB_Description__c,
                        OB_Document_Typology__c,
                        OB_Multiple_upload__c,
                        OB_Client_Type__c
                FROM OB_Product_Document__c
                WHERE OB_Request_Typology__c = :REQUEST_TYPOLOGY_MAINTENANCE // NEXI-94 Marta Stempien <marta.stempien@accenture.com> 17/06/2019 - Fix for NEXI-97
                AND Name IN :inNames
                AND OB_Document_Typology__c IN :inDocumentTypology
                Limit 50000
        ] )
        {
            System.debug( LoggingLevel.INFO, 'OB_Util006_MaintenanceAnagrafica.prepareDocumentMapByNames For productDocuments : ' + productDocuments );
            for ( OB_Product_Document__c productDocument : productDocuments )
            {
                if ( productDocumentsByName.get( productDocument.Name ) != null )
                {
                    productDocumentsByName.get( productDocument.Name ).add( productDocument );
                }
                else
                {
                    productDocumentsByName.put( productDocument.Name, new List<OB_Product_Document__c> {productDocument} );
                }
            }
        }
        System.debug( LoggingLevel.INFO, 'OB_Util006_MaintenanceAnagrafica.prepareDocumentMapByNames end ' + productDocumentsByName );
        return productDocumentsByName;
    }

    /*******************************************************************************
    Purpose:  Method add proper document for upload of SAE ATECO if needed
    Parameters: String inDocumentName, Map<String, List<OB_Product_Document__c>> inSource, Map<String, String> inOutDocumentsMap, List<String> inClientTypes
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       10/06/2019      Created         NEXI-97
    ********************************************************************************/
    public static void addDocument( String inDocumentName, Map<String, List<OB_Product_Document__c>> inSource, Map<String, String> inOutDocumentsMap, List<String> inClientTypes )
    {
        System.debug( LoggingLevel.INFO, 'OB_Util006_MaintenanceAnagrafica.addDocument start inDocumentName ' + inDocumentName + ' inOutDocumentsMap ' + inOutDocumentsMap );
        if ( inDocumentName == null || inSource == null || inOutDocumentsMap == null || inOutDocumentsMap == null || inOutDocumentsMap.get( inDocumentName ) != null || inSource.get( inDocumentName ) == null )
        {
            return;
        }
        Boolean isDocumentFound = false;
        for ( OB_Product_Document__c loopProductDocument : inSource.get( inDocumentName ) )
        {
            if ( inClientTypes.contains( loopProductDocument.OB_Client_Type__c ) )
            {
                inOutDocumentsMap.put( loopProductDocument.OB_Description__c, loopProductDocument.OB_Document_Typology__c + ':' + loopProductDocument.OB_Multiple_upload__c );
                isDocumentFound = true;
                break;
            }
        }
        if ( !isDocumentFound )
        {
            OB_Product_Document__c firstProduct = inSource.get( inDocumentName ).get( 0 );
            inOutDocumentsMap.put( firstProduct.OB_Description__c, firstProduct.OB_Document_Typology__c + ':' + firstProduct.OB_Multiple_upload__c );
        }
        System.debug( LoggingLevel.INFO, 'OB_Util006_MaintenanceAnagrafica.addDocument end inOutDocumentsMap ' + inOutDocumentsMap );
    }

    /*******************************************************************************
    Purpose: Method compares old Contact and Contact after modification - return true if they're different
    Parameters: Contact oldContact, Contact newContact
    Returns: Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/06/2019      Created         NEXI-60
    1.1         Joanna Mielczarek       26/06/2019      Modified        NEXI-127 changed conditions in if statement
    *******************************************************************************/
    public static Boolean checkContactIsAfterModification( Contact oldContact, Contact newContact )
    {
        try
        {
            Map<String, Object> oldMap = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( oldContact ) );
            Map<String, Object> newMap = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( newContact ) );
            for ( String newMapKey : newMap.keySet( ) )
            {
                if ( !oldMap.containsKey( newMapKey ) ||
                        ( newMap.get( newMapKey ) == null && oldMap.get( newMapKey ) != null ) ||
                        ( newMap.get( newMapKey ) != null && oldMap.get( newMapKey ) != null && !newMap.get( newMapKey ).equals( oldMap.get( newMapKey ) ) )
                        )
                {
                    return true;
                }
            }
        } catch ( Exception ex )
        {
            System.debug( LoggingLevel.ERROR, 'Exception during serializing/deserializing operation : ' + ex + ' stackTrace ' + ex.getStackTraceString( ) );
        }
        return false;
    }

    /*******************************************************************************
    Purpose:  Class that is wrapper for checkboxes fields on OB_LogRequest: OB_isGambling__c, OB_PO118_eCommerce__c
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       18/06/2019         Created          NEXI-87
    ********************************************************************************/
    public class CheckboxesGablingAndPO118Wrapper
    {
        public Boolean isGambling;
        public Boolean isPO118;
        public CheckboxesGablingAndPO118Wrapper( )
        {
            this.isGambling = false;
            this.isPO118 = false;
        }
    }

    /*******************************************************************************
    Purpose: Method checks if the MCC is Gambling or PO118
    Parameters: String MCC
    Returns: CheckboxesGablingAndPO118Wrapper

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien          24/06/2019      Created         NEXI-83
    ********************************************************************************/
    public static CheckboxesGablingAndPO118Wrapper checkForGamblingAndPO118( String MCC )
    {
        CheckboxesGablingAndPO118Wrapper checkboxesWrapper = new CheckboxesGablingAndPO118Wrapper( );
        List<NE__Lov__c> MCCTypes = [ SELECT NE__Value1__c FROM NE__LOV__c WHERE NE__Value2__c = :MCC AND NE__Type__c = 'MCC' LIMIT 1 ];
        if ( !MCCTypes.isEmpty( ) )
        {
            if ( MCC_TYPE_GAMBLING.equalsIgnoreCase( MCCTypes.get( 0 ).NE__Value1__c ) )
            {
                checkboxesWrapper.isGambling = true;
            }
            else if ( MCC_TYPE_PO118.equalsIgnoreCase( MCCTypes.get( 0 ).NE__Value1__c ) )
            {
                checkboxesWrapper.isPO118 = true;
            }
        }
        return checkboxesWrapper;
    }
    /*******************************************************************************
    Purpose:  Method prepare a new or modyfy Contact Referente
    Parameters: List<SObject> objectsToDelete
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Zuzanna Urban       19/06/2019      Created         NEXI-109
    ********************************************************************************/
    public static void prepareContact( OB_LogRequest__c inLogRequest )
    {
        Map<String, Object> mapReducedNewData = ( Map<String, Object> ) JSON.deserializeUntyped( inLogRequest.OB_ReducedNewData__c );
        List<Object> newlistOfObjs = ( List<Object> ) JSON.deserializeUntyped( JSON.serialize( mapReducedNewData.get( 'obj' ) ) );
        for ( Object obj : newlistOfObjs )
        {
            String contactChangeJSON = JSON.serialize( obj );
            Contact oneContact = ( Contact ) JSON.deserialize( contactChangeJSON, Contact.class );
            if ( String.isBlank( oneContact.Id ) && String.isNotBlank( oneContact.FirstName ) && String.isNotBlank( oneContact.LastName )
                    && String.isNotBlank( oneContact.Email ) && String.isNotBlank( oneContact.MobilePhone ) && String.isNotBlank( oneContact.RecordTypeId ) )
            {
                oneContact.OB_Service_Point__c = inLogRequest.OB_ServicePointId__c;
                insert oneContact;
            }
            else if ( String.isNotBlank( oneContact.Id ) && ( String.isNotBlank( oneContact.FirstName ) || String.isNotBlank( oneContact.LastName )
                    || String.isNotBlank( oneContact.Email ) || String.isNotBlank( oneContact.MobilePhone ) ) )
            {
                update oneContact;
            }
        }
    }

    /*******************************************************************************
    Purpose:  Method checks if Sae-Ateco dependencies are valid
    Parameters: String saeName, String atecoName
    Returns: Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       25/07/2019        Created          NEXI-120
    ********************************************************************************/
    public static Boolean validateSaeAtecoDependency( String saeName, String atecoName )
    {
        List <NE__Lov__c> saeLovs = [ SELECT NE__Value2__c FROM NE__Lov__c WHERE NE__Type__c = :TYPE_OF_LOV_SAE AND Name = :saeName ];
        List <NE__Lov__c> atecoLovs = [ SELECT NE__Value2__c FROM NE__Lov__c WHERE NE__Type__c = :TYPE_OF_LOV_ATECO AND Name = :atecoName ];
        if ( !saeLovs.isEmpty( ) && 'S'.equalsIgnoreCase( saeLovs.get( 0 ).NE__Value2__c ) && !atecoLovs.isEmpty( ) && 'S'.equalsIgnoreCase( atecoLovs.get( 0 ).NE__Value2__c ) )
        {
            return true;
        }
        else if ( atecoLovs.isEmpty( ) && ( !saeLovs.isEmpty( ) && !'S'.equalsIgnoreCase( saeLovs.get( 0 ).NE__Value2__c ) ) )
        {
            return true;
        }
        else return false;
    }

    /*******************************************************************************
    Purpose:  Method deserialize log request and execute resolution for settlement procedure log requests
    Parameters: List<OB_LogRequest__c> inLogRequest
    Returns: -
    Throwable: Method can throw exception use it only inside try catch

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       10/07/2019      Created         NEXI-185
    ********************************************************************************/
    public static void resolveSettlementProcedures( List<OB_LogRequest__c> inLogRequest )
    {
        System.debug( LoggingLevel.FINE, 'OB_Util006_MaintenanceAnagrafica.resolveSettlementProcedures start ' + inLogRequest );
        List<ExternalSourceMapping__c> inExternalSourceMappingsLordo = new List<ExternalSourceMapping__c>( );
        List<ExternalSourceMapping__c> inExternalSourceMappingsNetto = new List<ExternalSourceMapping__c>( );
        Set<Id> accountsIds = new Set<Id>( );//NEXI-356 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 02/10/2019 gather related account ids
        for ( OB_LogRequest__c logRequest : inLogRequest )
        {
            DeserializedLogRequestContent dLogRequestContent = new DeserializedLogRequestContent( logRequest );
            for ( ExternalSourceMapping__c loopExternalSourceMapping : dLogRequestContent.newExternalSourceMappingsList )
            {
                if ( SETTLEMENT_PROCEDURE_LORDO.equalsIgnoreCase( loopExternalSourceMapping.OB_InternationalSettlementMethod__c ) )
                {
                    inExternalSourceMappingsLordo.add( loopExternalSourceMapping );
                    accountsIds.add( logRequest.OB_AccountId__c );//NEXI-356 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 02/10/2019
                }
                else if ( SETTLEMENT_PROCEDURE_NETTO.equalsIgnoreCase( loopExternalSourceMapping.OB_InternationalSettlementMethod__c ) )
                {
                    inExternalSourceMappingsNetto.add( loopExternalSourceMapping );
                    accountsIds.add( logRequest.OB_AccountId__c );//NEXI-356 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 02/10/2019
                }
            }
        }
        //NEXI-356 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 02/10/2019 Start
        System.debug( LoggingLevel.FINE, 'OB_Util006_MaintenanceAnagrafica.resolveSettlementProcedures accountsIds ' + accountsIds );
        System.debug( LoggingLevel.FINE, 'OB_Util006_MaintenanceAnagrafica.resolveSettlementProcedures inExternalSourceMappingsLordo ' + inExternalSourceMappingsLordo );
        System.debug( LoggingLevel.FINE, 'OB_Util006_MaintenanceAnagrafica.resolveSettlementProcedures inExternalSourceMappingsNetto ' + inExternalSourceMappingsNetto );
        //Start antonio.vatrano 16/10/2019 OB_InternationalSettlementMethod__c
        if(!inExternalSourceMappingsLordo.isEmpty()){
            resolveSettlementProcedure( retrieveInfosESM(inExternalSourceMappingsLordo), SETTLEMENT_PROCEDURE_LORDO, accountsIds );
        }
        if(!inExternalSourceMappingsNetto.isEmpty()){
            resolveSettlementProcedure( retrieveInfosESM(inExternalSourceMappingsNetto), SETTLEMENT_PROCEDURE_NETTO, accountsIds );
        }
        //END antonio.vatrano 16/10/2019 OB_InternationalSettlementMethod__c
        //NEXI-356 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 02/10/2019 Stop
    }
    //Start antonio.vatrano 16/10/2019 OB_InternationalSettlementMethod__c
    private static List<ExternalSourceMapping__c> retrieveInfosESM (List<ExternalSourceMapping__c> listESM){
        List<String> ESM_IDS= new List<String>();
        for(ExternalSourceMapping__c e : listESM ){
            ESM_IDS.add(e.Id);
        }
        if(!ESM_IDS.isEmpty()){
            List<ExternalSourceMapping__c> toReturn =[SELECT Id,OB_ConventionCode__c, OB_InternationalSettlementMethod__c,
                                                        OB_ServicePointCodeShopCode__c,OB_Service_Point_ID__c
                                                        FROM ExternalSourceMapping__c
                                                        WHERE id in :ESM_IDS];
            return toReturn;
        }else{return new List<ExternalSourceMapping__c>();}
    }
    //End antonio.vatrano 16/10/2019 OB_InternationalSettlementMethod__c

    /*******************************************************************************
    Purpose:  Method update ESM, asset and orders according to value saved in log request
    Parameters: List<ExternalSourceMapping__c> inExternalSourceMappings, String inSettlementProcedure,  Set<Id> inAccountIds
    Returns: -
    Throwable: Method can throw exception use it only inside try catch

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       10/07/2019      Created         NEXI-185
    1.1         Adrian Dlugolecki       02/10/2019      Created         NEXI-356 add inAccountIds
    ********************************************************************************/
    private static void resolveSettlementProcedure( List<ExternalSourceMapping__c> inExternalSourceMappings, String inSettlementProcedure, Set<Id> inAccountIds )
    {
        System.debug( LoggingLevel.FINE, 'OB_Util006_MaintenanceAnagrafica.resolveSettlementProcedure start ' + inExternalSourceMappings + ' inSettlementProcedure ' + inSettlementProcedure + ' inAccountIds ' + inAccountIds );
        //// ESM Update Part////
        Set<String> servicePointShopCodes = resolveSettlementProcedureForESM( inExternalSourceMappings, inSettlementProcedure );

        //// Asset Update Part////
        Set<String> relatedOrdersIds = resolveSettlementProcedureForAsset( servicePointShopCodes, inSettlementProcedure, inAccountIds );//NEXI-356 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 02/10/2019

        //// Order Update Part////
        List<NE__Order__c> ordersToUpdate = [ SELECT Id FROM NE__Order__c WHERE id IN:relatedOrdersIds LIMIT 10000 ];
        System.debug( LoggingLevel.FINE, 'OB_Util006_MaintenanceAnagrafica.resolveSettlementProcedure ordersToUpdate ' + ordersToUpdate );
        if ( !ordersToUpdate.isEmpty( ) )
        {
            for ( NE__Order__c loopOrder : ordersToUpdate )
            {
                loopOrder.OB_InternationalSettlementMethod__c = inSettlementProcedure;
            }
            update ordersToUpdate;
        }
        System.debug( LoggingLevel.FINE, 'OB_Util006_MaintenanceAnagrafica.resolveSettlementProcedure stop' );
    }

    /*******************************************************************************
    Purpose:  Method select external source mappings and update OB_InternationalSettlementMethod__c field
    Parameters: List<ExternalSourceMapping__c> inExternalSourceMappings, String inSettlementProcedure
    Returns: Set<String> Service Point Shop Codes used in next step of this log requests resolution (for asset select)
    Throwable: Method can throw exception use it only inside try catch

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       10/07/2019      Created         NEXI-185
    1.1         Marta Stempien          16/08/2019      Modified        NEXI-261 When input ESM have OB_ServicePointCodeShopCode__c null, input ESM should also be updated
    ********************************************************************************/
    private static Set<String> resolveSettlementProcedureForESM( List<ExternalSourceMapping__c> inExternalSourceMappings, String inSettlementProcedure )
    {
        System.debug( LoggingLevel.FINE, 'OB_Util006_MaintenanceAnagrafica.resolveSettlementProcedureForESM start ' + inExternalSourceMappings + ' inSettlementProcedure ' + inSettlementProcedure );
        Set<String> servicePointShopCodes = new Set<String>( );
        Set<String> conventionCodes = new Set<String>( ); //antonio.vatrano 16/10/2019 r1f3-137
        Set<String> servicePointIds = new Set<String>( );
        Map<Id, ExternalSourceMapping__c> externalSourceMappingsByIds = new Map<Id, ExternalSourceMapping__c>( );
        for ( ExternalSourceMapping__c loopExternalSourceMapping : inExternalSourceMappings )
        {
            //Start antonio.vatrano 16/10/2019 OB_InternationalSettlementMethod__c
            conventionCodes.add( loopExternalSourceMapping.OB_ConventionCode__c ); //antonio.vatrano 16/10/2019 r1f3-137
            servicePointShopCodes.add( loopExternalSourceMapping.OB_ServicePointCodeShopCode__c ); 
            servicePointIds.add( loopExternalSourceMapping.OB_Service_Point_ID__c );//antonio.vatrano 17/10/2019 r1f3-137
            //End antonio.vatrano 16/10/2019 OB_InternationalSettlementMethod__c
            loopExternalSourceMapping.OB_InternationalSettlementMethod__c = inSettlementProcedure;
            externalSourceMappingsByIds.put( loopExternalSourceMapping.Id, loopExternalSourceMapping );
        }
        List<ExternalSourceMapping__c> externalSourceMappingsToUpdate =
        [
                SELECT Id
                FROM ExternalSourceMapping__c
                WHERE OB_Service_Point_ID__c in :servicePointIds
                AND ( OB_Source__c = :OB_UtilityConstants.EQUENS OR OB_Source__c = :OB_UtilityConstants.SIA)
                AND OB_ServicePointCodeShopCode__c IN:conventionCodes //antonio.vatrano 16/10/2019 r1f3-137
                LIMIT 10000
        ];
        System.debug( LoggingLevel.FINE, 'OB_Util006_MaintenanceAnagrafica.resolveSettlementProcedureForESM externalSourceMappingsToUpdate ' + externalSourceMappingsToUpdate );
        if ( !externalSourceMappingsToUpdate.isEmpty( ) )
        {
            for ( ExternalSourceMapping__c loopExternalSourceMapping : externalSourceMappingsToUpdate )
            {
                loopExternalSourceMapping.OB_InternationalSettlementMethod__c = inSettlementProcedure;
                externalSourceMappingsByIds.put( loopExternalSourceMapping.Id, loopExternalSourceMapping );
            }
        }
        update externalSourceMappingsByIds.values( );
        System.debug( LoggingLevel.FINE, 'OB_Util006_MaintenanceAnagrafica.resolveSettlementProcedureForESM stop ' + servicePointShopCodes );
        return servicePointShopCodes;
    }


    /*******************************************************************************
    Purpose:  Method select related assets and according to selected settlement procedure and actual settlement type
                this method update OB_SettlementMethod__c field with proper value
    Parameters: Set<String> inServicePointShopCodes, String inSettlementProcedure, Set<Id> inAccountIds
    Returns: Set<String> ids of order used in next step of this log requests resolution
    Throwable: Method can throw exception use it only inside try catch

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       10/07/2019      Created         NEXI-185
    1.1         Adrian Dlugolecki       02/10/2019      Created         NEXI-356 add inAccountIds (used in where) and add debugs
    ********************************************************************************/
    private static Set<String> resolveSettlementProcedureForAsset( Set<String> inServicePointShopCodes, String inSettlementProcedure, Set<Id> inAccountIds )
    {
        System.debug( LoggingLevel.FINE, 'OB_Util006_MaintenanceAnagrafica.resolveSettlementProcedureForAsset start inServicePointShopCodes ' + inServicePointShopCodes + ' inSettlementProcedure ' + inSettlementProcedure + ' inAccountIds ' + inAccountIds );
        Set<String> relatedOrdersIds = new Set<String>( );
        List<Asset> assetsToUpdate =
        [
                SELECT OB_SettlementType__c,
                        NE__Order_Config__c
                FROM Asset
                WHERE AccountId IN:inAccountIds
                AND NE__Status__c != 'Disconnected'
                AND OB_ServicePointCode__c IN:inServicePointShopCodes
                LIMIT 10000
        ];
        System.debug( LoggingLevel.FINE, 'OB_Util006_MaintenanceAnagrafica.resolveSettlementProcedureForAsset assets  ' + assetsToUpdate );
        if ( assetsToUpdate.isEmpty( ) )
        {
            return relatedOrdersIds;
        }

        String assetSettlementMethodValueForPrepagato = '', assetSettlementMethodValueForPostpagato = '';
        if ( SETTLEMENT_PROCEDURE_LORDO.equalsIgnoreCase( inSettlementProcedure ) )
        {
            assetSettlementMethodValueForPrepagato = SETTLEMENT_PROCEDURE_ASSET_BANCA_LORDO;
            assetSettlementMethodValueForPostpagato = SETTLEMENT_PROCEDURE_ASSET_NEXI_LORDO;
        }
        else if ( SETTLEMENT_PROCEDURE_NETTO.equalsIgnoreCase( inSettlementProcedure ) )
        {
            assetSettlementMethodValueForPrepagato = SETTLEMENT_PROCEDURE_ASSET_BANCA_NETTO;
            assetSettlementMethodValueForPostpagato = SETTLEMENT_PROCEDURE_ASSET_NEXI_NETTO;
        }

        for ( Asset loopAsset : assetsToUpdate )
        {
            if ( OB_UtilityConstants.PREPAGATO.equalsIgnoreCase( loopAsset.OB_SettlementType__c ) )
            {
                loopAsset.OB_SettlementMethod__c = assetSettlementMethodValueForPrepagato;
                relatedOrdersIds.add( loopAsset.NE__Order_Config__c );

            }
            else if ( OB_UtilityConstants.POSTPAGATO.equalsIgnoreCase( loopAsset.OB_SettlementType__c ) )
            {
                loopAsset.OB_SettlementMethod__c = assetSettlementMethodValueForPostpagato;
                relatedOrdersIds.add( loopAsset.NE__Order_Config__c );
            }
        }
        update assetsToUpdate;
        relatedOrdersIds.remove( null );
        System.debug( LoggingLevel.FINE, 'OB_Util006_MaintenanceAnagrafica.resolveSettlementProcedureForAsset stop ' + relatedOrdersIds );
        return relatedOrdersIds;
    }

    /*******************************************************************************
    Purpose:  Method deserialize log request and execute resolution of update ExternalSurceMappings
    Parameters: OB_LogRequest__c inLogRequest
    Returns: -
    Throwable: Method can throw exception use it only inside try catch

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       16/07/2019        Created          NEXI-181
    ********************************************************************************/
    public static void resolveExternalSourceMappingChangeReportTypeLogRequest( List <OB_LogRequest__c> inLogRequests )
    {
        System.debug( LoggingLevel.INFO, 'OB_Util006_MaintenanceAnagrafica.resolveExternalSourceMappingChangeRecordTypeLogRequest inLogRequest ' + inLogRequests );
        List <ExternalSourceMapping__c> externalSourceMappingsToUpdate = new List<ExternalSourceMapping__c>( );
        Map<Id, ExternalSourceMapping__c> externalSourceMappingsByIds = new Map<Id, ExternalSourceMapping__c>( );
        for ( OB_LogRequest__c logRequest : inLogRequests )
        {
            DeserializedLogRequestContent deserializedLogRequestContent = new DeserializedLogRequestContent( logRequest );
            for ( ExternalSourceMapping__c externalSourceMapping : deserializedLogRequestContent.newExternalSourceMappingsList )
            {
                externalSourceMappingsByIds.put( externalSourceMapping.id, externalSourceMapping );
            }
        }
        externalSourceMappingsToUpdate.addAll( externalSourceMappingsByIds.values( ) );
        update externalSourceMappingsToUpdate;
    }


}