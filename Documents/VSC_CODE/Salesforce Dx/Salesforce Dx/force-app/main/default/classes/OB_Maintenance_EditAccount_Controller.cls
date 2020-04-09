public with sharing class OB_Maintenance_EditAccount_Controller
{
    public class SchemaWrapper
    {
        @auraEnabled
        public map<string, map<string, string>> mapSObjectfields { get; set; }

        public SchemaWrapper( )
        {
            this.mapSObjectfields = new map<string, map<string, string>>( );
        }
    }

    public class EditAccountSimple
    {
        Account account;
        Contact contact;
        List<ExternalSourceMapping__c> externalSourceMappings; //NEXI-179 Adrian Dlugolecki <adrian.dlugolecki@accenture.com> 15/07/2019

        public EditAccountSimple( )
        {
            this.account = new Account( );
            this.contact = new Contact( );
            this.externalSourceMappings = new List<ExternalSourceMapping__c>( ); //NEXI-179 Adrian Dlugolecki <adrian.dlugolecki@accenture.com> 15/07/2019
        }
    }

    public class EditExecutorSimple
    {
        Contact executor;

        public EditExecutorSimple( )
        {
            this.executor = new Contact( );
        }
    }

    public class EditAccountSimpleContainer
    {
        EditAccountSimple oldData;
        EditAccountSimple newData;

        public EditAccountSimpleContainer( )
        {
            this.oldData = new EditAccountSimple( );
            this.newData = new EditAccountSimple( );
        }
    }
    // NEXI-179 Marta Stempien <marta.stempien@accenture.com> 30/07/2019 Added new Exception class
    public class LogRequestExistsException extends Exception
    {
    }

    /*******************************************************************************
    Purpose:  Class wrap date for retrieveExternalSourceMapping and picklist value
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Zuzanna Urban          15/07/2019      Created          NEXI-186
    ********************************************************************************/
    public class InitialRendicontazoneWrapper
    {
        @auraEnabled
        public String[] picklistValues { get; set; }
        @auraEnabled
        public List<ExternalSourceMapping__c> listESM { get; set; }

        public InitialRendicontazoneWrapper( )
        {
            this.picklistValues = new String[] {};
            this.listESM = new List<ExternalSourceMapping__c>( );
        }
    }

    /*******************************************************************************
    Purpose:  Method calls saveRequests method for each change
    Parameters: List<String> oldData, List<String> newData, String objectDataMap
    Returns: List<Map<String, Object>>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien          03/07/2019      Created         NEXI-144
    ********************************************************************************/
    @auraEnabled
    public static List<Map<String, Object>> getRequests( List<String> oldData, List<String> newData, String objectDataMap )
    {

        // NEXI-120 Marta Stempien <marta.stempien@accenture.com> 25/07/2019 Start
        List<Map<String, Object>> requestsData = new List<Map<String, Object>>( );
        Map<String, Object> objectDataMapSerialized = new Map<String, Object>( );
        if ( oldData.isEmpty( ) || newData.isEmpty( ) || String.isEmpty( objectDataMap ) )
        {
            System.debug( LoggingLevel.ERROR, 'Empty data : oldData: ' + oldData + ',newData: ' + newData + 'objectDataMap: ' + objectDataMap );
            objectDataMapSerialized.put( 'message', Label.OB_ServerLogicFailed );
            requestsData.add( objectDataMapSerialized );
            return requestsData;
        }
        String saeName;
        String atecoName;
        // NEXI-298 Marta Stempien <marta.stempien@accenture.com 09/09/2019 Start
        EditAccountSimple newAccount = new EditAccountSimple( );
        try
        {
            objectDataMapSerialized = ( Map<String, Object> ) JSON.deserializeUntyped( objectDataMap );
            newAccount = ( EditAccountSimple ) JSON.deserialize( newData.get( newData.size( ) - 1 ), EditAccountSimple.class );
            saeName = newAccount.account.OB_SAE_Code__c;
            atecoName = newAccount.account.OB_ATECO__c;
        } catch ( Exception eException )
        {
            System.debug( LoggingLevel.ERROR, 'Exception during serializing/deserializing operation : ' + eException + ' stackTrace ' + eException.getStackTraceString( ) );
            objectDataMapSerialized.put( 'message', Label.OB_ServerLogicFailed );
            requestsData.add( objectDataMapSerialized );
            return requestsData;
        }

        if ( newAccount.account != null && !OB_Util006_MaintenanceAnagrafica.validateSaeAtecoDependency( saeName, atecoName ) )
        {
            // NEXI-298 Marta Stempien <marta.stempien@accenture.com 09/09/2019 Stop
            objectDataMapSerialized.put( 'message', Label.OB_ErrorSaeAtecoFieldsNotValid );
            requestsData.add( objectDataMapSerialized );
            return requestsData;
        }
        Savepoint sSavePoint = Database.setSavepoint( );
        //NEXI-120 Marta Stempien <marta.stempien@accenture.com> 25/07/2019 Stop
        //NEXI-179 Marta Stempien <marta.stempien@accenture.com> 30/07/2019 Start
        try
        {
            //START - elena.preteni 10/09/2019 check log request
            checkExistance( oldData, newData );
            //END - elena.preteni 10/09/2019 check log request
            if ( ( !String.isEmpty( newData.get( 0 ) ) ) && ( !String.isEmpty( oldData.get( 0 ) ) ) )
            {
                requestsData.add( saveRequest( oldData.get( 0 ), newData.get( 0 ), objectDataMap ) );
            }

            if ( newData.size( ) >= 2 && !String.isEmpty( newData.get( 1 ) ) && oldData.size( ) >= 2 && !String.isEmpty( oldData.get( 1 ) )
                    && ( ( requestsData.get( 0 ) ).get( 'message' ).equals( 'Success' ) && ( ( requestsData.get( 0 ) ).get( 'logRequestId' ) ) != null ) )

            {
                requestsData.add( saveRequest( oldData.get( 1 ), newData.get( 1 ), objectDataMap ) );
            }
        } catch ( LogRequestExistsException ex )
        {
            System.debug( LoggingLevel.ERROR, '[EXC] Exception ' + ex.getMessage( ) + ' stacktrace ' + ex.getStackTraceString( ) );
            Database.rollback( sSavePoint );
            objectDataMapSerialized.put( 'message', ex.getMessage( ) );
            requestsData.clear( );
            requestsData.add( objectDataMapSerialized );
        }
        //NEXI-179 Marta Stempien <marta.stempien@accenture.com> 30/07/2019 Stop
        return requestsData;
    }

    /******************************************START AV 20-12-18    Change objectDataMapInput TYPE  Map ---> String ***************************/
    @auraEnabled
    public static Map<String, Object> saveRequest( string oldData, string newData, String objectDataMap )
    {
        System.debug( 'saveRequest method' );
        Boolean isError = false;
        Boolean logRequestExistsException = false;

        String message = '';
        Map<String, Object> objDataMap = ( Map<String, Object> ) JSON.deserializeUntyped( objectDataMap );
        System.debug( 'objDataMap deserialized: ' + JSON.serialize( objDataMap ) );
        try
        {
            Map<String, String> mandatoryFormalCheck = mandatoryFieldsCheck( OB_UtilityConstants.MANDATORYMAINTENANCECOMPANYDATA, objDataMap );
            //STOP SAVE METHOT IF THERE ARE FORMAL ERROR
            Object errorFamilyObject = objDataMap.get( 'errorFamily' );
            System.debug( 'errorFamilyObject: ' + errorFamilyObject );
            Map<String, Object> mappaErrorFamily = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( errorFamilyObject ) );
            System.debug( 'mappaErrorFamily: ' + mappaErrorFamily );
            if ( mappaErrorFamily != null )
            {
                for ( String key : mappaErrorFamily.keySet( ) )
                {
                    if ( ( Boolean ) ( mappaErrorFamily.get( key ) ) )
                    {
                        System.debug( 'IS ERROR TRUE' );
                        isError = true;
                    }
                }
            }
            system.debug( 'mandatoryFormalCheck: ' + mandatoryFormalCheck );
            objDataMap.put( 'checkMapValues', mandatoryFormalCheck );
            objDataMap.put( 'setRedBordercompanyData', false );
            if ( mandatoryFormalCheck.size( ) >= 1 )
            {
                System.debug( 'MAP not empty' );
                objDataMap.put( 'setRedBordercompanyData', true );

                isError = true;
                System.debug( 'setRedBorder ::::' + objDataMap.get( 'setRedBordercompanyData' ) );
            }

            Map<String, Map<String, Schema.DescribeFieldResult>> objType2fieldData = new Map<String, Map<String, Schema.DescribeFieldResult>>( );
            objType2fieldData.putAll( OB_Maintenance_Helper.fieldObjType2APINameSchema( new list<string> {'Account', 'Contact'} ) );

            EditAccountSimple simpleOld = ( EditAccountSimple ) JSON.deserialize( oldData, EditAccountSimple.class );
            EditAccountSimple simpleNew = ( EditAccountSimple ) JSON.deserialize( newData, EditAccountSimple.class );
            Id accountId = simpleNew.account.Id;

            System.debug( 'simpleNew account: ' + simpleNew.account );
            System.debug( 'simpleOld aCCount: ' + simpleOld.account );
            System.debug( 'simpleNew contact: ' + simpleNew.contact );
            System.debug( 'simpleOld contact: ' + simpleOld.contact );
            System.debug( 'isError: ' + isError );

            // NEXI-359 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 09/10/2019 START
            Boolean isInvalidLivigno = false;
            for ( Account loopAccount :
            [
                    SELECT OB_VAT_Not_Present__c,
                            OB_DescriptionVATNotPresent__c
                    FROM Account
                    WHERE Id = :accountId
                    LIMIT 1
            ])
            {
                if ( loopAccount.OB_VAT_Not_Present__c &&
                     OB_UtilityConstants.LIVIGNO.equalsIgnoreCase( loopAccount.OB_DescriptionVATNotPresent__c ) &&
                     !OB_UtilityConstants.LIVIGNO.equalsIgnoreCase( simpleNew.account.OB_Legal_Address_City__c ) )
                {
                    isError = true;
                    isInvalidLivigno = true;
                    System.debug( LoggingLevel.FINE, 'OB_Maintenance_EditAccount_Controller.saveRequest invalid data for Livigno typology' );
                }
            }
            // NEXI-359 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 09/10/2019 STOP

            map<SObject, SObject> mapDifference = new map<SObject, SObject>( );
            mapDifference.put( simpleOld.account, simpleNew.account );
            // Start antonio.vatrano 02/04/2019controll if contact is null
            if ( simpleOld.contact != null && simpleNew.contact != null )
            {
                mapDifference.put( simpleOld.contact, simpleNew.contact );
            }

            //NEXI-179 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 15/07/2019 Start
            if ( simpleOld.externalSourceMappings != null && !simpleOld.externalSourceMappings.isEmpty( ) )
            {
                for ( ExternalSourceMapping__c oldExtSource : simpleOld.externalSourceMappings )
                {
                    for ( ExternalSourceMapping__c newExtSource : simpleNew.externalSourceMappings )
                    {
                        if ( oldExtSource.id == newExtSource.id )
                        {
                            mapDifference.put( oldExtSource, newExtSource );
                        }
                    }
                }
            }
            //NEXI-179 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 15/07/2019 Stop

            System.debug( 'mapDifference: ' + isError );
            //giovanni spinelli - 11/01/2019 - change if condition to manage scenario without legal office
            if ( ( ( simpleOld.account != null && simpleNew.account != null ) ||
                    ( simpleOld.account != null && simpleNew.account != null && simpleOld.contact != null && simpleNew.contact != null ) ) &&
                    !isError )
            {
                OB_Maintenance_Helper.serializeObject reducedOldData = new OB_Maintenance_Helper.serializeObject( );
                OB_Maintenance_Helper.serializeObject reducedNewData = new OB_Maintenance_Helper.serializeObject( );
                OB_Maintenance_Helper.CheckboxesWrapper checkboxFields = new OB_Maintenance_Helper.CheckboxesWrapper( );
                System.debug( 'checkboxFields: ' + checkboxFields );
                OB_Maintenance_Helper.generateDifferenceObject( mapDifference, reducedOldData, reducedNewData, checkboxFields );
                // add resource to save the logrequest.
                System.debug( 'reducedOldData: ' + reducedOldData );
                System.debug( 'reducedNewData: ' + reducedNewData );
                if ( checkboxFields.isSuccess )
                {
                    //elena.preteni 6/5/2019 Stream Anagrafica Maintenance Integration
                    List<ExternalSourceMapping__c> associativeList = [ SELECT id,OB_Source__c,OB_CustomerCodeClientCode__c FROM ExternalSourceMapping__c WHERE OB_Merchant_ID__c = :accountId ];
                    system.debug( 'esm associativeList ' + associativeList );
                    Boolean flagSia = false;
                    for ( ExternalSourceMapping__c esm : associativeList )
                    {
                        if ( OB_UtilityConstants.SIA.equalsIgnoreCase( esm.OB_Source__c ) ) // NEXI-194 Marta Stempien <marta.stempien@accenture.com> Change order to prevent reference to null object, 10/07/2019
                        {
                            flagSia = true;
                            break;
                        }
                    }
                    Map<String, String> sourceMap = new Map<String, String>( );
                    sourceMap.put( 'OB_MaintenanceType__c', 'Anagrafica' );
                    sourceMap.put( 'OB_AccountId__c', accountId );
                    sourceMap.put( 'OB_ServicePointId__c', null );
                    sourceMap.put( 'OB_ReducedOldData__c', JSON.Serialize( reducedOldData ) );
                    sourceMap.put( 'OB_ReducedNewData__c', JSON.Serialize( reducedNewData ) );
                    //elena.preteni 11/09/19 - changing value from map:
                    sourceMap.put( 'OB_ChangeCompanyData__c', ( checkboxFields.newLegalRepresentative || checkboxFields.changeLegalRepresentative ) ? String.valueOf( false ) : String.valueOf( true ) );
                    sourceMap.put( 'OB_ChangeLegalForm__c', String.valueOf( checkboxFields.changeLegalForm ) );
                    sourceMap.put( 'OB_ChangeLegalRepresentative__c', String.valueOf( checkboxFields.changeLegalRepresentative ) );
                    sourceMap.put( 'OB_ChangeMerchantName__c', String.valueOf( checkboxFields.changeMerchantName ) );
                    sourceMap.put( 'OB_ChangeServicePointData__c', String.valueOf( checkboxFields.changeServicePointData ) );
                    sourceMap.put( 'OB_change_of_reporting_type__c', String.valueOf( checkboxFields.changeReportType ) ); // NEXI-179 Marta Stempien <marta.stempien@accenture.com> 15/07/2019 Added checkbox to sourceMap
                    sourceMap.put( 'OB_NewLegalRepresentative__c', String.valueOf( checkboxFields.newLegalRepresentative ) );
                    sourceMap.put( 'OB_SIAToBeApproved__c', String.valueOf( flagSia ) );
                    sourceMap.put( 'OB_isNotIntegrated__c', String.valueOf( checkboxFields.isNotIntegrated ) ); //NEXI-179 Marta Stempien <marta.stempien@accenture.com 29/07/2019 Added checkbox to sourceMap
                    // NEXI-301 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 05/09/2019 START getting sae, ateco from reduced new data
                    String newSae;
                    String newAteco;
                    String legalFormCode; // NEXI-325 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 12/09/2019
                    for ( SObject loopData : reducedNewData.obj )
                    {
                        if ( loopData instanceof Account )
                        {
                            Account simpleAccount = ( Account ) loopData;
                            newSae = simpleAccount.OB_SAE_Code__c;
                            newAteco = simpleAccount.OB_ATECO__c;
                            legalFormCode = simpleAccount.OB_Legal_Form_Code__c; // NEXI-325 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 12/09/2019
                            break;
                        }
                    }
                    Map<String, String> specialCategories = putSpecialCategoriesFields( newSae, newAteco, legalFormCode ); // NEXI-325 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 12/09/2019 added legalFormCode
                    // NEXI-301 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 05/09/2019 STOP
                    // NEXI-295 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 03/09/2019 START
                    if ( !specialCategories.isEmpty( ) )
                    {
                        sourceMap.putAll( specialCategories );
                        sourceMap.put( 'OB_StartApprovalProcess__c', 'true' );
                    }
                    // NEXI-295 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 03/09/2019 STOP
                    // NEXI-298 Marta Stempien <marta.stempien@accenture.com> 07/09/2019 Deleted check - change company data lr always requires documents - logic moved to uploading documents
                    //NEXI-181 Marta Stempien <marta.stempien@accenture.com> 16/07/2019 Start
                    if ( checkboxFields.changeReportType && !checkboxFields.changeCompanyData ) // NEXI-298 Marta Stempien <marta.stempien@accenture.com> 07/09/2019 Deleted unnecessary checks
                    {
                        sourceMap.put( 'OB_Status__c', OB_UtilityConstants.LOGREQUEST_STATUS_CONFERMATO );
                    }
                    //NEXI-181 Marta Stempien <marta.stempien@accenture.com> 16/07/2019 Stop
                    else
                    {
                        sourceMap.put( 'OB_Status__c', OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT );
                    }
                    sourceMap.put( 'OB_SIAToBeApproved__c', String.valueOf( flagSia ) );

                    //END elena.preteni 6/5/2019 Stream Anagrafica Maintenance Integration

                    // DG - 29/03/19 - RP_019 - START
                    System.debug( 'objDataMap: ' + JSON.serialize( objDataMap ) );
                    Object cabObject = objDataMap.get( 'userWrapper' );
                    System.debug( 'cabObject: ' + JSON.serialize( cabObject ) );
                    Map<String, Object> cabMap = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( cabObject ) );
                    System.debug( 'cabMap: ' + JSON.serialize( cabMap ) );
                    if ( cabMap != null )
                    {
                        //START elena.preteni 6/5/2019 Stream Anagrafica Maintenance Integration
                        sourceMap.put( 'OB_CAB__c', String.valueOf( cabMap.get( 'cab' ) ) );
                        //END elena.preteni 6/5/2019 Stream Anagrafica Maintenance Integration
                    }
                    // DG - 29/03/19 - RP_019 - END

                    //  micol.ferrari FIX
                    List<User> listOfUsers = [ SELECT Id, Profile.Userlicense.Name,OB_CAB__c, contact.account.OB_ABI__c FROM User WHERE Id = :userinfo.getuserid( ) LIMIT 1 ];
                    if ( !listOfUsers.isEmpty( ) )
                    {
                        //START elena.preteni 6/5/2019 Stream Anagrafica Maintenance Integration
                        sourceMap.put( 'OB_ABI__c', listOfUsers.get( 0 ).Profile.Userlicense.Name == Label.OB_License_PartnerCommunity ? listOfUsers.get( 0 ).contact.account.OB_ABI__c : null );
                        //END elena.preteni 6/5/2019 Stream Anagrafica Maintenance Integration
                    }
                    // START elena.preteni@accenture.com 3/5/19 add callout to submit Stream Maintenance integrazioni Anagrafica
                    Map<String, Object> mapReducedNewData = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.Serialize( reducedNewData ) );
                    system.debug( '## mapReducedNewData: ' + mapReducedNewData );
                    system.debug( '## obj: ' + mapReducedNewData.get( 'obj' ) );
                    List<Object> newlistOfObjs = ( List<Object> ) JSON.deserializeUntyped( JSON.serialize( mapReducedNewData.get( 'obj' ) ) );
                    system.debug( '## listOfObjs: ' + newlistOfObjs );
                    List<Map<String, Object>> newlistOfMaps = new List<Map<String, Object>>( );
                    for ( Object obj : newlistOfObjs )
                    {
                        newlistOfMaps.add( ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( obj ) ) );
                    }
                    system.debug( '## newlistOfMaps: ' + newlistOfMaps );
                    // END elena.preteni@accenture.com 29/4/19 add callout to submit Stream Maintenance integrazioni Anagrafica
                    //START elena.preteni 6/5/2019 Stream Maintenance integrazioni Anagrafica
                    OB_LogRequest__c logRequest = OB_Utility.insertLogRequest( sourceMap );
                    String logRequestId = logRequest.Id;
                    objDataMap.put( 'logRequestId', logRequestId );
                    //END elena.preteni 6/5/2019 Stream Maintenance integrazioni Anagrafica
                    isError = false;
                    objDataMap.put( 'message', 'Success' );
                    objDataMap.put( 'documentRequired', checkboxFields.documentRequired ); // C.Q added the id of logrequest generated
                    objDataMap.put( 'isNotIntegrated', String.valueOf( checkboxFields.isNotIntegrated ) ); // NEXI-295 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 02/09/2019
                }
                else
                {
                    System.debug( 'ERROR ELSE 1' );
                    isError = true;
                    objDataMap.put( 'message', 'Error' );
                }
            }
            else
            {
                System.debug( 'ERROR ELSE 2' );
                isError = true;
                // NEXI-359 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 09/10/2019 START
                System.debug( LoggingLevel.ERROR, 'OB_Maintenance_EditAccount_Controller.saveRequest isError' );
                if ( isInvalidLivigno )
                {
                    System.debug( LoggingLevel.ERROR, 'OB_Maintenance_EditAccount_Controller.saveRequest invalid city - is not Livigno' );
                    objDataMap.put( OB_UtilityConstants.MESSAGE, Label.OB_LIVIGNO_CHECK_ERROR );
                }
                else
                {
                    objDataMap.put( OB_UtilityConstants.MESSAGE, Label.OB_MAINTENANCE_INCONSISTENTDATA );
                }
                // NEXI-359 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 09/10/2019 STOP
            }
            // output : error to show / OR 'OK' for no error.
        } catch ( Exception ecc )
        {
            System.debug( LoggingLevel.ERROR, 'Generic Error: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
            isError = true;
            //NEXI-179 Marta Stempien <marta.stempien@accenture.com> 30/07/2019 Start
            if ( logRequestExistsException )
            {
                throw new LogRequestExistsException( ecc.getMessage( ) );
            }
            //NEXI-179 Marta Stempien <marta.stempien@accenture.com> 30/07/2019 Stop
            objDataMap.put( 'message', ecc.getMessage( ) );
        }

        return objDataMap;
    }

    /*******************************************************************************
    Purpose:  Method check if user is in Maintenance Titolari effectivi process
    Parameters: Map<String, Object> inData
    Returns: Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       13/06/2019      Created         NEXI-60
    ********************************************************************************/
    @TestVisible
    private static Boolean checkIfMaintenanceTE( Map<String, Object> inData )
    {
        System.debug( LoggingLevel.FINE, 'OB_Maintenance_EditAccount_Controller.checkIfMaintenanceTE start ' + inData );
        Boolean isMaintenanceTE = false;
        try
        {
            if ( inData.get( 'isMaintenanceTE' ) != null )
            {
                isMaintenanceTE = ( Boolean ) inData.get( 'isMaintenanceTE' );
            }
        } catch ( Exception ex )
        {
            System.debug( LoggingLevel.ERROR, '[EXC] Exception ' + ex.getMessage( ) + ' stacktrace ' + ex.getStackTraceString( ) );
            isMaintenanceTE = false;
        }
        System.debug( LoggingLevel.FINE, 'OB_Maintenance_EditAccount_Controller.checkIfMaintenanceTE stop ' + isMaintenanceTE );
        return isMaintenanceTE;


    }

    /******************************************START AV 20-12-18    Change objectDataMapInput TYPE  Map ---> String ***************************/
    @auraEnabled
    public static Map<String, Object> saveRequestExecutor( string oldData, string newData, boolean isNewContact, String objectDataMapInput )
    {
        System.debug( 'INTO METHOD SAVE REQUEST EXECUTOR' );
        System.debug( 'oldData is ' + oldData );
        System.debug( 'newData is ' + newData );
        OB_maintenance_Helper hlpClass = new OB_maintenance_Helper( );
        List<User> currentUserList = new List<User>( );
        currentUserList = hlpClass.getCurrentUser( );
        System.debug( 'currentUserList: ' + currentUserList.get( 0 ).contact.account.id );
        Boolean isError = false;
        system.debug( 'objectDataMapInput: ' + JSON.serialize( objectDataMapInput ) );
        system.debug( 'before deserializeUntyped' );

        Map<String, Object> objDataMap = ( Map<String, Object> ) JSON.deserializeUntyped( objectDataMapInput );
        Boolean isMaintenanceTE = checkIfMaintenanceTE( objDataMap );//NEXI-60 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 13/06/2019
        Object errorEEMapObject = objDataMap.get( 'errorEEMap' );
        system.debug( 'errorEEMapObject::' + errorEEMapObject );
        Map<String, Object> mappaErrorEE = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( errorEEMapObject ) );
        try
        {
            objDataMap.put( 'setRedBorderMaintenance', true ); //BOOLEAN TO DIVIDE FLOW CASE TO MAINTENANCE FOR CMP OB_FlowInput
            Map<String, String> mandatoryFormalCheck = mandatoryFieldsCheck( checkCountryFieldMandatory( OB_UtilityConstants.MANDATORYMAINTENANCEEXECUTOR, objDataMap ), objDataMap );

            objDataMap.put( 'checkMapValues', mandatoryFormalCheck );
            objDataMap.put( 'setRedBordercompanyData', false );
            objDataMap.put( 'setRedBordercompanyDataValidation', false );
            system.debug( 'mandatoryFormalCheck' + mandatoryFormalCheck );
            if ( mandatoryFormalCheck.size( ) >= 1 )
            {
                System.debug( 'MAP not empty' );
                objDataMap.put( 'setRedBordercompanyData', true );
                isError = true;
            }

            if ( isError == false )
            {
                //METHOD TO VALIDATE FIELD
                Map<String, String> mandatoryValidationCheck = checkValidationCont( ( Contact ) JSON.deserialize( newData, Contact.class ), 'legaleRapp', mappaErrorEE );
                mandatoryValidationCheck = checkValidationFC( mandatoryValidationCheck, objDataMap, newData );       //NEXI-125, kinga.fornal@accenture.com, 02.07.2017
                objDataMap.put( 'validationCheckMap', mandatoryValidationCheck );
                system.debug( 'mandatoryValidationCheck' + mandatoryValidationCheck );
                if ( mandatoryValidationCheck.size( ) >= 1 )
                {
                    System.debug( 'MAP not empty' + mandatoryValidationCheck );
                    objDataMap.put( 'setRedBordercompanyData', true );
                    objDataMap.put( 'setRedBordercompanyDataValidation', true );
                    isError = true;
                    System.debug( 'setRedBordercompanyDataValidation ::::' + objDataMap.get( 'setRedBordercompanyDataValidation' ) );
                }
            }

            //NO MANDATORY FIELD ERROR --> SAVE
            if ( isError == false )
            {
                Map<String, Map<String, Schema.DescribeFieldResult>> objType2fieldData = new Map<String, Map<String, Schema.DescribeFieldResult>>( );
                objType2fieldData.putAll( OB_Maintenance_Helper.fieldObjType2APINameSchema( new list<string> {'Contact'} ) );

                //giovanni spinelli-14/12/2018-save record type id in new contact -start
                Id rtExecutor = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.ESECUTORE ).getRecordTypeId( );
                Contact simpleNewContact = ( Contact ) JSON.deserialize( newData, Contact.class );
                System.debug( 'SIMPLE NEW CONTACT ' + JSON.serialize( simpleNewContact ) );
                simpleNewContact.recordTypeId = rtExecutor;
                //giovanni spinelli 10/01/2019 - save the bank on contact
                //if is partner community
                if ( currentUserList.get( 0 ).Profile.UserLicense.Name.equalsIgnoreCase( 'Partner Community' ) )
                {
                    simpleNewContact.OB_Bank__c = currentUserList.get( 0 ).contact.account.id;
                }
                else
                {
                    //operation scenario...
                }
                newData = JSON.serialize( simpleNewContact );
                //giovanni spinelli-14/12/2018-save record type id in new contact -end

                SObject simpleOld = ( SObject ) JSON.deserialize( oldData, Contact.class );

                SObject simpleNew = ( SObject ) JSON.deserialize( newData, Contact.class );
                system.debug( 'simpleNew: ' + simpleNew + '  simpleOld: ' + simpleOld );
                Id accountId = ( Id ) simpleNew.get( 'AccountId' );

                System.debug( 'accountId: ' + accountId );
                map<SObject, SObject> mapDifference = new map<SObject, SObject>( );

                //  START   micol.ferrari 17/12/2018
                Boolean isNewExecutor = false;
                //  END     micol.ferrari 17/12/2018

                if ( !isNewContact )
                {
                    // if is an old contact modified.
                    mapDifference.put( simpleOld, simpleNew );
                }
                else
                {
                    // if a new contact is created

                    //  START   micol.ferrari 17/12/2018
                    isNewExecutor = true;
                    //  END     micol.ferrari 17/12/2018

                    // deactivatig the old contact
                    System.debug( 'old data before state. ' + oldData );
                    SObject oldContactToDeactivete = ( SObject ) JSON.deserialize( oldData, Contact.class );
                    System.debug( 'oldContactToDeactivete ' + oldContactToDeactivete );
                    // NEXI-168 Marta Stempien <marta.stempien@accenture.com> 05/07/2019 Added check for existing old Executor, Start
                    if ( oldContactToDeactivete.Id != null )
                    {
                        oldContactToDeactivete.put( 'OB_Contact_State__c', OB_UtilityConstants.STATUS_INACTIVE );
                        simpleOld.put( 'OB_Contact_State__c', OB_UtilityConstants.STATUS_ACTIVE );
                        mapDifference.put( simpleOld, oldContactToDeactivete );
                    }
                    // NEXI-168 Marta Stempien <marta.stempien@accenture.com> 05/07/2019, Stop

                    // setting new contact to active
                    SObject dummyContact = ( SObject ) new Contact( );
                    simpleNew.put( 'OB_Contact_State__c', OB_UtilityConstants.STATUS_ACTIVE );
                    mapDifference.put( dummyContact, simpleNew );

                }
                OB_Maintenance_Helper.serializeObject reducedOldData = new OB_Maintenance_Helper.serializeObject( );
                OB_Maintenance_Helper.serializeObject reducedNewData = new OB_Maintenance_Helper.serializeObject( );
                OB_Maintenance_Helper.CheckboxesWrapper checkboxFields = new OB_Maintenance_Helper.CheckboxesWrapper( );
                OB_Maintenance_Helper.generateDifferenceObject( mapDifference, reducedOldData, reducedNewData, checkboxFields );
                // add resource to save the logrequest.
                system.debug( 'reducedOldData: ' + reducedOldData );
                system.debug( 'reducedNewData: ' + reducedNewData );
                if ( checkboxFields.isSuccess )
                {
                    // se sei communit da aggiungere :
                    //-- ABI --- da utente.... , cab dallo user.

                    //elena.preteni 6/5/2019 Stream Anagrafica Maintenance Integration
                    List<ExternalSourceMapping__c> associativeList = [ SELECT id,OB_Source__c,OB_CustomerCodeClientCode__c,OB_ServicePointCodeShopCode__c FROM ExternalSourceMapping__c WHERE OB_Merchant_ID__c = :accountId ];
                    system.debug( 'esm associativeList ' + associativeList );
                    Boolean flagSia = false;
                    for ( ExternalSourceMapping__c esm : associativeList )
                    {
                        if ( esm.OB_Source__c.equalsIgnoreCase( 'SIA' ) )
                        {
                            flagSia = true;
                            break;
                        }
                    }
                    Map<String, String> sourceMap = new Map<String, String>( );
                    sourceMap.put( 'OB_MaintenanceType__c', 'Anagrafica' );
                    sourceMap.put( 'OB_AccountId__c', accountId );
                    sourceMap.put( 'OB_ServicePointId__c', null );
                    sourceMap.put( 'OB_ReducedOldData__c', JSON.Serialize( reducedOldData ) );
                    sourceMap.put( 'OB_ReducedNewData__c', JSON.Serialize( reducedNewData ) );
                    // NEXI-139 Marta Stempien <marta.stempien@accenture.com> 28/06/2019 Set false for checkboxes not related to Executore Maintenance
                    sourceMap.put( 'OB_ChangeCompanyData__c', String.valueOf( false ) );
                    sourceMap.put( 'OB_ChangeLegalForm__c', String.valueOf( false ) );
                    sourceMap.put( 'OB_ChangeLegalRepresentative__c', String.valueOf( !isNewExecutor ) );
                    sourceMap.put( 'OB_NewLegalRepresentative__c', String.valueOf( isNewExecutor ) );
                    sourceMap.put( 'OB_ChangeMerchantName__c', String.valueOf( false ) );
                    sourceMap.put( 'OB_ChangeServicePointData__c', String.valueOf( false ) );
                    // NEXI-139 Marta Stempien <marta.stempien@accenture.com> 28/06/2019, STOP
                    sourceMap.put( 'OB_Status__c', OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA );// antonio.vatrano 04/10/2019 r1f3-134 
                    sourceMap.put( 'OB_SIAToBeApproved__c', String.valueOf( flagSia ) );
                    //END elena.preteni 6/5/2019 Stream Anagrafica Maintenance Integration

                    // DG - 29/03/19 - RP_019 - START
                    Object cabObject = objDataMap.get( 'userWrapper' );
                    System.debug( '@@@@ cabObject' + cabObject );
                    Map<String, Object> cabMap = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( cabObject ) );
                    System.debug( '@@@@ cabMap' + cabMap );
                    //NEXI-261 Marta Stempien <marta.stempien@accenture.com> 07/08/2019 Start
                    sourceMap.put( 'OB_isNotIntegrated__c', String.valueOf( true ) ); //antonio.vatrano wn-430 18/09/2019
                    sourceMap.put( 'OB_Change_of_data_of_beneficial_owners__c', String.valueOf( false ) );

                    //NEXI-261 Marta Stempien <marta.stempien@accenture.com> 07/08/2019 Stop
                    if ( cabMap != null )
                    {
                        //START elena.preteni 6/5/2019 Stream Anagrafica Maintenance Integration
                        sourceMap.put( 'OB_CAB__c', String.valueOf( cabMap.get( 'cab' ) ) );
                        //END elena.preteni 6/5/2019 Stream Anagrafica Maintenance Integration
                    }
                    // DG - 29/03/19 - RP_019 - END

                    //  micol.ferrari FIX
                    List<User> listOfUsers = [ SELECT Id, Profile.Userlicense.Name,OB_CAB__c, contact.account.OB_ABI__c FROM User WHERE Id = :userinfo.getuserid( ) LIMIT 1 ];
                    if ( !listOfUsers.isEmpty( ) )
                    {
                        //START elena.preteni 6/5/2019 Stream Anagrafica Maintenance Integration
                        sourceMap.put( 'OB_ABI__c', listOfUsers.get( 0 ).Profile.Userlicense.Name == Label.OB_License_PartnerCommunity ? listOfUsers.get( 0 ).contact.account.OB_ABI__c : null );
                        //END elena.preteni 6/5/2019 Stream Anagrafica Maintenance Integration

                    }
                    //NEXI-60 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 13/06/2019 Start skip check on log request for Maintenance TE
                    Map<String, String> requestAlreadyExist;
                    if ( !isMaintenanceTE )
                    {
                        requestAlreadyExist = OB_Maintenance_Helper.CheckRequestAlreadyExist( sourceMap );
                    }
                    else
                    {
                        sourceMap.put( 'OB_Change_of_data_of_beneficial_owners__c', 'true' );
                    }
                    if ( isMaintenanceTE || ( requestAlreadyExist.containsKey( 'RECORDFOUND' ) && requestAlreadyExist.get( 'RECORDFOUND' ) == 'false' ) )
                    {
                        //NEXI-60 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 13/06/2019 Stop skip check on log request for Maintenance TE
                        // START elena.preteni@accenture.com 6/5/19 add callout to submit Stream Maintenance integrazioni Anagrafica
                        Map<String, Object> mapReducedNewData = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.Serialize( reducedOldData ) );
                        system.debug( '## mapReducedNewData: ' + mapReducedNewData );
                        system.debug( '## obj: ' + mapReducedNewData.get( 'obj' ) );
                        List<Object> newlistOfObjs = ( List<Object> ) JSON.deserializeUntyped( JSON.serialize( mapReducedNewData.get( 'obj' ) ) );
                        system.debug( '## listOfObjs: ' + newlistOfObjs );
                        List<Map<String, Object>> newlistOfMaps = new List<Map<String, Object>>( );
                        for ( Object obj : newlistOfObjs )
                        {
                            newlistOfMaps.add( ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( obj ) ) );
                        }
                        system.debug( '## newlistOfMaps: ' + newlistOfMaps );
                        // END elena.preteni@accenture.com 6/5/19 add callout to submit Stream Maintenance integrazioni Anagrafica
                        System.debug( 'SIMPLE NEW BEFORE DESERIALIZA: ' + JSON.serialize( simpleNew ) );
                        Map<String, Object> simpleNewMap = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( simpleNew ) );
                        System.debug( 'SIMPLE NEW MAP PEP: ' + simpleNewMap.get( 'OB_PEP__c' ) );
                        //START elena.preteni 6/5/2019 Stream Maintenance integrazioni Anagrafica
                        OB_LogRequest__c logRequest = OB_Utility.insertLogRequest( sourceMap );
                        String logRequestId = logRequest.Id;
                        objDataMap.put( 'logRequestId', logRequestId );
                        //END elena.preteni 6/5/2019 Stream Maintenance integrazioni Anagrafica

                        isError = false;
                        objDataMap.put( 'message', 'Success' );
                    }
                    else
                    {
                        isError = true;
                        String namelog = requestAlreadyExist.containsKey( 'LOGNAME' ) && requestAlreadyExist.get( 'LOGNAME' ) != null ? ' (' + requestAlreadyExist.get( 'LOGNAME' ) + ')' : '';
                        objDataMap.put( 'message', System.label.OB_MAINTENANCE_LOGALREADYEXIST + namelog );
                    }
                }
                else
                {
                    isError = true;
                    objDataMap.put( 'message', Label.OB_MAINTENANCE_ERROR_NODATACHANGE );
                }
            }
            else
            {
                objDataMap.put( 'message', 'Mandatory Field' );
            }
            // output : error to show / OR 'OK' for no error.
        } catch ( Exception ecc )
        {
            System.debug( 'Generic Error: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
            isError = true;
            objDataMap.put( 'message', ecc.getMessage( ) );
        }

        return objDataMap;

    }

    @AuraEnabled
    public static Map<String, String> getCompanyLinkTypes( )
    {
        Map<String, String> pickListValuesList = new Map<String, String>( );
        Schema.DescribeFieldResult fieldResult = Contact.OB_Company_Link_Type__c.getDescribe( );
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues( );
        for ( Schema.PicklistEntry pickListVal : ple )
        {
            pickListValuesList.put( pickListVal.getValue( ), pickListVal.getLabel( ) );
            System.debug( 'pickListValuesList companylinktype ' + pickListValuesList );
        }

        return pickListValuesList;
    }

    @AuraEnabled
    public static Map<String, String> getGenders( )
    {
        Map<String, String> pickListValuesList = new Map<String, String>( );
        Schema.DescribeFieldResult fieldResult = Contact.OB_Sex__c.getDescribe( );
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues( );
        for ( Schema.PicklistEntry pickListVal : ple )
        {
            pickListValuesList.put( pickListVal.getValue( ), pickListVal.getLabel( ) );
            System.debug( 'pickListValuesList companylinktype ' + pickListValuesList );
        }

        return pickListValuesList;
    }

    /*
	* Author : Claudio Quaranta
	* Date : 22/11/2018
	*   Description : method called from a lighting component, used to retrieve the fields label for object retrivedi in input.
	*   input : the list of SObject for schema estraction (E.G 'Account', 'Contact' ecc)
	*   output : a map that contasin the object as akey, and a map of field api name- field label
	*/

    @auraEnabled
    public static string retriveSchemaInformation( list<string> SObjectToRetrive )
    {
        Map<String, Map<String, Schema.DescribeFieldResult>> objType2fieldData = new Map<String, Map<String, Schema.DescribeFieldResult>>( );
        objType2fieldData.putAll( OB_Maintenance_Helper.fieldObjType2APINameSchema( SObjectToRetrive ) );
        SchemaWrapper returnWrapper = new SchemaWrapper( );
        for ( string currentSObject : SObjectToRetrive )
        {
            returnWrapper.mapSObjectfields.put( currentSObject, OB_maintenance_helper.estractFieldsLabel( objType2fieldData.get( currentSObject ) ) );
        }
        string toReturnJSON = JSON.serialize( returnWrapper );
        return toReturnJSON;
    }


    @auraEnabled
    public static Map<String, String> mandatoryFieldsCheck( Map<String, Map<String, String>> objectDataMapInput, Map<String, Object> data )
    {
        system.debug( 'data: ' + data );
        system.debug( 'objectDataMapInput: ' + objectDataMapInput );
        Map<String, String> errorMap = new Map<String, String>( );
        for ( String key : objectDataMapInput.keySet( ) )
        {
            System.debug( 'the key is---> ' + key );
            Map<String, String> temporaryMap = new Map<String, String>( );
            temporaryMap = objectDataMapInput.get( key );
            System.debug( 'the  temporaryMap is---> ' + temporaryMap );
            System.debug( 'the key in temporaryMap is---> ' + temporaryMap.keySet( ) );
            //ITERATION IN COSTANT MAP VALUE WITH PREVIOUS KEY-->GET VALUES
            for ( String value : temporaryMap.keySet( ) )
            {

                try
                {
                    //GET THE VALUE FROM OBJECTDATAMAP PASSING COSTANT KEY
                    Object valueInMap = data.get( key );
                    System.debug( 'valueInMap is:' + valueInMap );//v.objectDataMap with key of constants and value from flow

                    //CREATION OF A NEW MAP TO GET THE OBJECT VALUE
                    Map<String, Object> mapFromObj = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( valueInMap ) );
                    System.debug( 'deserialized map is:' + mapFromObj );
                    System.debug( 'get value from map: ' + mapFromObj.get( value ) );
                    //VALUATE IF THE VALUE IS NULL OR OTHER CONTROLS
                    if ( mapFromObj.get( value ) == null || mapFromObj.get( value ) == '' )
                    {
                        //ACTIVATE THE MESSAGE ERROR
                        System.debug( 'into if method' );
                        String mandatoryField = Label.MandatoryField;
                        errorMap.put( temporaryMap.get( value ), mandatoryField );
                        System.debug( 'errorMap---> ' + errorMap );
                    }

                } catch ( Exception e )
                {
                    System.debug( 'The following exception has occurred: ' + e.getMessage( ) );
                }
            }
        }
        return errorMap;
    }

    private static Map<String, Map<String, String>> checkCountryFieldMandatory( Map<String, Map<String, String>> constantMap, Map<String, Object> objectDataMap )
    {
        Map<String, Object> legaleRappMap = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( objectDataMap.get( 'executor' ) ) );
        Map<String, String> esecutoreEEValue = constantMap.get( 'executorEE' );
        Map<String, String> esecutoreValue = constantMap.get( 'executor' );
        try
        {
            Object countryValueBirth = legaleRappMap.get( 'OB_Country_Birth__c' );
            Object countryValueDoc = legaleRappMap.get( 'OB_Document_Release_Country__c' );
            Object countryValueFull = legaleRappMap.get( 'OB_Address_Country__c' );
            System.debug( 'countryValue from objectDataMap --> ' + countryValueBirth );
            if ( countryValueBirth != 'ITALIA' )
            {
                System.debug( 'INTO IF OF NOT ITALY' );
                esecutoreValue.remove( 'OB_Birth_State__c' );
                esecutoreValue.put( 'OB_Birth_City__c', esecutoreEEValue.get( 'OB_Birth_City__c' ) );
            }
            if ( countryValueDoc != 'ITALIA' )
            {
                System.debug( 'INTO IF OF NOT ITALY' );
                esecutoreValue.remove( 'OB_Document_Release_State__c' );
                esecutoreValue.put( 'OB_Document_Release_City__c', esecutoreEEValue.get( 'OB_Document_Release_City__c' ) );
            }
            if ( countryValueFull != 'ITALIA' )
            {
                System.debug( 'INTO IF OF NOT ITALY' );
                esecutoreValue.remove( 'OB_Address_State__c' );
                esecutoreValue.put( 'OB_Address_City__c', esecutoreEEValue.get( 'OB_Address_City__c' ) );
                esecutoreValue.put( 'OB_Address_Street__c', esecutoreEEValue.get( 'OB_Address_Street__c' ) );
                esecutoreValue.put( 'OB_Address_Street_Number__c', esecutoreEEValue.get( 'OB_Address_Street_Number__c' ) );
            }

            constantMap.put( 'executor', esecutoreValue );
            constantMap.remove( 'executorEE' );
            system.debug( 'constantMap finale' + constantMap );
        } catch ( Exception ecc )
        {
            System.debug( 'Generic Error: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
        }
        return constantMap;
    }


    public static Map<String, String> checkValidationCont( Contact checkCont, String section, Map<String, Object> mappaErrorEE )
    {
        Map<String, String> mandatoryValidationCheck = new Map<String, String>( );
        Pattern docNumPattern = Pattern.compile( '^[a-zA-Z0-9]+$' );
        Matcher docNum = docNumPattern.matcher( checkCont.OB_Document_Number__c );
        Date checkBirthDate = Date.newInstance( 1900, 1, 1 );
        if ( checkCont.OB_Country_Birth__c != 'ITALIA' )
        {
            List<NE__Lov__c> lovCadastralCode = [ SELECT Id, NE__Value2__c FROM NE__Lov__c WHERE NE__Type__c = 'COUNTRY' AND Name = :checkCont.OB_Country_Birth__c ];
            if ( lovCadastralCode != null && lovCadastralCode.size( ) > 0 )
            {
                checkCont.OB_Cadastral_Code__c = lovCadastralCode[ 0 ].NE__Value2__c;
            }
        }
        system.debug( 'checkCont.OB_Cadastral_Code__c: ' + checkCont.OB_Cadastral_Code__c );
        if ( mappaErrorEE != null )
        {
            for ( String key : mappaErrorEE.keySet( ) )
            {
                if ( ( Boolean ) ( mappaErrorEE.get( key ) ) )
                {
                    mandatoryValidationCheck.put( 'isErrorEE', '' );
                }
            }
        }
        /* ANDREA MORITTU START 04-Dec-2019 - PRODOB_552 -ADDING FIX ON LENGHT - REMOVED ADRIAN'S CODE AND PUT IT UNDER PASSAPORTO AND PATENTE  */
        if ( checkCont.OB_Document_Release_Date__c > system.today( ) || checkCont.OB_Document_Release_Date__c < checkCont.OB_Birth_Date__c )
        {
            mandatoryValidationCheck.put( 'documentReleaseDate' + section + 'Doc', Label.OB_Invalid_Release_Date );
        }
        if(checkCont.OB_Document_Release_Country_Code__c == 'ITA'){ //gianluigi.virga 01/12/2019
            if ( checkCont.OB_Document_Type__c == OB_UtilityConstants.CARTA_DI_IDENTITA )
            {
                Date checkDate = Date.newInstance( 2012, 2, 10 );
                /* ANDREA MORITTU - START 31-Oct-2019 - PRODOB-551 */
                if(((checkCont.OB_Document_Release_Date__c < checkDate || checkCont.OB_Document_Release_Date__c == checkDate)
                                
                                && (checkCont.OB_Document_Expiration_Date__c != checkCont.OB_Document_Release_Date__c.addYears(10).addDays(-1) && checkCont.OB_Document_Expiration_Date__c != checkCont.OB_Document_Release_Date__c.addYears(10) ) )
                                    || ( checkCont.OB_Document_Expiration_Date__c < system.today( ) ) )
                            {
                                mandatoryValidationCheck.put(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Document_Expiration_Date__c'),Label.OB_InvalidDocumentExpirationDate);
                            }
                            /* ANDREA MORITTU START 04-Dec-2019 - PRODOB_552 -ADDING FIX ON LENGHT */
								if ( checkCont.OB_Document_Release_Country_Code__c == 'ITA' && (checkCont.OB_Document_Number__c.isAlphaNumeric() == false ) || (checkCont.OB_Document_Number__c.length() < 8 || checkCont.OB_Document_Number__c.length() > 9 ) )
                            {
                                System.debug('INSIDE NEW CHECK');
                                mandatoryValidationCheck.put( 'documentNumber', Label.OB_InvalidDocumentNumber );
                            }
                            /* ANDREA MORITTU END 04-Dec-2019 - PRODOB_552 -ADDING FIX ON LENGHT */
                /* ANDREA MORITTU - END 31-Oct-2019 - PRODOB-551 */
                else if ( checkCont.OB_Document_Release_Date__c > checkDate )
                {
                    if ( ( ( checkCont.OB_Birth_Date__c.month( ) < checkCont.OB_Document_Release_Date__c.month( ) ) || ( checkCont.OB_Birth_Date__c.month( ) == checkCont.OB_Document_Release_Date__c.month( ) && checkCont.OB_Birth_Date__c.day( ) < checkCont.OB_Document_Release_Date__c.day( ) ) ) && checkCont.OB_Document_Expiration_Date__c != Date.newInstance( checkCont.OB_Document_Release_Date__c.addYears( 11 ).year( ), checkCont.OB_Birth_Date__c.month( ), checkCont.OB_Birth_Date__c.day( ) ) )
                    {
                        mandatoryValidationCheck.put( 'documentExpirationDate' + section + 'Doc', Label.OB_InvalidDocumentExpirationDate );
                    }
                    else if ( ( ( checkCont.OB_Birth_Date__c.month( ) > checkCont.OB_Document_Release_Date__c.month( ) ) || ( checkCont.OB_Birth_Date__c.month( ) == checkCont.OB_Document_Release_Date__c.month( ) && checkCont.OB_Birth_Date__c.day( ) >= checkCont.OB_Document_Release_Date__c.day( ) ) ) && checkCont.OB_Document_Expiration_Date__c != Date.newInstance( checkCont.OB_Document_Release_Date__c.addYears( 10 ).year( ), checkCont.OB_Birth_Date__c.month( ), checkCont.OB_Birth_Date__c.day( ) ) )
                    {
                        mandatoryValidationCheck.put( 'documentExpirationDate' + section + 'Doc', Label.OB_InvalidDocumentExpirationDate );
                    }
                    /* ANDREA MORITTU START 04-Dec-2019 - PRODOB_552 -ADDING FIX ON LENGHT */
                     if ( checkCont.OB_Document_Release_Country_Code__c == 'ITA' && ( (checkCont.OB_Document_Number__c.length() < 8 || checkCont.OB_Document_Number__c.length() > 9 )  )) {
                        mandatoryValidationCheck.put( 'documentNumber', Label.OB_InvalidDocumentNumber );
                    }
                    /* ANDREA MORITTU END 04-Dec-2019 - PRODOB_552 -ADDING FIX ON LENGHT */
                }

                if ( checkCont.OB_Document_Release_Authority__c != OB_UtilityConstants.COMUNE )
                {
                    mandatoryValidationCheck.put( 'documentAuth' + section + 'Doc', Label.OB_InvalidDocumentReleaseAuthority );
                }
            }
            else if ( checkCont.OB_Document_Type__c == OB_UtilityConstants.PASSAPORTO )
            {
                if ( !docNum.matches( ) || ( checkCont.OB_Document_Number__c.length( ) != 10 && checkCont.OB_Document_Number__c.length( ) != 9 ) )
                {
                    mandatoryValidationCheck.put( 'documentNumber', Label.OB_InvalidDocumentNumber );
                }
                // START 	micol.ferrari 07/01/2019 - MAIN_55
                if ( checkCont.OB_Document_Expiration_Date__c.year( ) != checkCont.OB_Document_Release_Date__c.addYears( 10 ).year( ) || ( checkCont.OB_Document_Expiration_Date__c != checkCont.OB_Document_Release_Date__c.addYears( 10 ).addDays( -1 ) && checkCont.OB_Document_Expiration_Date__c != checkCont.OB_Document_Release_Date__c.addYears( 10 ) ) || checkCont.OB_Document_Expiration_Date__c < system.today( ) )
                {
                    mandatoryValidationCheck.put( 'documentExpirationDate' + section + 'Doc', Label.OB_InvalidDocumentExpirationDate );
                }
                // END 	micol.ferrari 07/01/2019 - MAIN_55

                if ( checkCont.OB_Document_Release_Authority__c != OB_UtilityConstants.QUESTURA )
                {
                    mandatoryValidationCheck.put( 'documentAuth' + section + 'Doc', Label.OB_InvalidDocumentReleaseAuthority );
                }
            }
            else if ( checkCont.OB_Document_Type__c == OB_UtilityConstants.PATENTE )
            {
                /* ANDREA MORITTU START 04-Dec-2019 - PRODOB_552 -ADDING FIX ON LENGHT - ADRAIN'S CODE */
                if ( !docNum.matches( ) || ( checkCont.OB_Document_Number__c.length( ) != 10 && checkCont.OB_Document_Number__c.length( ) != 9 ) )
                {
                    mandatoryValidationCheck.put( 'documentNumber', Label.OB_InvalidDocumentNumber );
                }
                /* ANDREA MORITTU END 04-Dec-2019 - PRODOB_552 -ADDING FIX ON LENGHT - ADRAIN'S CODE */
                if ( checkCont.OB_Document_Release_Authority__c != OB_UtilityConstants.UCO && checkCont.OB_Document_Release_Authority__c != OB_UtilityConstants.MOTORIZZAZIONE && checkCont.OB_Document_Release_Authority__c != OB_UtilityConstants.PREFETTURA )
                {
                    mandatoryValidationCheck.put( 'documentAuth' + section + 'Doc', Label.OB_InvalidDocumentReleaseAuthority );
                }
            }
        }
            if ( checkCont.OB_Birth_Date__c > system.today( ).addYears( -16 ) || checkCont.OB_Birth_Date__c < checkBirthDate )
            {
                mandatoryValidationCheck.put( 'birthDate' + section + 'Doc', Label.OB_InvalidBirthDate );
            }

        if ( !String.isEmpty( checkCont.OB_Fiscal_Code__c ) && checkCont.OB_Fiscal_Code__c.length( ) == 16 )
        {
            //START elena.preteni ri-62 skip cadastrial code
            String errorCFType = OB_FlowControlUtility.checkNameSurnameCF( checkCont.FirstName, checkCont.LastName, checkCont.OB_Fiscal_Code__c, String.valueOf( checkCont.OB_Birth_Date__c ), checkCont.OB_Sex__c, checkCont.OB_Cadastral_Code__c, checkCont.OB_SkipCadastralCodeCheck__c );
            //END elena.preteni ri-62 skip cadastrial code
            if ( checkCont.OB_Fiscal_Code__c.length( ) != 16 )
            {
                System.debug( 'INTO FISCAL CODE ERROR LENGTH' );
                system.debug( 'errorecfinvalid' );
                mandatoryValidationCheck.put( 'fiscalCode' + section, Label.OB_InvalidFiscalCode );
            }
            else if ( errorCFType == 'errorName' )
            {
                system.debug( 'errorecfname' );
                mandatoryValidationCheck.put( 'fiscalCode' + section, Label.OB_InconsistentFiscalCode );
            }
            else if ( errorCFType == 'errorData' )
            {
                system.debug( 'errorecfdata' );
                mandatoryValidationCheck.put( 'fiscalCode' + section, Label.OB_InvalidFiscalCodeBirthDate );
            }
            else if ( errorCFType == 'errorSurname' )
            {
                system.debug( 'errorSurname' );
                mandatoryValidationCheck.put( 'fiscalCode' + section, Label.OB_InvalidFiscalCodeSurname );
            }
            else if ( errorCFType == 'errorGender' )
            {
                system.debug( 'errorGender' );
                mandatoryValidationCheck.put( 'fiscalCode' + section, Label.OB_InvalidFiscalCodeGender );
            }
            else if ( errorCFType == 'errorCadastralCode' )
            {
                system.debug( 'cadastralCode' );
                mandatoryValidationCheck.put( 'fiscalCode' + section, Label.OB_InvalidFiscalCodeCadastralCode );
            }
            //ANDREA MORITTU 18.02.2019 START
            else if ( errorCFType == 'errorLastChar' )
            {
                system.debug( 'errorLastChar' );
                mandatoryValidationCheck.put( 'fiscalCode' + section, Label.OB_InvalidFiscalCode );
            }
        }
        else
        {
            System.debug( 'INTO ELSE FISCAL CODE ERROR LENGTH' );
            system.debug( 'errorecfinvalid' );
            mandatoryValidationCheck.put( 'fiscalCode' + section, Label.OB_InvalidFiscalCode );
        }

        system.debug( 'data error x exp' + Date.newInstance( checkCont.OB_Document_Release_Date__c.addYears( 10 ).year( ), checkCont.OB_Birth_Date__c.month( ), checkCont.OB_Birth_Date__c.day( ) ) );
        return mandatoryValidationCheck;
    }

    @auraEnabled
    public static Map<String, String> checkExistLogRequest( String AccountId )
    {
        //  micol.ferrari 19/12/2018 - CHANGED RETURN TYPE - MAIN_23_R1F1
        Map<String, String> toReturn = new Map<String, String>( );
        toReturn.put( 'RECORDFOUND', 'false' );
        toReturn.put( 'LOGNAME', null );

        list<String> listOfStatus = new list<String> {System.Label.OB_MAINTENANCE_LOGREQUEST_STATUS_CONFIRMED, System.Label.OB_MAINTENANCE_LOGREQUEST_STATUS_REJECTED};
        list<OB_LogRequest__c> logRequestExecutor =
        [
                select id,Name
                from OB_LogRequest__c
                where OB_AccountId__c = :AccountId
                AND ( OB_ChangeLegalRepresentative__c = true OR OB_NewLegalRepresentative__c = true)
                and OB_Status__c NOT IN :listOfStatus
        ];

        if ( logRequestExecutor != null && logRequestExecutor.size( ) > 0 )
        {
            toReturn.put( 'RECORDFOUND', 'true' );
            toReturn.put( 'LOGNAME', logRequestExecutor.get( 0 ).Name );
        }
        return toReturn;
    }
    /*******************************************************************************
    Purpose:  Method updates logRequests status to Draft
    Parameters: String logRequest id
    Returns:

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0           ?                      ?             Created              ?
    2.0     Marta Stempien           24/07/2019        Modified          NEXI-179
    ********************************************************************************/
    @AuraEnabled
    public static void saveDraft( String inLogRequestId )
    {
        List<OB_LogRequest__c> logRequests = [ select id,OB_Status__c from OB_LogRequest__c where id = :inLogRequestId limit 1 ];
        if ( logRequests.isEmpty( ) )
        {
            return;
        }

        OB_LogRequest__c logRequest = logRequests.get( 0 );
        if ( !OB_UtilityConstants.CONFERMATO.equalsIgnoreCase( logRequest.OB_Status__c ) )
        {
            try
            {
                logRequest.OB_Status__c = System.Label.OB_MAINTENANCE_LOGREQUEST_STATUS_DRAFT;
                logrequest.OB_Save_as_Draft__c = true; //NEXI-179 Add changes: antonio.vatrano 17/07/2019 logic to show BTN Upload documents
                update( logRequest );

            } catch ( Exception eException )
            {
                System.debug( LoggingLevel.ERROR, 'Exception during serializing/deserializing operation : ' + eException + ' stackTrace ' + eException.getStackTraceString( ) );
            }
        }
    }

    //ANDREA START 14/02/2019: ADDING METHOD FOR CHECK THE FISCAL CODE
    public static String checkNameSurnameCF( String nome, String cognome, String cf, String birthDate, String gender, String cadastralCode, Boolean skipCheckCadCode )
    {
        nome = stringNormalizer( nome.replaceAll( ' ', '' ).replaceAll( '\'', '' ).toUpperCase( ) );
        cognome = stringNormalizer( cognome.replaceAll( ' ', '' ).replaceAll( '\'', '' ).toUpperCase( ) );
        cf = cf.toUpperCase( );
        String check = null;
        String nc = extractConsonants( nome );
        if ( nc.length( ) > 3 )
            nc = nc.subString( 0, 1 ) + nc.subString( 2, 3 ) + nc.subString( 3, 4 );
        else
        {
            String nv = extractVowels( nome );
            Integer i = 0;
            while ( nc.length( ) < 3 )
            {
                try
                {
                    nc += nv.subString( i, i + 1 );
                } catch ( Exception ecc )
                {
                    nc += 'X';
                }
                i++;
            }
        }
        String cc = extractConsonants( cognome );
        if ( cc.length( ) >= 3 )
            cc = cc.subString( 0, 3 );
        else
        {
            String cv = extractVowels( cognome );
            Integer i = 0;
            while ( cc.length( ) < 3 )
            {
                try
                {
                    cc += cv.subString( i, i + 1 );
                } catch ( Exception ecc )
                {
                    cc += 'X';
                }
                i++;
            }
        }
        String cadastralCodeCheck = cf.subString( 11, 15 );
        String dataCheck = cf.subString( 6, 11 );
        String pn = cf.subString( 3, 6 );
        String pc = cf.subString( 0, 3 );
        System.debug( 'controllo CF nome: ' + nome + ' cognome: ' + cognome + ' parteNomeCF: ' + pn + ' calcolato nome: ' + nc + ' parteCognomeCF: ' + pc + ' calcolato cognome: ' + cc );


        String dd = birthDate.substring( 8, 10 );
        String mm = birthDate.substring( 5, 7 );
        String yy = birthDate.substring( 2, 4 );
        if ( gender == 'F' )
        {
            Integer ddInt = Integer.valueOf( dd );
            ddInt += 40;
            dd = String.valueOf( ddInt );
        }
        Map <String, String> mmCode = new Map <String, String> {'01' => 'A', '02' => 'B', '03' => 'C', '04' => 'D', '05' => 'E', '06' => 'H', '07' => 'L', '08' => 'M', '09' => 'P', '10' => 'R', '11' => 'S', '12' => 'T'};
        String dateCode = yy + mmCode.get( mm ) + dd;
        system.debug( 'dateCode:: ' + dateCode + ' == ' + dataCheck );
        if ( !pn.equalsIgnoreCase( nc ) )
        {
            check = 'errorName';
        }
        else if ( !pc.equalsIgnoreCase( cc ) )
        {
            check = 'errorSurname';
        }
        else if ( gender == 'F' && Integer.valueOf( dataCheck.substring( 3, 5 ) ) - 40 < 0 )
        {
            check = 'errorGender';
        }
        else if ( gender == 'M' && Integer.valueOf( dataCheck.substring( 3, 5 ) ) - 40 > 0 )
        {
            check = 'errorGender';
        }
        else if ( dateCode != dataCheck )
        {
            check = 'errorData';
        }
        //	START 	micol.ferrari 12/12/2018 -> OB_SkipCadastralCodeCheck__c
        else if ( !skipCheckCadCode && !String.IsBlank( cadastralCode ) && cadastralCode != cadastralCodeCheck )
        {
            check = 'errorCadastralCode';
        }
        //	END 	micol.ferrari 12/12/2018
        //else
        return ( check ); // && controllaCheckDigit(cf)
    }

    public static String stringNormalizer( String input )
    {
        try
        {
            String acc = 'ÀÂÄÇÉÈÊËÎÏÌÛÜÙÔÖÒÑ' + '°()§<>%^¨*$€£`#,;./?!+=_@"' + '\'Œ&Æ';        // et Œ, Æ, &;
            String maj = 'AAACEEEEIIIUUUOOON' + '                          ' + '    ';
            String out = '';
            for ( Integer i = 0; i < input.length( ); i++ )
            {
                String car = input.substring( i, i + 1 );
                Integer idx = acc.indexOf( car );
                if ( idx != -1 )
                {
                    out += maj.substring( idx, idx + 1 );
                }
                else
                {
                    out += car;
                }
            }

            return out.replaceAll( ' ', '' );
        } catch ( Exception ecc )
        {
            System.debug( 'pulisci stringa: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
            return '';
        }
    }

    public static String extractVowels( String p )
    {
        String ris = '';
        for ( Integer i = 0; i < p.length( ); i++ )
        {
            String ss = p.subString( i, i + 1 );
            if ( ss.equalsIgnoreCase( 'A' ) || ss.equalsIgnoreCase( 'E' ) || ss.equalsIgnoreCase( 'I' ) || ss.equalsIgnoreCase( 'O' ) || ss.equalsIgnoreCase( 'U' ) )
                ris += ss;
        }
        return ris;
    }

    public static String extractConsonants( String p )
    {
        String ris = '';
        for ( Integer i = 0; i < p.length( ); i++ )
        {
            String ss = p.subString( i, i + 1 );
            if ( !ss.equalsIgnoreCase( 'A' ) && !ss.equalsIgnoreCase( 'E' ) && !ss.equalsIgnoreCase( 'I' ) && !ss.equalsIgnoreCase( 'O' ) && !ss.equalsIgnoreCase( 'U' ) )
                ris += ss;
        }
        return ris;
    }

    public static Boolean controllaCheckDigit( String CF )
    {
        try
        {

            Map <Integer, Integer> conversione = new Map <Integer, Integer>
            {
                    0 => 1
                    , 1 => 0
                    , 2 => 5
                    , 3 => 7
                    , 4 => 9
                    , 5 => 13
                    , 6 => 15
                    , 7 => 17
                    , 8 => 19
                    , 9 => 21
                    , 10 => 2
                    , 11 => 4
                    , 12 => 18
                    , 13 => 20
                    , 14 => 11
                    , 15 => 3
                    , 16 => 6
                    , 17 => 8
                    , 18 => 12
                    , 19 => 14
                    , 20 => 16
                    , 21 => 10
                    , 22 => 22
                    , 23 => 25
                    , 24 => 24
                    , 25 => 23
            };
            String cfp = CF.substring( 0, CF.length( ) - 1 );
            String checkDigit = CF.substring( CF.length( ) - 1, cf.length( ) );


            List<String> lettere = new List<String> {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
            List<String> vocali = new List<String> {'A', 'E', 'I', 'O', 'U'};
            Integer ritorno;
            Integer sommatoria = 0;


            for ( Integer i = 0; i < cfp.length( ); i++ )
            {
                if ( Math.mod( i, 2 ) != 0 )
                {
                    Pattern isnumbers = Pattern.Compile( '^[0-9]+$' );
                    Matcher numberMatch = isnumbers.matcher( cfp.substring( i, i + 1 ) );
                    if ( !numberMatch.Matches( ) )
                    {
                        Integer trovato = 0;
                        for ( Integer j = 0; j < lettere.size( ) && trovato == 0; j++ )
                            if ( lettere[ j ] == cfp.substring( i, i + 1 ) )
                            {
                                sommatoria += j;
                                trovato = 1;
                            }//ifF
                    }//se è una lettera
                    else
                    {
                        sommatoria += Integer.valueOf( cfp.substring( i, i + 1 ) ) * 1;
                    }//se è un numero
                }//pari
                else
                {
                    Integer tmp = 0;

                    Pattern isnumbers = Pattern.Compile( '^[0-9]+$' );
                    Matcher numberMatch = isnumbers.matcher( cfp.substring( i, i + 1 ) );
                    if ( !numberMatch.Matches( ) )
                    {
                        integer trovato = 0;
                        for ( Integer j = 0; j < lettere.size( ) && trovato == 0; j++ )
                            if ( lettere[ j ] == cfp.substring( i, i + 1 ) )
                            {
                                tmp = j;
                                trovato = 1;
                            }//if
                    }//se è una lettera
                    else
                    {
                        tmp = integer.valueOf( cfp.substring( i, i + 1 ) ) * 1;
                    }//se è un numero
                    sommatoria += conversione.get( tmp );
                }//dispari
            }//for

            ritorno = ( Math.mod( sommatoria, 26 ) );

            String ritornoDigit = lettere[ ritorno ];
            system.debug( 'ritornoDigit: ' + ritornoDigit + ' |checkDigit: ' + checkDigit );

            return ritornoDigit == checkDigit;

        } catch ( Exception ecc )
        {
            System.debug( 'Generic Error: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
            return null;
        }
    }

    /*******************************************************************************
    Purpose:  Method cancel log request. Exceptions will be caught on front end side
    Parameters: List<OB_LogRequest__c> inNewLogRequests,
            List<OB_LogRequest__c> inChangedLogRequests,List<OB_LogRequest__c> inDeletedLogRequests
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       03/06/2019      Created         NEXI-58
    ********************************************************************************/
    @AuraEnabled
    public static Boolean cancelLogRequest
            (
                    List<Id> inNewLogRequests,
                    List<Id> inChangedLogRequests,
                    List<Id> inDeletedLogRequests
            )
    {
        try
        {
            Set<Id> conversionSet = new Set<Id>( inNewLogRequests );
            inNewLogRequests = new List<Id>( conversionSet );
            conversionSet = new Set<Id>( inChangedLogRequests );
            inChangedLogRequests = new List<Id>( conversionSet );
            conversionSet = new Set<Id>( inDeletedLogRequests );
            inDeletedLogRequests = new List<Id>( conversionSet );
            List<OB_LogRequest__c> oneListToHaveThemAll = new List<OB_LogRequest__c>( );
            for ( Id loopId : inNewLogRequests )
            {
                oneListToHaveThemAll.add( new OB_LogRequest__c( Id = loopId, OB_Status__c = OB_UtilityConstants.RIFIUTATO ) );
            }
            for ( Id loopId : inChangedLogRequests )
            {
                oneListToHaveThemAll.add( new OB_LogRequest__c( Id = loopId, OB_Status__c = OB_UtilityConstants.RIFIUTATO ) );
            }
            for ( Id loopId : inDeletedLogRequests )
            {
                oneListToHaveThemAll.add( new OB_LogRequest__c( Id = loopId, OB_Status__c = OB_UtilityConstants.RIFIUTATO ) );
            }
            update oneListToHaveThemAll;
        } catch ( Exception ex )
        {
            System.debug( LoggingLevel.ERROR, '[EXC] Exception ' + ex.getMessage( ) + ' stacktrace ' + ex.getStackTraceString( ) );
            return false;
        }
        return true;
    }

    /*******************************************************************************
    Purpose:  Method overloads startApprovalProcess (call start approval process)
    Parameters: Id inLogRequestId
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       12/06/2019      Created         NEXI-60
    ********************************************************************************/
    @AuraEnabled
    public static void startApprovalProcess( Id inLogRequestId )
    {
        startApprovalProcess( inLogRequestId, true );
    }

    /*******************************************************************************
    Purpose:  Method start approval process if required
    Parameters: Id inLogRequestId,
            Boolean inIsInsert
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       12/06/2019      Created         NEXI-60
    ********************************************************************************/
    @AuraEnabled
    public static void startApprovalProcess( Id inLogRequestId, Boolean inIsInsert )
    {
        if ( inLogRequestId == null || inIsInsert == null )
        {
            return ;
        }
        //NEXI-204 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 22/07/2019 Start
        if ( inIsInsert )
        {
            if ( !OB_Util009_Gianos.callToGianos( inLogRequestId, true ) )
            {
                System.debug( LoggingLevel.ERROR, '[EXC] OB_Maintenance_EditAccount_Controller.startApprovalProcess Gianos integration error' );
                throw new OB_Util009_Gianos.GianosException( Label.OB_ServerLogicFailed );
            }
        }
        //NEXI-204 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 22/07/2019 Stop

        OB_Util006_MaintenanceAnagrafica.startMaintenanceApprovalProcessIfNeeded( new List<Id> {inLogRequestId}, OB_Util006_MaintenanceAnagrafica.MAINTENANCE_TYPE_TITOLARI_EFFETTTIVI );

        List<OB_LogRequest__c> logRequests = [ SELECT OB_Status__c FROM OB_LogRequest__c WHERE Id = :inLogRequestId ];
        if ( !logRequests.isEmpty( ) && OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT.equalsIgnoreCase( logRequests.get( 0 ).OB_Status__c ) )
        {
            logRequests.get( 0 ).OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA;
            update logRequests;
        }
    }

    /*******************************************************************************
    Purpose:  Class is wrapper that is send to component after LogRequest inserting

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       18/06/2019      Created         NEXI-60
    ********************************************************************************/
    public class LogRequestWrapper
    {
        @AuraEnabled
        public Id logRequestId;
        @AuraEnabled
        public Boolean isError = false;
        @AuraEnabled
        public String errorMessage;
    }

    /*******************************************************************************
    Purpose: Method creates sourceMap and calls method to create LogRequest
    Parameters: List<Contact> inOldContacts, List<Contact> inNewContacts, Id inAccountId, Boolean inIsEditOrUpdate
    Returns: LogRequestWrapper

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       13/06/2019      Created         NEXI-60
    1.0         Adrian Dlugolecki       04/09/2019      Created         NEXI-289
    ********************************************************************************/
    @AuraEnabled
    public static LogRequestWrapper createLogRequest( List<Contact> inOldContacts, List<Contact> inNewContacts, Id inAccountId, Boolean inIsEditOrUpdate, Boolean inIsPep )
    {
        LogRequestWrapper logRequestWrapper = new LogRequestWrapper( );
        Savepoint sSavePoint = Database.setSavepoint( );
        try
        {
            if ( inOldContacts.isEmpty( ) || inNewContacts.isEmpty( ) )
            {
                logRequestWrapper.isError = true;
                logRequestWrapper.errorMessage = 'Empty IN list';
                return logRequestWrapper;
            }
            //NEXI-289 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 04/09/2019 START
            Boolean isPep = inIsPep == null ? false : inIsPep;
            //NEXI-289 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 04/09/2019 Sop

            List<User> listOfUsers =
            [
                    SELECT Id,
                            Profile.Userlicense.Name,
                            OB_CAB__c,
                            Contact.Account.OB_ABI__c
                    FROM User
                    WHERE Id = :UserInfo.getUserId( )
                    LIMIT 1
            ];

            Map<String, String> sourceMap = new Map<String, String>( );
            sourceMap.put( 'OB_AccountId__c', inAccountId );
            sourceMap.put( 'OB_ServicePointId__c', null );

            List<sObject> newList = new List<sObject>( );
            newList.addAll( inNewContacts );
            Map<String, List<Sobject>> newDataMap = new Map<String, List<Sobject>>( );
            newDataMap.put( 'obj', newList );
            sourceMap.put( 'OB_ReducedNewData__c', JSON.serialize( newDataMap ) );

            List<sObject> oldList = new List<sObject>( );
            oldList.addAll( inOldContacts );
            Map<String, List<Sobject>> oldDataMap = new Map<String, List<Sobject>>( );
            oldDataMap.put( 'obj', oldList );
            sourceMap.put( 'OB_ReducedOldData__c', JSON.serialize( oldDataMap ) );

            sourceMap.put( 'OB_ChangeCompanyData__c', 'false' );
            sourceMap.put( 'OB_ChangeLegalForm__c', 'false' );
            sourceMap.put( 'OB_ChangeLegalRepresentative__c', 'false' );
            sourceMap.put( 'OB_ChangeMerchantName__c', 'false' );
            sourceMap.put( 'OB_ChangeServicePointData__c', 'false' );
            sourceMap.put( 'OB_NewLegalRepresentative__c', 'false' );
            sourceMap.put( 'OB_CAB__c', listOfUsers.get( 0 ).OB_CAB__c );
            sourceMap.put( 'OB_ABI__c', listOfUsers.get( 0 ).Profile.Userlicense.Name == Label.OB_License_PartnerCommunity ? listOfUsers.get( 0 ).Contact.Account.OB_ABI__c : null );
            sourceMap.put( 'OB_MaintenanceType__c', OB_UtilityConstants.ANAGRAFICA );
            sourceMap.put( 'OB_Status__c', inIsEditOrUpdate ? OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT : OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA );
            sourceMap.put( 'OB_SIAToBeApproved__c', 'false' );
            //simone.misani - 17/12/2019 - PERF-67
            sourceMap.put( 'OB_isNotIntegrated__c', 'true' );
            sourceMap.put( 'OB_Change_of_data_of_beneficial_owners__c', 'true' );
            sourceMap.put( 'OB_PEP__c', isPep ? 'true' : 'false' );

            OB_LogRequest__c logRequest = OB_Utility.insertLogRequest( sourceMap );
            //NEXI-204 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 22/07/2019 Start
            logRequestWrapper.logRequestId = logRequest.Id;
            logRequestWrapper.isError = logRequest.Id != null ? false : true;
            //NEXI-204 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 22/07/2019 Stop
        } catch ( Exception ex )
        {
            Database.rollback( sSavePoint );
            String errorMessage = '[EXC] Exception ' + ex.getMessage( ) + ' stacktrace ' + ex.getStackTraceString( );
            System.debug( LoggingLevel.ERROR, errorMessage );
            logRequestWrapper.isError = true;
            logRequestWrapper.errorMessage = errorMessage;
        }

        return logRequestWrapper;
    }

    /*******************************************************************************
    Purpose:  Class is wrapper that is send to component to set empty contact properly

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       20/06/2019      Created         NEXI-60
    1.1         Joanna Mielczarek       26/06/2019      Modified        NEXI-127 add bankId
    ********************************************************************************/
    public class DataWrapper
    {
        @AuraEnabled
        public Boolean hasLogRequest;
        @AuraEnabled
        public String contactRecordTypeId;
        @AuraEnabled
        public String bankId;
    }

    /*******************************************************************************
    Purpose: Method returns Record Type Id - Titolare Effettivo
    Parameters: -
    Returns: Id

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       20/06/2019      Created         NEXI-60
    1.1         Joanna Mielczarek       26/06/2019      Modified        NEXI-127 add bankId
    ********************************************************************************/
    @AuraEnabled
    public static DataWrapper getInitDataWrapper( String inAccountId )
    {
        DataWrapper result = new DataWrapper( );
        result.hasLogRequest = false;
        result.contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.TITOLARE_EFFETTIVO ).getRecordTypeId( );

        if ( !String.isEmpty( inAccountId ) )
        {
            List<OB_LogRequest__c> logRequests =
            [
                    SELECT Id
                    FROM OB_LogRequest__c
                    WHERE OB_AccountId__c = :inAccountId
                    AND RecordTypeId = :OB_LogRequestTriggerHandler.MAINTENANCE_ANAGRAFICA_RECORD_TYPE
                    AND ( OB_Status__c = :OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA OR OB_Status__c = :OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT )
                    AND OB_Change_of_data_of_beneficial_owners__c = true
                    LIMIT 1
            ];
            result.hasLogRequest = !logRequests.isEmpty( );
        }

        // NEXI-127 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 26.06.2019 START
        List<User> users =
        [
                SELECT Contact.AccountId
                FROM User
                WHERE Id = :UserInfo.getUserId( )
                LIMIT 1
        ];
        result.bankId = users.get( 0 ).Contact.AccountId;
        // NEXI-127 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 26.06.2019 STOP

        return result;
    }

    /*****************************************************************
	Purpose: Calls method to submit Maintenance Anagrafica
	Parameters: String id of Log Request

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0 	    Salvatore Pianura 	    10/05/2019 	    Created 	    CSR:
	1.1         Joanna Mielczarek       03/09/2019      Modified        NEXI-295 refactored method, added starting approval process
	1.2         Joanna Mielczarek       12/09/2019      Modified        NEXI-325 added fields which starts approval process
	1.3         Adrian Dlugolecki       17/09/2019      Changed        NEXI-329 revert to version 1.0
	*****************************************************************/
    @AuraEnabled
    public static Id callSerializeAnagrafica( String logRequestId )
    {
        System.debug( LoggingLevel.FINE, 'OB_Maintenance_EditAccount_Controller.callSerializeAnagrafica Start ' + logRequestId );

        List<OB_LogRequest__c> listOfLogRequest =
        [
                SELECT Id,
                        OB_SIAToBeApproved__c,
                        OB_EquensMoneticaToBeApproved__c
                FROM OB_LogRequest__c
                WHERE Id = :logRequestId
                LIMIT 1
        ];
        if ( listOfLogRequest.isEmpty( ) )
        {
            return null;
        }
        OB_LogRequest__c currentLogRequest = listOfLogRequest.get( 0 );
        if ( !currentLogRequest.OB_SIAToBeApproved__c && !currentLogRequest.OB_EquensMoneticaToBeApproved__c )
        {
            OB_Utility.serializeAnagrafica( logRequestId );
        }
        else
        {
            currentLogRequest.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA;
            update currentLogRequest;
        }
        return currentLogRequest.id;
    }

    /*******************************************************************************
    Purpose:  Method to check if executors fiscal code and account fiscal code are the same,
                in case there is need for such check (if legal form is within given picklist).
                If there is error method adds the error message to the map, used for displaying
                error on front-end side
    Parameters: Map<String, String> mandatoryValidationCheck,
                Map<String, Object> objDataMap,
                String(JSON) newData
    Returns:  Map<String, String> mandatoryValidationCheck
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            03/07/2019      Created         NEXI-125
    ********************************************************************************/
    @testVisible
    private static Map<String, String> checkValidationFC( Map<String, String> mandatoryValidationCheck, Map<String, Object> objDataMap, String newData )
    {
        Object accObject = objDataMap.get( 'acc' );
        try
        {
            Account relatedAccount = ( Account ) JSON.deserialize( JSON.serialize( accObject ), Account.class );
            Contact contactToValidate = ( Contact ) JSON.deserialize( newData, Contact.class );

            if ( relatedAccount == null || contactToValidate == null )
            {
                System.debug( LoggingLevel.FINE, 'OB_Maintenance_EditAccount_Controller.checkValidationFC: No contact or account for check' );
                return mandatoryValidationCheck;
            }
            String legalForm = relatedAccount.OB_Legal_Form__c;
            if ( !mandatoryValidationCheck.containsKey( 'fiscalCodelegaleRapp' ) && isFCCompatibilityCheckRequired( legalForm )
                    && ( contactToValidate.OB_Fiscal_Code__c != relatedAccount.NE__Fiscal_code__c ) )
            {
                mandatoryValidationCheck.put( 'fiscalCodelegaleRapp', Label.OB_MAINTENANCE_EXECUTOR_FC_NOT_VALID );
            }
        } catch ( Exception ex )
        {
            System.debug( LoggingLevel.ERROR, 'OB_Maintenance_EditAccount_Controller.checkValidationFC error: ' + ex.getMessage( ) + 'Stack trace: ' + ex.getStackTraceString( ) );
            return mandatoryValidationCheck;
        }
        return mandatoryValidationCheck;
    }

    /*******************************************************************************
    Purpose:  Method to check if account legal form require the fiscal code check against the contact fiscal code
    Parameters: String accountLegalForm
    Returns: Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            27/06/2019      Created         NEXI-125
    ********************************************************************************/
    private static Boolean isFCCompatibilityCheckRequired( String accountLegalForm )
    {
        if ( String.isBlank( accountLegalForm ) )
        {
            System.debug( LoggingLevel.FINE, 'OB_Maintenance_EditAccount_Controller.isFCCompatibilityCheckRequired: Empty accountLegalForm ' );
            return false;
        }

        Set<String> legalFormsRequiringCheck = new Set<String>
        {
                OB_UtilityConstants.DITTA_INDIVIDUALE.toLowerCase( ),
                OB_UtilityConstants.LIBERO_PROFESSIONISTA.toLowerCase( ),
                OB_UtilityConstants.LAVORATORE_AUTONOMO.toLowerCase( ),
                OB_UtilityConstants.IMPRENDITORE_INDIVIDUALE_AGRICOLO.toLowerCase( ),
                OB_UtilityConstants.IMPRENDITORE_INDIVIDUALE_NON_AGRICOLO.toLowerCase( )
        };

        return legalFormsRequiringCheck.contains( accountLegalForm.toLowerCase( ) ) ? true : false;
    }
    //Start antonio.vatrano 17/07/2019 logic to show BTN Upload documents
    @AuraEnabled
    public static void confirmDocs( String logId )
    {
        String toReturn = '@@@ update Draft';
        try
        {
            OB_LogRequest__c logrequest = [ select id,OB_Status__c, OB_Save_as_Draft__c from OB_LogRequest__c where id = :logId limit 1 ];
            //simone.misani - 17/12/2019 - PERF-67 - START
            Boolean isLock = Approval.isLocked( logrequest.Id );
            if(logrequest.OB_Save_as_Draft__c){
                logrequest.OB_Save_as_Draft__c = false;
                update logrequest;
            }
            //simone.misani - 17/12/2019 - PERF-67 - END
        } catch ( Exception e )
        {
            toReturn = '@@@ not update Draft';
        }
        System.debug( toReturn );
    }
    //End antonio.vatrano 17/07/2019 logic to show BTN Upload documents

    /*******************************************************************************
    Purpose:  Method to retrieve External Source Mapping for specyfic Account
    Parameters: String merchantId
    Returns: InitialRendicontazoneWrapper

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Zuzanna Urban          	09/07/2019      Created         NEXI-186
    ********************************************************************************/
    @AuraEnabled
    public static InitialRendicontazoneWrapper retrieveExternalSourceMapping( String merchantId )
    {
        InitialRendicontazoneWrapper resultToReturn = new InitialRendicontazoneWrapper( );
        if ( String.isBlank( merchantId ) )
        {
            return resultToReturn;
        }
        List<String> pickListValuesList = new List<String>( );
        Schema.DescribeFieldResult fieldResult = ExternalSourceMapping__c.OB_ReportType__c.getDescribe( );
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues( );
        for ( Schema.PicklistEntry pickListVal : ple )
        {
            pickListValuesList.add( pickListVal.getLabel( ) );
        }
        resultToReturn.picklistValues = pickListValuesList;
        List<Asset> assetNotDisconnected =
        [
                SELECT Id
                FROM Asset
                WHERE AccountId = :merchantId
                AND NE__Status__c != :OB_UtilityConstants.ASSET_STATUS_DISCONNECTED
        ];
        if ( assetNotDisconnected.size( ) > 0 )
        {
            List<ExternalSourceMapping__c> esmListToReturn =
            [
                    SELECT Id,
                            OB_Source__c,
                            OB_ServicePointCodeShopCode__c,
                            OB_CustomerCodeClientCode__c,//NEXI-187 Grzegorz Banach <grzegorz.banach@accenture.com> 22.07.2019
                            OB_ReportType__c
                    FROM ExternalSourceMapping__c
                    WHERE OB_Merchant_ID__c = :merchantId
                    AND OB_Source__c IN ( :OB_UtilityConstants.EQUENS, :OB_UtilityConstants.SIA )
            ];

            if ( esmListToReturn.size( ) > 0 )
            {
                resultToReturn.listESM = esmListToReturn;
            }
        }
        return resultToReturn;
    }

    /*******************************************************************************
    Purpose:  Method check changes for ESM and returns new ESM list
    Parameters: String newReportTypeValue, List<ExternalSourceMapping__c> oldESMList, List<ExternalSourceMapping__c> changedESMlist
    Returns: List<ExternalSourceMapping__c>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Zuzanna Urban          	11/07/2019      Created         NEXI-186
    ********************************************************************************/
    @AuraEnabled
    public static List<ExternalSourceMapping__c> getNewESMList( String newReportTypeValue, List<ExternalSourceMapping__c> oldESMList, List<ExternalSourceMapping__c> changedESMlist )
    {
        List<ExternalSourceMapping__c> esmListToReturn = new List<ExternalSourceMapping__c>( );
        if ( String.isBlank( newReportTypeValue ) || oldESMList.size( ) == 0 || changedESMlist.size( ) == 0 )
        {
            return esmListToReturn;
        }
        List<Id> idESMChanged = new List<Id>( );
        for ( ExternalSourceMapping__c oneChangedESM : changedESMlist )
        {
            idESMChanged.add( oneChangedESM.Id );
        }
        List<String> oldReportValues = new List<String>( );
        Integer reportValues = 0;
        for ( ExternalSourceMapping__c oneOldESMToChange : oldESMList )
        {
            for ( Id oneIdESMChanged : idESMChanged )
            {
                if ( oneOldESMToChange.Id == oneIdESMChanged )
                {
                    oldReportValues.add( oneOldESMToChange.OB_ReportType__c );
                    reportValues++;
                }
            }
        }
        Integer theSameReportValues = 0;
        for ( String oldReportValue : oldReportValues )
        {
            if ( String.isNotBlank( oldReportValue ) && oldReportValue.equals( newReportTypeValue ) )
            {
                theSameReportValues++;
            }
        }
        if ( reportValues == theSameReportValues )
        {
            return null;
        }
        for ( ExternalSourceMapping__c oneOldESMToChange : oldESMList )
        {
            for ( Id oneIdESMChanged : idESMChanged )
            {
                if ( oneOldESMToChange.Id == oneIdESMChanged )
                {
                    oneOldESMToChange.OB_ReportType__c = newReportTypeValue;
                }
            }
            esmListToReturn.add( oneOldESMToChange );
        }
        return esmListToReturn;
    }

    /*
    *   Author  :   Morittu Andrea
    *   Date    :   25-Jul-2019
    *   Task    :   Untracked -> employees number in 'ANAGRAFICA'
    *   Branch :    (Untracked)NewLogicOnEmployeesNumberAnagrafica
    */
    @AuraEnabled
    public static Map<String, String> getEmployeesNumber( )
    {
        Map<String, String> pickListValuesList = new Map<String, String>( );
        try
        {
            Schema.DescribeFieldResult fieldResult = Account.OB_Employees_Number__c.getDescribe( );
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues( );

            for ( Schema.PicklistEntry pickListVal : ple )
            {
                pickListValuesList.put( pickListVal.getValue( ), pickListVal.getLabel( ) );
                system.debug( 'pickListValuesList employees numbers: ' + pickListValuesList );
            }

        } catch ( Exception exc )
        {
            pickListValuesList.put( 'Error on server', 'No picklist values found' );
        }
        return pickListValuesList;
    }

    /*******************************************************************************
    Purpose:  Method detects special category for reported sae / ateco and return values of special fields
    Parameters: String inSAE, String inATECO, String inLegalForm
    Returns: Map<String, String>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       03/09/2019      Created         NEXI-295
    1.1         Joanna Mielczarek       12/09/2019      Modified        NEXI-324 removed unnecessary 'else's
    1.2         Joanna Mielczarek       12/09/2019      Modified        NEXI-325 added logic to handle legal form change
    ********************************************************************************/
    private static Map<String, String> putSpecialCategoriesFields( String inSAE, String inATECO, String inLegalFormCode )
    {
        System.debug( LoggingLevel.FINE, 'OB_Maintenance_EditAccount_Controller.putSpecialCategoriesFields sae : ' +
                inSAE + ' ateco ' + inATECO + ' legal form code ' + inLegalFormCode );

        String trueValue = 'true';
        Map<String, String> specialCategoriesByFields = new Map<String, String>( );
        if ( !String.isBlank( inSAE ) && OB_UtilityConstants.SAE_FIDUCIARE_LIST.contains( inSAE ) )
        {
            specialCategoriesByFields.put( 'OB_Fiduciarie__c', trueValue );
        }
        if ( !String.isBlank( inATECO ) )
        {
            if ( OB_UtilityConstants.ATECO_FIDUCIARE_LIST.contains( inATECO ) )
            {
                specialCategoriesByFields.put( 'OB_Fiduciarie__c', trueValue );
            }
            if ( OB_UtilityConstants.ATECO_GAMBLING_LIST.contains( inATECO ) )
            {
                specialCategoriesByFields.put( 'OB_isGambling__c', trueValue );
            }
            if ( OB_UtilityConstants.ATECO_MONEYTRANSFER_LIST.contains( inATECO ) )
            {
                specialCategoriesByFields.put( 'OB_Moneytransfer__c', trueValue );
            }
        }
        // NEXI-325 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 12/09/2019 START
        if ( !String.isBlank( inLegalFormCode ) )
        {
            if ( OB_UtilityConstants.LEGAL_FORM_CODE_MONEY.equalsIgnoreCase( inLegalFormCode ) )
            {
                specialCategoriesByFields.put( 'OB_Moneytransfer__c', trueValue );
            }
            if ( OB_UtilityConstants.LEGAL_FORM_CODE_TRUST.equalsIgnoreCase( inLegalFormCode ) )
            {
                specialCategoriesByFields.put( 'OB_Trust__c', trueValue );
            }
            if ( OB_UtilityConstants.LEGAL_FORM_CODE_NO_PROFIT.equalsIgnoreCase( inLegalFormCode ) )
            {
                specialCategoriesByFields.put( 'OB_Onlus__c', trueValue );
            }
        }
        // NEXI-325 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 12/09/2019 STOP
        System.debug( LoggingLevel.FINE, 'OB_Maintenance_EditAccount_Controller.putSpecialCategoriesFields returns map : ' + specialCategoriesByFields );

        return specialCategoriesByFields;
    }

    /*******************************************************************************
    Purpose:  Method starts approval process for Log Request with special category and call avaros
    Parameters: Id inLogRequestId
    Returns: Id

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       03/09/2019      Created         NEXI-295
    1.1         Adrian Dlugolecki       16/09/2019      Changed         NEXI-329 complete refactor
    ********************************************************************************/
    @AuraEnabled
    public static Id startApprovalProcessForSaeAteco( Id inLogRequestId )
    {
        System.debug( LoggingLevel.FINE, 'OB_Maintenance_EditAccount_Controller.startApprovalProcessForSaeAteco Id : ' + inLogRequestId );
        OB_LogRequest__c logRequestToCheck =
        [
                SELECT OB_ApprovalStep__c,
                        OB_PEP__c,
                        OB_Gianos__c,
                        OB_isGambling__c,
                        OB_Fiduciarie__c,
                        OB_Onlus__c,
                        OB_Moneytransfer__c,
                        OB_Trust__c,
                        OB_Crowdfunding__c,
                        OB_PO118_eCommerce__c,
                        OB_PO118_MOTO__c,
                        OB_isBlackList__c,
                        OB_StartApprovalProcess__c,
                        OB_AccountId__c
                FROM OB_LogRequest__c
                WHERE Id = :inLogRequestId
        ];
        System.debug( LoggingLevel.FINE, 'OB_Maintenance_EditAccount_Controller.startApprovalProcessForSaeAteco log request : ' + logRequestToCheck );
        if ( OB_Utility.checkStepsEntryCriteriaLogRequest( logRequestToCheck ) )
        {
            OB_Util009_AVRSOS.calloutAVRSOS( logRequestToCheck.OB_AccountId__c, logRequestToCheck.id, OB_UtilityConstants.MAINTENANCE ); //NEXI-329 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 16/09/2019
            Approval.ProcessSubmitRequest approvalProcessToStart = new Approval.ProcessSubmitRequest( );
            approvalProcessToStart.setComments( 'Submitting request for approval.' );
            approvalProcessToStart.setObjectId( inLogRequestId );
            approvalProcessToStart.setSubmitterId( UserInfo.getUserId( ) );
            approvalProcessToStart.setProcessDefinitionNameOrId( Label.OB_MAINTENANCE_APPROVALPROCESS );
            approvalProcessToStart.setSkipEntryCriteria( false );
            Approval.ProcessResult resultOfApprovalProcess = Approval.process( approvalProcessToStart, false );
            System.debug( LoggingLevel.FINE, 'OB_Maintenance_EditAccount_Controller.startApprovalProcess result: ' + resultOfApprovalProcess );
        }
        System.debug( LoggingLevel.FINE, 'OB_Maintenance_EditAccount_Controller.startApprovalProcess Stop ' );
        return logRequestToCheck.id;
    }

    /*******************************************************************************
    Purpose:  Method calls OB_Maintenance.updateLogRequestStatus
    Parameters: String inLogRequestId
    Returns: -
    Throwable: Use it only inside try catch

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien          07/09/2019      Created         NEXI-298
    1.1         Adrian Dlugolecki       17/09/2019      Changed         NEXI-329
    1.2         Marta Stempien          10/10/2019      Modified        NEXI-365
    ********************************************************************************/
    @AuraEnabled
    public static void updateChangedSaeAtecoLogRequestStatusToInAttesa( String inLogRequestId )
    {
        System.debug( LoggingLevel.FINE, 'OB_Maintenance_EditAccount_Controller.updateChangedSaeAtecoLogRequestStatusToInAttesa Start : ' + inLogRequestId );
        OB_LogRequest__c logRequestToUpdate =
        [
                SELECT Id,
                        OB_ApprovalStep__c,
                        OB_PEP__c,
                        OB_Gianos__c,
                        OB_isGambling__c,
                        OB_Fiduciarie__c,
                        OB_Onlus__c,
                        OB_Moneytransfer__c,
                        OB_Trust__c,
                        OB_Crowdfunding__c,
                        OB_PO118_eCommerce__c,
                        OB_PO118_MOTO__c,
                        OB_isBlackList__c,
                        OB_StartApprovalProcess__c,
                        OB_AccountId__c,
                        OB_isNotIntegrated__c, // NEXI-365 Marta Stempien <marta.stempien@accenture.com> 10/10/2019 Added OB_isNotIntegrated__c and OB_Status__c to Query
                        OB_Status__c
                FROM OB_LogRequest__c
                WHERE Id = :inLogRequestId
        ];
        System.debug( LoggingLevel.FINE, 'OB_Maintenance_EditAccount_Controller.updateChangedSaeAtecoLogRequestStatusToInAttesa log request : ' + logRequestToUpdate );
        if ( !OB_Utility.checkStepsEntryCriteriaLogRequest( logRequestToUpdate ) )
        {
            //NEXI-365 Marta Stempien <marta.stempien@accenture.com> 10/10/2019 Start
            if(logRequestToUpdate.OB_isNotIntegrated__c && !OB_UtilityConstants.LOGREQUEST_STATUS_CONFERMATO.equalsIgnoreCase( logRequestToUpdate.OB_Status__c ))
            {
                logRequestToUpdate.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA;
                System.debug( LoggingLevel.FINE, 'OB_Maintenance_EditAccount_Controller.updateChangedSaeAtecoLogRequestStatusToInAttesa log request to ' + OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA );
                update logRequestToUpdate;
            }
            //NEXI-365 Marta Stempien <marta.stempien@accenture.com> 10/10/2019 Stop
        }

        else
        {
            System.debug( LoggingLevel.FINE, 'OB_Maintenance_EditAccount_Controller.updateChangedSaeAtecoLogRequestStatusToInAttesa log request to AVRSOS and approval' );
            OB_Util009_AVRSOS.calloutAVRSOS( logRequestToUpdate.OB_AccountId__c, logRequestToUpdate.id, OB_UtilityConstants.MAINTENANCE ); //NEXI-329 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 16/09/2019
            Approval.ProcessSubmitRequest approvalProcessToStart = new Approval.ProcessSubmitRequest( );
            approvalProcessToStart.setComments( 'Submitting request for approval.' );
            approvalProcessToStart.setObjectId( inLogRequestId );
            approvalProcessToStart.setSubmitterId( UserInfo.getUserId( ) );
            approvalProcessToStart.setProcessDefinitionNameOrId( Label.OB_MAINTENANCE_APPROVALPROCESS );
            approvalProcessToStart.setSkipEntryCriteria( false );
            Approval.ProcessResult resultOfApprovalProcess = Approval.process( approvalProcessToStart, false );
            System.debug( LoggingLevel.FINE, 'OB_Maintenance_EditAccount_Controller.updateChangedSaeAtecoLogRequestStatusToInAttesa result: ' + resultOfApprovalProcess );
        }
        System.debug( LoggingLevel.FINE, 'OB_Maintenance_EditAccount_Controller.updateChangedSaeAtecoLogRequestStatusToInAttesa stop ' );
    }

    /*******************************************************************************
Purpose:  Method check existance
Parameters: List<String> oldData, List<String> newData
Returns: -
Throwable: Use it only inside try catch

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         Elena PReteni           10/09/2019      Created
********************************************************************************/
    @AuraEnabled
    public static void checkExistance( List<String> oldData, List<String> newData )
    {
        //elena.preteni 11/09/19 adding try catch
        //NEXI-298 Marta Stempien <marta.stempien@accenture.com> 13/09/2019 Start
        OB_Maintenance_Helper.CheckboxesWrapper checkboxFields = new OB_Maintenance_Helper.CheckboxesWrapper( );
        Map<String, String> sourceMap = new Map<String, String>( );
        Id accountId;
        //NEXI-298 Marta Stempien <marta.stempien@accenture.com> 13/09/2019 Stop
        try
        {
            EditAccountSimple simpleOld = ( EditAccountSimple ) JSON.deserialize( oldData.get( 0 ), EditAccountSimple.class );
            EditAccountSimple simpleNew = ( EditAccountSimple ) JSON.deserialize( newData.get( 0 ), EditAccountSimple.class );
            accountId = simpleNew.account.Id; //NEXI-298 Marta Stempien <marta.stempien@accenture.com> 13/09/2019
            Map<SObject, SObject> mapDifference = new map<SObject, SObject>( );
            mapDifference.put( simpleOld.account, simpleNew.account );
            if ( simpleOld.contact != null && simpleNew.contact != null )
            {
                mapDifference.put( simpleOld.contact, simpleNew.contact );
            }
            if ( simpleOld.externalSourceMappings != null && !simpleOld.externalSourceMappings.isEmpty( ) )
            {
                for ( ExternalSourceMapping__c oldExtSource : simpleOld.externalSourceMappings )
                {
                    for ( ExternalSourceMapping__c newExtSource : simpleNew.externalSourceMappings )
                    {
                        if ( oldExtSource.id == newExtSource.id )
                        {
                            mapDifference.put( oldExtSource, newExtSource );
                        }
                    }
                }
            }
            OB_Maintenance_Helper.serializeObject reducedOldData = new OB_Maintenance_Helper.serializeObject( );
            OB_Maintenance_Helper.serializeObject reducedNewData = new OB_Maintenance_Helper.serializeObject( );
            OB_Maintenance_Helper.generateDifferenceObject( mapDifference, reducedOldData, reducedNewData, checkboxFields );
        }
        //NEXI-298 Marta Stempien <marta.stempien@accenture.com> 13/09/2019 Moved catch up to exclude thrown LogRequestExistsException
        catch ( Exception ex )
        {
            System.debug( LoggingLevel.ERROR, '[EXC] Exception ' + ex.getMessage( ) + ' stacktrace ' + ex.getStackTraceString( ) );
        }
        if ( checkboxFields.isSuccess )
        {
            sourceMap.put( 'OB_ChangeCompanyData__c', ( checkboxFields.newLegalRepresentative || checkboxFields.changeLegalRepresentative ) ? String.valueOf( false ) : String.valueOf( true ) );
            sourceMap.put( 'OB_ChangeLegalForm__c', String.valueOf( checkboxFields.changeLegalForm ) );
            sourceMap.put( 'OB_ChangeLegalRepresentative__c', String.valueOf( checkboxFields.changeLegalRepresentative ) );
            sourceMap.put( 'OB_ChangeMerchantName__c', String.valueOf( checkboxFields.changeMerchantName ) );
            sourceMap.put( 'OB_ChangeServicePointData__c', String.valueOf( checkboxFields.changeServicePointData ) );
            sourceMap.put( 'OB_change_of_reporting_type__c', String.valueOf( checkboxFields.changeReportType ) );
            sourceMap.put( 'OB_NewLegalRepresentative__c', String.valueOf( checkboxFields.newLegalRepresentative ) );
            sourceMap.put( 'OB_AccountId__c', accountId );
            Map<String, String> requestAlreadyExist = OB_Maintenance_Helper.CheckRequestAlreadyExist( sourceMap );

            if ( requestAlreadyExist.get( 'message' ) != null )
            {
                throw new LogRequestExistsException( requestAlreadyExist.get( 'message' ) );
            }
        }
        //NEXI-298 Marta Stempien <marta.stempien@accenture.com> 13/09/2019 Catch moved up
    }
}