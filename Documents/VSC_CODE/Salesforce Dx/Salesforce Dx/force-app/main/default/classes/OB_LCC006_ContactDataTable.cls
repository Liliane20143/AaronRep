/*******************************************************************************
Purpose:  Class is controller for OB_LCP006_ContactDataTable
Parameters: -
Returns: -

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         Adrian Dlugolecki       28/05/2019      Created         NEXI-57
********************************************************************************/

global with sharing class OB_LCC006_ContactDataTable
{
    public static final String rtTitolariEffettivi = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( 'Titolare_Effettivo' ).getRecordTypeId( );
    public static final String ACTION_TYPE_NONE = 'none';
    public static final String ACTION_TYPE_MODIFICA = 'Modificato';
    public static final String ACTION_TYPE_ELIMINATO = 'Eliminato';
    public static final String ACTION_TYPE_INSERITO = 'Inserito';

    /*******************************************************************************
    Purpose:  Class is wrapper that is send to component as init result

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       28/05/2019      Created         NEXI-57
    2.0         Joanna Mielczarek       14/06/2019      Modified        NEXI-60 changed list to simple object - Log Request
    ********************************************************************************/
    public class DataWrapper
    {
        @AuraEnabled
        public OB_LogRequest__c logRequest;
        @AuraEnabled
        public List<RowDataWrapper> dataTableRows;
        @AuraEnabled
        public Boolean isError = false;
        @AuraEnabled
        public String errorMessage;
    }

    /*******************************************************************************
    Purpose:  Class is wrapper for table row

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       28/05/2019      Created         NEXI-57
    2.0         Joanna Mielczarek       14/06/2019      Modified        NEXI-60 changed fields to lists, added accountId
    ********************************************************************************/
    public class RowDataWrapper
    {
        @AuraEnabled
        public Id accountId;
        @AuraEnabled
        public Contact newContact;
        @AuraEnabled
        public Contact oldContact;
        @AuraEnabled
        public String actionType;
    }

    /*******************************************************************************
    Purpose:  Method returns contacts data for table on component init
    Parameters: String inAccountId
    Returns: DataWrapper

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       28/05/2019      Created         NEXI-57
    2.0         Joanna Mielczarek       14/06/2019      Modified        NEXI-60 changed logic of returned wrapper
    ********************************************************************************/
    @AuraEnabled
    public static DataWrapper retrieveData( String inAccountId )
    {
        System.debug( LoggingLevel.INFO, 'OB_LCC006_ContactDataTable.retrieveData inAccountId ' + inAccountId );

        DataWrapper result = new DataWrapper( );
        result.dataTableRows = new List<RowDataWrapper>( );
        result.logRequest = getLogRequest( inAccountId );

        if ( result.logRequest.Id != null )
        {
            try
            {
                Map<Id, Contact> contactsInUpdate = new Map<Id, Contact>( );
                Map<Id, Contact> contactsToDelete = new Map<Id, Contact>( );
                List<Contact> newContacts;
                List<Contact> oldContacts;
                if ( !String.isEmpty( result.logRequest.OB_ReducedNewData__c ) )
                {
                    Map<String, Object> conversionMap = ( Map<String, Object> ) JSON.deserializeUntyped( result.logRequest.OB_ReducedNewData__c );
                    newContacts = ( List<Contact> ) JSON.deserialize( JSON.serialize( conversionMap.get( 'obj' ) ), List<Contact>.class );
                }
                if ( !String.isEmpty( result.logRequest.OB_ReducedOldData__c ) )
                {
                    Map<String, Object> conversionMap = ( Map<String, Object> ) JSON.deserializeUntyped( result.logRequest.OB_ReducedOldData__c );
                    oldContacts = ( List<Contact> ) JSON.deserialize( JSON.serialize( conversionMap.get( 'obj' ) ), List<Contact>.class );
                }
                result.dataTableRows = getDataTableRowsIfLogRequestExists( inAccountId, newContacts, oldContacts );
            }
            catch ( Exception ex )
            {
                String errorMessage = '[EXC] Exception ' + ex.getMessage( ) + ' stacktrace ' + ex.getStackTraceString( );
                System.debug( LoggingLevel.ERROR, errorMessage );
                result.isError = true;
                result.errorMessage = errorMessage;
            }
            System.debug( LoggingLevel.INFO, 'OB_LCC006_ContactDataTable.retrieveData end ' + result );
            return result;
        }
        result.dataTableRows = getDataTableRowsIfLogRequestDoesntExist( inAccountId );

        System.debug( LoggingLevel.INFO, 'OB_LCC006_ContactDataTable.retrieveData end ' + result );
        return result;
    }

    /*******************************************************************************
    Purpose: Method retrieves LogRequest which fulfills conditions from query
    Parameters: String inAccountId
    Returns: OB_LogRequest__c

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       19/06/2019      Created         NEXI-60
    ********************************************************************************/
    private static OB_LogRequest__c getLogRequest( String inAccountId )
    {
        List<OB_LogRequest__c> logRequests =
        [
                SELECT Id,
                        Name,
                        OB_ReducedOldData__c,
                        OB_ReducedNewData__c,
                        OB_Status__c,
                        OB_ABI__c,
                        OB_AccountId__c,
                        OB_PEP__c,
                        OB_isBlackList__c,
                        OB_ServicePointId__c,
                        OB_StartApprovalProcess__c
                FROM OB_LogRequest__c
                WHERE OB_AccountId__c = :inAccountId
                AND RecordTypeId = :OB_LogRequestTriggerHandler.MAINTENANCE_ANAGRAFICA_RECORD_TYPE
                AND ( OB_Status__c = :OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA OR OB_Status__c = :OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT )
                AND OB_Change_of_data_of_beneficial_owners__c = true
                LIMIT 1
        ];

        if ( !logRequests.isEmpty( ) )
        {
            return logRequests.get( 0 );
        }
        return new OB_LogRequest__c( );
    }

    /*******************************************************************************
    Purpose: Method returns RowDataWrappers depending on existing old/new Id - if LogRequest exists
    Parameters: String inAccountId, List<Contact> inNewContacts, List<Contact> inOldContacts
    Returns: List<RowDataWrapper>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       19/06/2019      Created         NEXI-60
    ********************************************************************************/
    private static List<RowDataWrapper> getDataTableRowsIfLogRequestExists(
            String inAccountId,
            List<Contact> inNewContacts,
            List<Contact> inOldContacts
    )
    {
        List<RowDataWrapper> rowDataWrappers = new List<RowDataWrapper>( );

        for ( Integer i = 0; i < inNewContacts.size( ); i++ )
        {
            RowDataWrapper rowData = new RowDataWrapper( );
            rowData.accountId = ( Id ) inAccountId;

            if ( ( inNewContacts.get( i ).Id == null ) )
            {
                if ( inOldContacts.get( i ).Id != null )
                {
                    rowData.newContact = new Contact( );
                    rowData.oldContact = inOldContacts.get( i );
                    rowData.actionType = ACTION_TYPE_ELIMINATO;
                }
                else
                {
                    rowData.newContact = inNewContacts.get( i );
                    rowData.oldContact = new Contact( );
                    rowData.actionType = ACTION_TYPE_INSERITO;
                }
            }
            else
            {
                rowData.newContact = inNewContacts.get( i );
                rowData.oldContact = inOldContacts.get( i );
                if ( OB_Util006_MaintenanceAnagrafica.checkContactIsAfterModification( inNewContacts.get( i ), inOldContacts.get( i ) ) )
                {
                    rowData.actionType = ACTION_TYPE_MODIFICA;
                }
                else
                {
                    rowData.actionType = ACTION_TYPE_NONE;
                }
            }
            rowDataWrappers.add( rowData );
        }

        return rowDataWrappers;
    }

    /*******************************************************************************
    Purpose: Method returns RowDataWrappers from database which are connected to given AccountId - if LogRequest doesn't exist
    Parameters: String inAccountId
    Returns: List<RowDataWrapper>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/06/2019      Created         NEXI-60
    ********************************************************************************/
    private static List<RowDataWrapper> getDataTableRowsIfLogRequestDoesntExist( String inAccountId )
    {
        List<RowDataWrapper> rowDataWrappers = new List<RowDataWrapper>( );
        for ( Contact loopContact :
        [
                SELECT Id,
                        FirstName,
                        LastName,
                        OB_Fiscal_Code__c,
                        OB_EndDate__c,
                        OB_PEP__c,
                        CreatedDate,
                        OB_Sex__c,
                        OB_Citizenship__c,
                        OB_Address_Country__c,
                        OB_Address_Country_Code__c,
                        OB_Address_State__c,
                        OB_Address_City__c,
                        OB_Address_Street__c,
                        OB_Address_Street_Number__c,
                        OB_Document_Release_State__c,
                        OB_Document_Release_City__c,
                        OB_Birth_State__c,
                        OB_Birth_City__c,
                        OB_Document_Type__c,
                        OB_Country_Birth__c,
                        OB_Country_Birth_Code__c,
                        OB_Birth_Date__c,
                        OB_Document_Number__c,
                        OB_Document_Release_Authority__c,
                        OB_Document_Release_Country__c,
                        OB_Document_Release_Country_Code__c,
                        OB_Document_Release_Date__c,
                        OB_Document_Expiration_Date__c,
                        OB_SkipCadastralCodeCheck__c,  
                        OB_Address_PostalCode__c  
                FROM Contact
                WHERE AccountId = :inAccountId
                AND RecordTypeId = :rtTitolariEffettivi
                ORDER BY OB_EndDate__c
        ] )
        {
            RowDataWrapper rowData = new RowDataWrapper( );
            rowData.accountId = ( Id ) inAccountId;
            rowData.newContact = loopContact;
            rowData.oldContact = loopContact;
            rowData.actionType = ACTION_TYPE_NONE;
            rowDataWrappers.add( rowData );
        }
        return rowDataWrappers;
    }
}