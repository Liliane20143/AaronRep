/*******************************************************************************
Purpose:  Class that is test for OB_LCC006_ContactDataTable
Parameters: -
Returns: -

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         Adrian Dlugolecki       12/06/2019      Created         NEXI-60
********************************************************************************/
@isTest
public with sharing class OB_LCC006_ContactDataTable_Test
{
    /*******************************************************************************
    Purpose:  Method prepares LogRequest to test methods.
    Parameters: Id accountId
    Returns: OB_LogRequest__c

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/06/2019      Created         NEXI-60
    ********************************************************************************/
    private static OB_LogRequest__c coreData( Id accountId )
    {
        OB_LogRequest__c mainLogRequest = new OB_LogRequest__c( );
        mainLogRequest.RecordTypeId = OB_LogRequestTriggerHandler.MAINTENANCE_ANAGRAFICA_RECORD_TYPE;
        mainLogRequest.OB_Change_of_data_of_beneficial_owners__c = true;
        mainLogRequest.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA;
        mainLogRequest.OB_AccountId__c = accountId;

        return mainLogRequest;
    }

    /*******************************************************************************
    Purpose:  Method test OB_LCC006_ContactDataTable.retrieveData. With null parameter
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       12/06/2019      Created         NEXI-60
    1.1         Joanna Mielczarek       17/06/2019      Modified        NEXI-60 updated assertions
    ********************************************************************************/
    @isTest
    private static void retrieveDataNullTest( )
    {
        OB_LCC006_ContactDataTable.DataWrapper result = OB_LCC006_ContactDataTable.retrieveData( null );
        System.assertEquals( new OB_LogRequest__c( ), result.logRequest );
        System.assert( result.dataTableRows.isEmpty( ) );
        System.assert( !result.isError );
        System.assert( String.isBlank( result.errorMessage ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_LCC006_ContactDataTable.retrieveData. Happy flow.
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       12/06/2019      Created         NEXI-60
    1.1         Joanna Mielczarek       17/06/2019      Modified        NEXI-60 updated assertions and coreData( accountId )
    ********************************************************************************/
    @isTest
    private static void retrieveDataTest( )
    {
        Account aAccount = OB_TestDataFactory.getAccount( );
        insert aAccount;

        OB_LogRequest__c mainLogRequest = coreData( aAccount.Id );

        Contact contactToUpdate = OB_TestDataFactory.getContact( aAccount );
        contactToUpdate.OB_PEP__c = true;
        contactToUpdate.RecordTypeId = OB_LCC006_ContactDataTable.rtTitolariEffettivi;
        insert contactToUpdate;

        Contact contactToInsert = OB_TestDataFactory.getContact( aAccount );
        contactToInsert.RecordTypeId = OB_LCC006_ContactDataTable.rtTitolariEffettivi;

        Contact contactToDelete = OB_TestDataFactory.getContact( aAccount );
        contactToDelete.RecordTypeId = OB_LCC006_ContactDataTable.rtTitolariEffettivi;
        insert contactToDelete;

        Map<String, List<Sobject>> oldDataMap = new Map<String, List<Sobject>>( );
        oldDataMap.put( 'obj', new List<Sobject> {contactToUpdate, contactToInsert, contactToDelete} );
        mainLogRequest.OB_ReducedOldData__c = JSON.serialize( oldDataMap );

        contactToUpdate.OB_PEP__c = false;
        contactToDelete.Id = null;

        Map<String, List<Sobject>> newDataMap = new Map<String, List<Sobject>>( );
        newDataMap.put( 'obj', new List<Sobject> {contactToUpdate, contactToInsert, contactToDelete} );
        mainLogRequest.OB_ReducedNewData__c = JSON.serialize( newDataMap );

        mainLogRequest.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA;
        insert mainLogRequest;
        OB_LCC006_ContactDataTable.DataWrapper result = OB_LCC006_ContactDataTable.retrieveData( aAccount.id );

        System.assert( result.logRequest != null );
        System.assert( !result.dataTableRows.isEmpty( ) );
        System.assert( !result.isError );
        System.assert( String.isBlank( result.errorMessage ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_LCC006_ContactDataTable.retrieveData. Scenario with no modification on Contact.
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/06/2019      Created         NEXI-60
    ********************************************************************************/
    @isTest
    private static void retrieveDataNoModificationTest( )
    {
        Account aAccount = OB_TestDataFactory.getAccount( );
        insert aAccount;

        OB_LogRequest__c mainLogRequest = coreData( aAccount.Id );

        Contact contactToUpdate = OB_TestDataFactory.getContact( aAccount );
        contactToUpdate.OB_PEP__c = true;
        contactToUpdate.RecordTypeId = OB_LCC006_ContactDataTable.rtTitolariEffettivi;
        insert contactToUpdate;

        Map<String, List<Sobject>> oldDataMap = new Map<String, List<Sobject>>( );
        oldDataMap.put( 'obj', new List<Sobject> {contactToUpdate} );
        mainLogRequest.OB_ReducedOldData__c = JSON.serialize( oldDataMap );

        Map<String, List<Sobject>> newDataMap = new Map<String, List<Sobject>>( );
        newDataMap.put( 'obj', new List<Sobject> {contactToUpdate} );
        mainLogRequest.OB_ReducedNewData__c = JSON.serialize( newDataMap );

        mainLogRequest.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA;
        insert mainLogRequest;
        OB_LCC006_ContactDataTable.DataWrapper result = OB_LCC006_ContactDataTable.retrieveData( aAccount.id );

        System.assert( result.logRequest != null );
        System.assert( !result.dataTableRows.isEmpty( ) );
        System.assert( !result.isError );
        System.assert( String.isBlank( result.errorMessage ) );
        System.assert( String.isBlank( result.errorMessage ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_LCC006_ContactDataTable.retrieveData. Testing error handling.

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/06/2019      Created         NEXI-60
    ********************************************************************************/
    @isTest
    private static void retrieveDataCatchTest( )
    {
        Account aAccount = OB_TestDataFactory.getAccount( );
        insert aAccount;

        OB_LogRequest__c mainLogRequest = coreData( aAccount.Id );
        insert mainLogRequest;

        OB_LCC006_ContactDataTable.DataWrapper result = OB_LCC006_ContactDataTable.retrieveData( aAccount.id );

        System.assert( result.logRequest != null );
        System.assert( result.dataTableRows.isEmpty( ) );
        System.assert( result.isError );
        System.assert( !String.isBlank( result.errorMessage ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_LCC006_ContactDataTable.retrieveData. Scenario without Log Request.

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       17/06/2019      Created         NEXI-60
    ********************************************************************************/
    @isTest
    private static void retrieveDataNoLogRequestTest( )
    {
        Account aAccount = OB_TestDataFactory.getAccount( );
        insert aAccount;

        Contact contactToInsert = OB_TestDataFactory.getContact( aAccount );
        contactToInsert.RecordTypeId = OB_LCC006_ContactDataTable.rtTitolariEffettivi;
        insert contactToInsert;

        OB_LCC006_ContactDataTable.DataWrapper result = OB_LCC006_ContactDataTable.retrieveData( aAccount.id );

        System.assertEquals( new OB_LogRequest__c( ), result.logRequest );
        System.assert( !result.dataTableRows.isEmpty( ) );
        System.assert( !result.isError );
        System.assert( String.isBlank( result.errorMessage ) );
    }
}