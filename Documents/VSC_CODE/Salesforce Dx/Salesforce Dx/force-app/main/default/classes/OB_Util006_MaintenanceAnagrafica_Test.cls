/**
 * Created by adrian.dlugolecki on 31.05.2019.
 */
@isTest
public with sharing class OB_Util006_MaintenanceAnagrafica_Test
{
    private static String CLIENT_TYPE_TEST = 'TEST';
    private static String EXTERNAL_SOURCE_MAPPING_REPORT_TYPE_PUNTO_VENDITA = 'Punto Vendita';
    private static String EXTERNAL_SOURCE_MAPPING_REPORT_TYPE_SOCIETA_CUMULATIVO = 'Società Cumulativo';

    /*******************************************************************************
    Purpose:  Method prepare data for test of OB_Util006_MaintenanceAnagrafica.startMaintenanceApprovalProcessIfNeeded method
    Parameters: Boolean oldContactPEP, Boolean newContactPEP
    Returns: Id

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       31/05/2019      Created         NEXI-85
    1.1         Marta Stempien          10/06/2019      Modified        NEXI-97
    ********************************************************************************/
    private static Id prepareDataForStartMaintenanceApproval( Boolean oldContactPEP, Boolean newContactPEP )
    {
        Account aAccount = OB_TestDataFactory.getAccount( );
        insert aAccount;

        Contact oldContact = OB_TestDataFactory.getContact( aAccount );
        oldContact.OB_PEP__c = oldContactPEP;
        insert oldContact;
        Contact newContact = OB_TestDataFactory.getContact( aAccount );
        newContact.OB_PEP__c = newContactPEP;
        NE__Order__c oOrder = OB_TestDataFactory.getOrder( );
        insert oOrder;

        NE__Service_Point__c oldNewServicePoint = OB_TestDataFactory.getServicePoint( );

        OB_LogRequest__c logRequest = OB_TestDataFactory.getLogRequest( );
        logRequest.OB_AccountId__c = aAccount.id;
        Map<String, List<Sobject>> newDataMap = new Map<String, List<Sobject>>( );
        newDataMap.put( 'obj', new List<Sobject> {newContact, oldNewServicePoint, aAccount, oOrder} );
        Map<String, List<Sobject>> oldDataMap = new Map<String, List<Sobject>>( );
        oldDataMap.put( 'obj', new List<Sobject> {oldContact, oldNewServicePoint, aAccount, oOrder} );
        logRequest.OB_ReducedOldData__c = JSON.serialize( oldDataMap );
        logRequest.OB_ReducedNewData__c = JSON.serialize( newDataMap );
        logRequest.OB_Change_of_data_of_beneficial_owners__c = true;
        logRequest.OB_PEP__c = true;
        insert logRequest;

        NE__Product__c pProduct = OB_TestDataFactory.getProduct( );
        pProduct.OB_Acquirer__c = OB_UtilityConstants.PRODUCT_ACQUIRER_NEXI;
        insert pProduct;

        NE__Catalog__c cCatalog = new NE__Catalog__c( );
        insert cCatalog;
        NE__Catalog_Item__c catalogItem = OB_TestDataFactory.getCatalogItem( cCatalog.Id, pProduct.id );
        insert catalogItem;

        Asset aAsset = OB_TestDataFactory.getAsset( );
        aAsset.AccountId = aAccount.id;
        aAsset.NE__CatalogItem__c = catalogItem.id;
        aAsset.NE__Status__c = OB_Util006_MaintenanceAnagrafica.ASSET_STATUS_ACTIVE;
        insert aAsset;

        aAsset = OB_TestDataFactory.getAsset( );
        aAsset.AccountId = aAccount.id;
        aAsset.NE__CatalogItem__c = catalogItem.id;
        aAsset.NE__Status__c = OB_Util006_MaintenanceAnagrafica.ASSET_STATUS_ACTIVE;
        // NEXI-206, Wojciech Szuba, <wojciech.szuba@accenture.com>, 22/07/2019, STOP
        aAsset.NE__Root_Order_Item__c = null;
        aAsset.NE__ProdId__c = pProduct.Id;
        // NEXI-206, Wojciech Szuba, <wojciech.szuba@accenture.com>, 22/07/2019, STOP
        insert aAsset;

        return logRequest.id;
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.startMaintenanceApprovalProcessIfNeeded method for titolari effetivi
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       30/05/2019      Created         NEXI-85
    ********************************************************************************/
    @isTest
    private static void startMaintenanceApprovalProcessIfNeededTest( )
    {
        Id logRequestId = prepareDataForStartMaintenanceApproval( false, true );
        Test.startTest( );
        // NEXI-206, Wojciech Szuba, <wojciech.szuba@accenture.com>, 22/07/2019, START
        OB_LogRequest__c testLogRequest =
        [
                SELECT Id, OB_isBlackList__c, OB_Gianos__c
                FROM OB_LogRequest__c
                WHERE Id = :logRequestId
        ];
        testLogRequest.OB_Gianos__c = '30';
        upsert testLogRequest;
        // NEXI-206, Wojciech Szuba, <wojciech.szuba@accenture.com>, 22/07/2019, STOP
        OB_Util006_MaintenanceAnagrafica.startMaintenanceApprovalProcessIfNeeded( new List<String> {logRequestId}, OB_Util006_MaintenanceAnagrafica.MAINTENANCE_TYPE_TITOLARI_EFFETTTIVI );
        Test.stopTest( );
        OB_LogRequest__c result = [ SELECT OB_StartApprovalProcess__c,OB_Status__c FROM OB_LogRequest__c WHERE Id = :logRequestId ];
        System.assertEquals( true, result.OB_StartApprovalProcess__c );
        System.assertEquals( OB_UtilityConstants.LOGREQUEST_STATUS_INAPPROVAZIONE, result.OB_Status__c );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.startMaintenanceApprovalProcessIfNeeded method with null
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       30/05/2019      Created         NEXI-85
    ********************************************************************************/
    @isTest
    private static void startMaintenanceApprovalProcessIfNeededNullTest( )
    {
        OB_Util006_MaintenanceAnagrafica.startMaintenanceApprovalProcessIfNeeded( null, OB_Util006_MaintenanceAnagrafica.MAINTENANCE_TYPE_TITOLARI_EFFETTTIVI );
        System.assert( true );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.startMaintenanceApprovalProcessIfNeeded method with no Asset
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       31/05/2019      Created         NEXI-85
    ********************************************************************************/
    @isTest
    private static void startMaintenanceApprovalProcessIfNeededNoAssetTest( )
    {
        OB_LogRequest__c logRequest = OB_TestDataFactory.getLogRequest( );
        logRequest.OB_Change_of_data_of_beneficial_owners__c = true;
        insert logRequest;
        OB_Util006_MaintenanceAnagrafica.startMaintenanceApprovalProcessIfNeeded( new List<String> {logRequest.id}, OB_Util006_MaintenanceAnagrafica.MAINTENANCE_TYPE_TITOLARI_EFFETTTIVI );
        System.assert( true );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.startMaintenanceApprovalProcessIfNeeded method with Old PEP set to true
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       31/05/2019      Created         NEXI-85
    ********************************************************************************/
    @isTest
    private static void startMaintenanceApprovalProcessIfNeededOldPEPTest( )
    {
        OB_Util006_MaintenanceAnagrafica.startMaintenanceApprovalProcessIfNeeded( new List<String> {prepareDataForStartMaintenanceApproval( true, true )}, OB_Util006_MaintenanceAnagrafica.MAINTENANCE_TYPE_TITOLARI_EFFETTTIVI );
        System.assert( true );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.startMaintenanceApprovalProcessIfNeeded method with New PEP set to false
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       31/05/2019      Created         NEXI-85
    ********************************************************************************/
    @isTest
    private static void startMaintenanceApprovalProcessIfNeededNewPEPTest( )
    {
        OB_Util006_MaintenanceAnagrafica.startMaintenanceApprovalProcessIfNeeded( new List<String> {prepareDataForStartMaintenanceApproval( false, false )}, OB_Util006_MaintenanceAnagrafica.MAINTENANCE_TYPE_TITOLARI_EFFETTTIVI );
        System.assert( true );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.startMaintenanceApprovalProcessIfNeeded method with Exception
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       31/05/2019      Created         NEXI-85
    ********************************************************************************/
    @isTest
    private static void startMaintenanceApprovalProcessIfNeededExcTest( )
    {
        Id logRequestId = prepareDataForStartMaintenanceApproval( false, true );
        update new OB_LogRequest__c( Id = logRequestId, OB_ReducedOldData__c = null );
        OB_Util006_MaintenanceAnagrafica.startMaintenanceApprovalProcessIfNeeded( new List<String> {logRequestId}, OB_Util006_MaintenanceAnagrafica.MAINTENANCE_TYPE_TITOLARI_EFFETTTIVI );
        System.assert( true );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.startMaintenanceApprovalProcessIfNeeded for MCC
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       05/06/2019      Created         NEXI-61
    ********************************************************************************/
    @isTest
    private static void startMaintenanceApprovalProcessIfNeededMCC( )
    {
        Id logRequestId = prepareDataForStartMaintenanceApproval( false, true );
        Test.startTest( );
        // NEXI-206, Wojciech Szuba, <wojciech.szuba@accenture.com>, 22/07/2019, START
        OB_LogRequest__c testLogRequest =
        [
                SELECT Id, OB_AccountId__c, OB_isBlackList__c, OB_Gianos__c
                FROM OB_LogRequest__c
                WHERE Id = :logRequestId
        ];
        testLogRequest.OB_PEP__c = true;
        testLogRequest.OB_Gianos__c = null;
        upsert testLogRequest;

        // NEXI-206, Wojciech Szuba, <wojciech.szuba@accenture.com>, 22/07/2019, STOP
        Boolean result = OB_Util006_MaintenanceAnagrafica.startMaintenanceApprovalProcessIfNeeded( new List<String> {logRequestId}, OB_Util006_MaintenanceAnagrafica.MAINTENANCE_TYPE_MCC );
        Test.stopTest( );
        System.assert( result );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.prepareDataForResolution. Null test
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       06/06/2019      Created         NEXI-64
    ********************************************************************************/
    @isTest
    private static void prepareDataForResolutionNullTest( )
    {
        Test.startTest( );
        OB_Util006_MaintenanceAnagrafica.LogRequestResolutionWrapper result = OB_Util006_MaintenanceAnagrafica.prepareDataForResolution( null );
        Test.stopTest( );
        System.assert( result.objectsToDelete.isEmpty( ) );
        System.assert( result.objectsToInsert.isEmpty( ) );
        System.assert( result.objectsToUpdate.isEmpty( ) );
    }

    /*******************************************************************************
   Purpose:  Method test OB_Util006_MaintenanceAnagrafica.prepareDataForResolution. Deserialization Exception test
   Parameters: -
   Returns: -

   History
   --------
   VERSION     AUTHOR                  DATE            DETAIL          Description
   1.0         Adrian Dlugolecki       06/06/2019      Created         NEXI-64
   ********************************************************************************/
    @isTest
    private static void prepareDataForResolutionDeserializationErrorTest( )
    {
        Test.startTest( );
        OB_Util006_MaintenanceAnagrafica.LogRequestResolutionWrapper result = OB_Util006_MaintenanceAnagrafica.prepareDataForResolution( new OB_LogRequest__c( ) );
        Test.stopTest( );
        System.assert( result.objectsToDelete.isEmpty( ) );
        System.assert( result.objectsToInsert.isEmpty( ) );
        System.assert( result.objectsToUpdate.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.prepareDataForResolution. Happy flow for delete
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       06/06/2019      Created         NEXI-64
    ********************************************************************************/
    @isTest
    private static void prepareDataForResolutionDeleteTest( )
    {
        Id logRequestId = prepareDataForStartMaintenanceApproval( false, true );
        OB_LogRequest__c mainLogRequest = [ SELECT id,OB_ReducedNewData__c,OB_ReducedOldData__c FROM OB_LogRequest__c WHERE Id = :logRequestId ];
        Test.startTest( );
        OB_Util006_MaintenanceAnagrafica.LogRequestResolutionWrapper result = OB_Util006_MaintenanceAnagrafica.prepareDataForResolution( mainLogRequest );
        Test.stopTest( );
        System.assert( !result.objectsToDelete.isEmpty( ) );
        System.assert( result.objectsToInsert.isEmpty( ) );
        System.assert( result.objectsToUpdate.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.prepareDataForResolution. Happy flow for insert
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       06/06/2019      Created         NEXI-64
    ********************************************************************************/
    @isTest
    private static void prepareDataForResolutionInsertTest( )
    {
        OB_LogRequest__c mainLogRequest = new OB_LogRequest__c( );
        Account aAccount = OB_TestDataFactory.getAccount( );
        insert aAccount;
        Contact mainContact = OB_TestDataFactory.getContact( aAccount );
        Map<String, List<Sobject>> newDataMap = new Map<String, List<Sobject>>( );
        newDataMap.put( 'obj', new List<Sobject> {mainContact} );
        Map<String, List<Sobject>> oldDataMap = new Map<String, List<Sobject>>( );
        oldDataMap.put( 'obj', new List<Sobject> {mainContact} );
        mainLogRequest.OB_ReducedOldData__c = JSON.serialize( oldDataMap );
        mainLogRequest.OB_ReducedNewData__c = JSON.serialize( newDataMap );
        Test.startTest( );
        OB_Util006_MaintenanceAnagrafica.LogRequestResolutionWrapper result = OB_Util006_MaintenanceAnagrafica.prepareDataForResolution( mainLogRequest );
        Test.stopTest( );
        System.assert( result.objectsToDelete.isEmpty( ) );
        System.assert( !result.objectsToInsert.isEmpty( ) );
        System.assert( result.objectsToUpdate.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.prepareDataForResolution. Happy flow for update
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       06/06/2019      Created         NEXI-64
   ********************************************************************************/
    @isTest
    private static void prepareDataForResolutionTest( )
    {
        OB_LogRequest__c mainLogRequest = new OB_LogRequest__c( );
        Account aAccount = OB_TestDataFactory.getAccount( );
        insert aAccount;
        Contact mainContact = OB_TestDataFactory.getContact( aAccount );
        mainContact.OB_PEP__c = true;
        insert mainContact;
        Map<String, List<Sobject>> oldDataMap = new Map<String, List<Sobject>>( );
        oldDataMap.put( 'obj', new List<Sobject> {mainContact} );
        mainContact.OB_PEP__c = false;
        Map<String, List<Sobject>> newDataMap = new Map<String, List<Sobject>>( );
        newDataMap.put( 'obj', new List<Sobject> {mainContact} );
        mainLogRequest.OB_ReducedOldData__c = JSON.serialize( oldDataMap );
        mainLogRequest.OB_ReducedNewData__c = JSON.serialize( newDataMap );
        Test.startTest( );
        OB_Util006_MaintenanceAnagrafica.LogRequestResolutionWrapper result = OB_Util006_MaintenanceAnagrafica.prepareDataForResolution( mainLogRequest );
        Test.stopTest( );
        System.assert( result.objectsToDelete.isEmpty( ) );
        System.assert( result.objectsToInsert.isEmpty( ) );
        System.assert( !result.objectsToUpdate.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.prepareDocumentMapByNames. Happy flow
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       10/06/2019      Created         NEXI-97
   ********************************************************************************/
    @isTest
    private static void prepareDocumentMapByNamesTest( )
    {
        OB_Product_Document__c mainDocument = OB_TestDataFactory.getProductDocument( );
        mainDocument.OB_REQUEST_TYPOLOGY__c = OB_Util006_MaintenanceAnagrafica.REQUEST_TYPOLOGY_MAINTENANCE;
        mainDocument.Name = OB_Util006_MaintenanceAnagrafica.DOCUMENT_SAE_ATECO_STATUO;
        mainDocument.OB_Document_Typology__c = OB_Util006_MaintenanceAnagrafica.DOCUMENT_SAE_ATECO_DESCRIPTIONS.get( 0 );
        OB_Product_Document__c secondDocument = OB_TestDataFactory.getProductDocument( );
        secondDocument.OB_REQUEST_TYPOLOGY__c = OB_Util006_MaintenanceAnagrafica.REQUEST_TYPOLOGY_MAINTENANCE;
        secondDocument.Name = OB_Util006_MaintenanceAnagrafica.DOCUMENT_SAE_ATECO_TRIS; // antonio.vatrano wn-326 05/09/2019
        secondDocument.OB_Document_Typology__c = OB_Util006_MaintenanceAnagrafica.DOCUMENT_SAE_ATECO_DESCRIPTIONS.get( 0 );
        List<OB_Product_Document__c> documentsToInsert = new List<OB_Product_Document__c>
        {
                mainDocument, secondDocument
        };
        insert documentsToInsert;
        Test.startTest( );
        Map<String, List<OB_Product_Document__c>> result = OB_Util006_MaintenanceAnagrafica.prepareDocumentMapByNames(
                OB_Util006_MaintenanceAnagrafica.DOCUMENT_SAE_ATECO,
                OB_Util006_MaintenanceAnagrafica.DOCUMENT_SAE_ATECO_DESCRIPTIONS );
        System.assert( !result.isEmpty( ) );
        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.addDocument. Happy flow with client type
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       10/06/2019      Created         NEXI-97
   ********************************************************************************/
    @isTest
    private static void addDocumentTest( )
    {
        OB_Product_Document__c mainDocument = OB_TestDataFactory.getProductDocument( );
        mainDocument.OB_REQUEST_TYPOLOGY__c = OB_Util006_MaintenanceAnagrafica.REQUEST_TYPOLOGY_MAINTENANCE;
        mainDocument.Name = OB_Util006_MaintenanceAnagrafica.DOCUMENT_SAE_ATECO_STATUO;
        mainDocument.OB_Document_Typology__c = OB_Util006_MaintenanceAnagrafica.DOCUMENT_SAE_ATECO_DESCRIPTIONS.get( 0 );
        mainDocument.OB_Client_Type__c = CLIENT_TYPE_TEST;
        insert mainDocument;
        Map<String, List<OB_Product_Document__c>> documentsByName = new Map<String, List<OB_Product_Document__c>>( );
        documentsByName.put( mainDocument.Name, new List<OB_Product_Document__c> {mainDocument} );
        Map<String, String> result = new Map<String, String>( );
        Test.startTest( );
        OB_Util006_MaintenanceAnagrafica.addDocument( OB_Util006_MaintenanceAnagrafica.DOCUMENT_SAE_ATECO_STATUO, documentsByName, result, new List<String> {CLIENT_TYPE_TEST} );
        Test.stopTest( );
        System.assert( !result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.addDocument. Happy flow without client type
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       10/06/2019      Created         NEXI-97
   ********************************************************************************/
    @isTest
    private static void addDocumentWithoutClientTypeTest( )
    {
        OB_Product_Document__c mainDocument = OB_TestDataFactory.getProductDocument( );
        mainDocument.OB_REQUEST_TYPOLOGY__c = OB_Util006_MaintenanceAnagrafica.REQUEST_TYPOLOGY_MAINTENANCE;
        mainDocument.Name = OB_Util006_MaintenanceAnagrafica.DOCUMENT_SAE_ATECO_STATUO;
        mainDocument.OB_Document_Typology__c = OB_Util006_MaintenanceAnagrafica.DOCUMENT_SAE_ATECO_DESCRIPTIONS.get( 0 );
        insert mainDocument;
        Map<String, List<OB_Product_Document__c>> documentsByName = new Map<String, List<OB_Product_Document__c>>( );
        documentsByName.put( mainDocument.Name, new List<OB_Product_Document__c> {mainDocument} );
        Map<String, String> result = new Map<String, String>( );
        Test.startTest( );
        OB_Util006_MaintenanceAnagrafica.addDocument( OB_Util006_MaintenanceAnagrafica.DOCUMENT_SAE_ATECO_STATUO, documentsByName, result, new List<String> {CLIENT_TYPE_TEST} );
        Test.stopTest( );
        System.assert( !result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.addDocument. Bad data
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       10/06/2019      Created         NEXI-97
   ********************************************************************************/
    @isTest
    private static void addDocumentBadDataTest( )
    {
        Map<String, String> result = new Map<String, String>( );
        Test.startTest( );
        OB_Util006_MaintenanceAnagrafica.addDocument( null, null, result, null );
        Test.stopTest( );
        System.assert( result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.prepareDataForResolutionUpdate
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       10/06/2019      Created         NEXI-97
    ********************************************************************************/
    @isTest
    private static void prepareDataForResolutionUpdateTest( )
    {
        OB_LogRequest__c mainLogRequest = new OB_LogRequest__c( );
        Account aAccount = OB_TestDataFactory.getAccount( );
        insert aAccount;
        Map<String, List<Sobject>> oldDataMap = new Map<String, List<Sobject>>( );
        oldDataMap.put( 'obj', new List<Sobject> {aAccount} );
        aAccount.Name = 'Test2';
        Map<String, List<Sobject>> newDataMap = new Map<String, List<Sobject>>( );
        newDataMap.put( 'obj', new List<Sobject> {aAccount} );
        mainLogRequest.OB_ReducedOldData__c = JSON.serialize( oldDataMap );
        mainLogRequest.OB_ReducedNewData__c = JSON.serialize( newDataMap );
        Test.startTest( );
        OB_Util006_MaintenanceAnagrafica.LogRequestResolutionWrapper result = OB_Util006_MaintenanceAnagrafica.prepareDataForResolutionUpdate( mainLogRequest, true );
        Test.stopTest( );
        System.assert( result.objectsToDelete.isEmpty( ) );
        System.assert( result.objectsToInsert.isEmpty( ) );
        System.assert( !result.objectsToUpdate.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.prepareDataForResolutionUpdate Null Test
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       10/06/2019      Created         NEXI-97
    ********************************************************************************/
    @isTest
    private static void prepareDataForResolutionUpdateNullTest( )
    {
        Test.startTest( );
        OB_Util006_MaintenanceAnagrafica.LogRequestResolutionWrapper result = OB_Util006_MaintenanceAnagrafica.prepareDataForResolutionUpdate( null, true );
        Test.stopTest( );
        System.assert( result.objectsToDelete.isEmpty( ) );
        System.assert( result.objectsToInsert.isEmpty( ) );
        System.assert( result.objectsToUpdate.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.prepareDataForResolutionUpdate - Exception test
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       10/06/2019      Created         NEXI-97
    ********************************************************************************/
    @isTest
    private static void prepareDataForResolutionUpdateExceptionTest( )
    {
        Test.startTest( );
        OB_Util006_MaintenanceAnagrafica.LogRequestResolutionWrapper result = OB_Util006_MaintenanceAnagrafica.prepareDataForResolutionUpdate( new OB_LogRequest__c( ), true );
        Test.stopTest( );
        System.assert( result.objectsToDelete.isEmpty( ) );
        System.assert( result.objectsToInsert.isEmpty( ) );
        System.assert( result.objectsToUpdate.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.prepareDataForAssetsUpdate
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien        18/06/2019        Created         NEXI-87
    1.1         Joanna Mielczarek       01/07/2019      Modified        NEXI-143 added service point to log request
    ********************************************************************************/
    @isTest
    private static void prepareDataForAssetsUpdateProperDataTest( )
    {
        NE__Service_Point__c sServicePoint = OB_TestDataFactory.getServicePoint( );
        insert sServicePoint;
        OB_LogRequest__c mainLogRequest = new OB_LogRequest__c( );
        mainLogRequest.OB_ServicePointId__c = sServicePoint.Id;
        ExternalSourceMapping__c externalSourceMapping = OB_TestDataFactory.getExternalSourceMapping( );
        insert externalSourceMapping;
        Map<String, List<Sobject>> oldDataMap = new Map<String, List<Sobject>>( );
        oldDataMap.put( 'obj', new List<Sobject> {externalSourceMapping} );
        externalSourceMapping.OB_MCC__c = '1111';
        Map<String, List<Sobject>> newDataMap = new Map<String, List<Sobject>>( );
        newDataMap.put( 'obj', new List<Sobject> {externalSourceMapping} );
        mainLogRequest.OB_ReducedOldData__c = JSON.serialize( oldDataMap );
        mainLogRequest.OB_ReducedNewData__c = JSON.serialize( newDataMap );
        Test.startTest( );
        Map <Id, ExternalSourceMapping__c> externalSourceMappingsByServisPointsIds = OB_Util006_MaintenanceAnagrafica.prepareDataForAssetsUpdate( mainLogRequest );
        Test.stopTest( );
        System.assert( !externalSourceMappingsByServisPointsIds.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.prepareDataForAssetsUpdate
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien        18/06/2019        Created         NEXI-87
    ********************************************************************************/
    @isTest
    private static void prepareDataForResolutionUpdateExternalSourceMappingTest( )
    {
        OB_LogRequest__c mainLogRequest = new OB_LogRequest__c( );
        ExternalSourceMapping__c externalSourceMapping = OB_TestDataFactory.getExternalSourceMapping( );
        insert externalSourceMapping;
        Map<String, List<Sobject>> oldDataMap = new Map<String, List<Sobject>>( );
        oldDataMap.put( 'obj', new List<Sobject> {externalSourceMapping} );
        externalSourceMapping.OB_MCC__c = '1111';
        Map<String, List<Sobject>> newDataMap = new Map<String, List<Sobject>>( );
        newDataMap.put( 'obj', new List<Sobject> {externalSourceMapping} );
        mainLogRequest.OB_ReducedOldData__c = JSON.serialize( oldDataMap );
        mainLogRequest.OB_ReducedNewData__c = JSON.serialize( newDataMap );
        Test.startTest( );
        OB_Util006_MaintenanceAnagrafica.LogRequestResolutionWrapper result = OB_Util006_MaintenanceAnagrafica.prepareDataForResolutionUpdate( mainLogRequest, false );
        Test.stopTest( );
        System.assert( result.objectsToDelete.isEmpty( ) );
        System.assert( result.objectsToInsert.isEmpty( ) );
        System.assert( !result.objectsToUpdate.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.prepareDataForAssetsUpdate - Exception Test
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien        18/06/2019        Created         NEXI-87
    ********************************************************************************/
    @isTest
    private static void prepareDataForAssetsUpdateExceptionTest( )
    {
        Test.startTest( );
        Map <Id, ExternalSourceMapping__c> externalSourceMappingsByServicePointsIds = OB_Util006_MaintenanceAnagrafica.prepareDataForAssetsUpdate( new OB_LogRequest__c( ) );
        Test.stopTest( );
        System.assert( externalSourceMappingsByServicePointsIds.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.prepareDataForAssetsUpdate - Null Test
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien        18/06/2019        Created         NEXI-87
    ********************************************************************************/
    @isTest
    private static void prepareDataForAssetsUpdateNullTest( )
    {
        Test.startTest( );
        Map <Id, ExternalSourceMapping__c> externalSourceMappingsByServicePointsIds = OB_Util006_MaintenanceAnagrafica.prepareDataForAssetsUpdate( null );
        Test.stopTest( );
        System.assert( externalSourceMappingsByServicePointsIds.IsEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.checkContactIsAfterModification - happy test - true result

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       19/06/2019      Created         NEXI-60
    ********************************************************************************/
    @isTest
    private static void checkContactIsAfterModificationTrueTest( )
    {
        Contact oldContact = new Contact( FirstName = 'testBefore' );
        Contact newContact = new Contact( FirstName = 'testUpdate' );

        Test.startTest( );
        Boolean result = OB_Util006_MaintenanceAnagrafica.checkContactIsAfterModification( oldContact, newContact );
        Test.stopTest( );
        System.assert( result );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.checkContactIsAfterModification - happy test - false result

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       19/06/2019      Created         NEXI-60
    ********************************************************************************/
    @isTest
    private static void checkContactIsAfterModificationFalseTest( )
    {
        Contact oldContact = new Contact( FirstName = 'sameTest' );
        Contact newContact = new Contact( FirstName = 'sameTest' );

        Test.startTest( );
        Boolean result = OB_Util006_MaintenanceAnagrafica.checkContactIsAfterModification( oldContact, newContact );
        Test.stopTest( );
        System.assert( !result );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.checkContactIsAfterModification - failed test - null as params

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       19/06/2019      Created         NEXI-60
    ********************************************************************************/
    @isTest
    private static void checkContactIsAfterModificationNullTest( )
    {
        Test.startTest( );
        Boolean result = OB_Util006_MaintenanceAnagrafica.checkContactIsAfterModification( null, null );
        Test.stopTest( );
        System.assert( !result );
    }

    /*******************************************************************************
    Purpose:  Method prepares Contact to prepareContact test methods
    Parameters: -
    Returns: Contact

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       01/07/2019      Created         NEXI-143
    ********************************************************************************/
    private static Contact getContact( )
    {
        Account testAccount = OB_TestDataFactory.getAccount( );
        insert testAccount;
        Contact testContact = OB_TestDataFactory.getContact( testAccount );
        testContact.FirstName = 'Test';
        testContact.LastName = 'Test';
        testContact.Email = 'test@gmail.com';
        testContact.MobilePhone = '123456';
        testContact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.TITOLARE_EFFETTIVO ).getRecordTypeId( );

        return testContact;
    }
    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.prepareContact - add new Contact

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Zuzanna Urban       19/06/2019      	Created         NEXI-109
    1.1         Joanna Mielczarek       01/07/2019      Modified        NEXI-143 rewrited test
    ********************************************************************************/
    @isTest
    private static void prepareNewContactTest( )
    {
        OB_LogRequest__c logRequestForContact = OB_TestDataFactory.getLogRequest( );

        Contact testContact = getContact( );
        Map<String, List<Sobject>> newDataMap = new Map<String, List<Sobject>>( );
        newDataMap.put( 'obj', new List<Sobject> {testContact} );
        logRequestForContact.OB_ReducedNewData__c = JSON.serialize( newDataMap );

        OB_Util006_MaintenanceAnagrafica.prepareContact( logRequestForContact );
        List<Contact> result = [ SELECT Id FROM Contact ];
        System.assertEquals( 1, result.size( ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.prepareContact - modyfy Contact

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Zuzanna Urban       19/06/2019      	Created         NEXI-109
    1.1         Joanna Mielczarek       01/07/2019      Modified        NEXI-143 rewrited test
    ********************************************************************************/
    @isTest
    private static void prepareChangedContactTest( )
    {
        Contact testContact = getContact( );
        insert testContact;

        OB_LogRequest__c logRequestForContact = OB_TestDataFactory.getLogRequest( );
        Map<String, List<Sobject>> newDataMap = new Map<String, List<Sobject>>( );
        newDataMap.put( 'obj', new List<Sobject> {testContact} );
        logRequestForContact.OB_ReducedNewData__c = JSON.serialize( newDataMap );

        OB_Util006_MaintenanceAnagrafica.prepareContact( logRequestForContact );

        List<Contact> result = [ SELECT Id FROM Contact ];
        System.assertEquals( 1, result.size( ) );
    }

    /*******************************************************************************
    Purpose:  Method prepare NE__Lov__c for testing checkForGamblingAndPO118( String MCC )
    Parameters: String MCCType
    Returns: NE__Lov__c

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien        25/06/2019        Created         NEXI-83
    ********************************************************************************/
    private static NE__Lov__c getLovForcheckForGamblingAndPO118( String MCCType )
    {
        NE__LOV__c lov = OB_TestDataFactory.getLov( );
        lov.NE__Value1__c = MCCType;
        lov.NE__Value2__c = '5541';
        lov.NE__Type__c = 'MCC';
        insert lov;
        return lov;
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.checkForGamblingAndPO11 - For Gambing MCC
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien        25/06/2019        Created         NEXI-83
    ********************************************************************************/
    @isTest
    private static void checkForGamblingAndPO118WhenMCCIsGamblingTest( )
    {
        NE__Lov__c lov = getLovForcheckForGamblingAndPO118( OB_Util006_MaintenanceAnagrafica.MCC_TYPE_GAMBLING );
        OB_Util006_MaintenanceAnagrafica.CheckboxesGablingAndPO118Wrapper checkboxesWrapper = new OB_Util006_MaintenanceAnagrafica.CheckboxesGablingAndPO118Wrapper( );
        checkboxesWrapper = OB_Util006_MaintenanceAnagrafica.checkForGamblingAndPO118( lov.NE__Value2__c );
        System.assertEquals( checkboxesWrapper.isGambling, true );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Util006_MaintenanceAnagrafica.checkForGamblingAndPO11 - For PO118 MCC
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien        25/06/2019        Created         NEXI-83
    ********************************************************************************/
    @isTest
    private static void checkForGamblingAndPO118WhenMCCIsMCCTest( )
    {
        NE__Lov__c lov = getLovForcheckForGamblingAndPO118( OB_Util006_MaintenanceAnagrafica.MCC_TYPE_PO118 );
        OB_Util006_MaintenanceAnagrafica.CheckboxesGablingAndPO118Wrapper checkboxesWrapper = new OB_Util006_MaintenanceAnagrafica.CheckboxesGablingAndPO118Wrapper( );
        checkboxesWrapper = OB_Util006_MaintenanceAnagrafica.checkForGamblingAndPO118( lov.NE__Value2__c );
        System.assertEquals( checkboxesWrapper.isPO118, true );
    }

    /*******************************************************************************
    Purpose: Method tests OB_Util006_MaintenanceAnagrafica.validateSaeAtecoDependency(String sae, String ateco) for positive result
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       26/07/2019         Created         NEXI-120
    ********************************************************************************/
    @isTest
    private static void checkSaeAtecoDependencyTestForPassingValidation( )
    {
        String saeName = OB_TestDataFactory.prepareLovForTest( OB_Util006_MaintenanceAnagrafica.TYPE_OF_LOV_SAE, 'S' );
        String atecoName = OB_TestDataFactory.prepareLovForTest( OB_Util006_MaintenanceAnagrafica.TYPE_OF_LOV_ATECO, 'S' );
        System.assert( OB_Util006_MaintenanceAnagrafica.validateSaeAtecoDependency( saeName, atecoName ) );
    }

    /*******************************************************************************
    Purpose: Method tests OB_Util006_MaintenanceAnagrafica.validateSaeAtecoDependency(String sae, String ateco) for negative result
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       26/07/2019         Created         NEXI-120
    ********************************************************************************/
    @isTest
    private static void checkSaeAtecoDependencyTestForNotPassingValidation( )
    {
        String saeName = OB_TestDataFactory.prepareLovForTest( OB_Util006_MaintenanceAnagrafica.TYPE_OF_LOV_SAE, 'N' );
        String atecoName = OB_TestDataFactory.prepareLovForTest( OB_Util006_MaintenanceAnagrafica.TYPE_OF_LOV_ATECO, 'S' );
        System.assert( !OB_Util006_MaintenanceAnagrafica.validateSaeAtecoDependency( saeName, atecoName ) );
    }
    /*******************************************************************************
    Purpose: Method tests OB_Util006_MaintenanceAnagrafica.validateSaeAtecoDependency(String sae, String ateco) for passing validation when there's no Ateco
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       26/07/2019         Created         NEXI-120
    ********************************************************************************/
    @isTest
    private static void checkSaeAtecoDependencyTestForPassingValidationNoAteco( )
    {
        String saeName = OB_TestDataFactory.prepareLovForTest( OB_Util006_MaintenanceAnagrafica.TYPE_OF_LOV_SAE, 'N' );
        System.assert( OB_Util006_MaintenanceAnagrafica.validateSaeAtecoDependency( saeName, null ) );
    }

    /*******************************************************************************
    Purpose: Method tests OB_Util006_MaintenanceAnagrafica.validateSaeAtecoDependency(String sae, String ateco) for null
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       26/07/2019         Created         NEXI-120
    ********************************************************************************/
    @isTest
    private static void checkSaeAtecoDependencyTestForNulls( )
    {
        System.assert( !OB_Util006_MaintenanceAnagrafica.validateSaeAtecoDependency( null, null ) );
    }

    /*******************************************************************************
Purpose:  Method is core data preparation function for settlement procedure changes
Parameters: String inEMSSettlement, String inAssetSettlementType
Returns: OB_LogRequest__c

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         Adrian Dlugolecki       11/07/2019      Created         NEXI-185
********************************************************************************/
    private static OB_LogRequest__c prepareDataForSettlementProcedureTest( String inEMSSettlement, String inAssetSettlementType )
    {
        String shopCode = 'TestSC';

        NE__Service_Point__c sServicePoint = OB_TestDataFactory.getServicePoint( );
        insert sServicePoint;

        ExternalSourceMapping__c externalSourceMapping = OB_TestDataFactory.getExternalSourceMapping( );
        externalSourceMapping.OB_Service_Point_ID__c = sServicePoint.id;
        externalSourceMapping.OB_ServicePointCodeShopCode__c = shopCode;
        externalSourceMapping.OB_Source__c = OB_UtilityConstants.EQUENS;
        insert externalSourceMapping;

        Map<String, List<Sobject>> oldDataMap = new Map<String, List<Sobject>>( );
        oldDataMap.put( 'obj', new List<Sobject> {externalSourceMapping} );

        externalSourceMapping.OB_InternationalSettlementMethod__c = inEMSSettlement;
        Map<String, List<Sobject>> newDataMap = new Map<String, List<Sobject>>( );
        newDataMap.put( 'obj', new List<Sobject> {externalSourceMapping} );
        //NEXI-356 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 02/10/2019 Start Add account to data)
        Account aAccount = OB_TestDataFactory.getAccount( );
        insert aAccount;

        OB_LogRequest__c mainLogRequest = new OB_LogRequest__c( );
        mainLogRequest.OB_ServicePointId__c = sServicePoint.Id;
        mainLogRequest.OB_ReducedOldData__c = JSON.serialize( oldDataMap );
        mainLogRequest.OB_ReducedNewData__c = JSON.serialize( newDataMap );
        mainLogRequest.OB_AccountId__c = aAccount.id;

        NE__Order__c oOrder = OB_TestDataFactory.getOrder( );
        insert oOrder;

        Asset aAsset = OB_TestDataFactory.getAsset( );
        aAsset.OB_ServicePointCode__c = shopCode;
        aAsset.NE__Status__c = OB_UtilityConstants.STATUS_ACTIVE;
        aAsset.NE__Order_Config__c = oOrder.id;
        aAsset.OB_SettlementType__c = inAssetSettlementType;
        aAsset.AccountId = aAccount.id;
        insert aAsset;
        //NEXI-356 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 02/10/2019 Stop

        return mainLogRequest;
    }

    /*******************************************************************************
    Purpose:  Method test  OB_Util006_MaintenanceAnagrafica.resolveSettlementProcedures when asset is 'Prepagato'
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       11/07/2019      Created         NEXI-185
    ********************************************************************************/
    @isTest
    private static void settlementProcedurePrepagatoTest( )
    {
        String settlementType = OB_Util006_MaintenanceAnagrafica.SETTLEMENT_PROCEDURE_LORDO;
        OB_LogRequest__c mainLogRequest = prepareDataForSettlementProcedureTest( settlementType, OB_UtilityConstants.PREPAGATO );
        Test.startTest( );
        OB_Util006_MaintenanceAnagrafica.resolveSettlementProcedures( new List<OB_LogRequest__c> {mainLogRequest} );
        Test.stopTest( );
        NE__Order__c result = [ SELECT OB_InternationalSettlementMethod__c FROM NE__Order__c LIMIT 1 ];
        System.assertEquals( settlementType, result.OB_InternationalSettlementMethod__c );
    }

    /*******************************************************************************
    Purpose:  Method test  OB_Util006_MaintenanceAnagrafica.resolveSettlementProcedures when asset is 'Postpagato'
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       11/07/2019      Created         NEXI-185
    ********************************************************************************/
    @isTest
    private static void settlementProcedurePostpagatoTest( )
    {
        String settlementType = OB_Util006_MaintenanceAnagrafica.SETTLEMENT_PROCEDURE_NETTO;
        OB_LogRequest__c mainLogRequest = prepareDataForSettlementProcedureTest( settlementType, OB_UtilityConstants.POSTPAGATO );
        Test.startTest( );
        OB_Util006_MaintenanceAnagrafica.resolveSettlementProcedures( new List<OB_LogRequest__c> {mainLogRequest} );
        Test.stopTest( );
        NE__Order__c result = [ SELECT OB_InternationalSettlementMethod__c FROM NE__Order__c LIMIT 1 ];
        System.assertEquals( settlementType, result.OB_InternationalSettlementMethod__c );
    }

    /*******************************************************************************
    Purpose: Method tests OB_Util006_MaintenanceAnagrafica.resolveExternalSourceMappingChangeReportTypeLogRequest()
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       17/07/2019         Created         NEXI-181
    ********************************************************************************/
    @isTest
    private static void resolveExternalSourceMappingChangeReportTypeLogRequestTest( )
    {
        ExternalSourceMapping__c externalSourceMapping = OB_TestDataFactory.getExternalSourceMapping( );
        externalSourceMapping.OB_ReportType__c = EXTERNAL_SOURCE_MAPPING_REPORT_TYPE_PUNTO_VENDITA;
        insert externalSourceMapping;

        Map<String, List<Sobject>> oldDataMap = new Map<String, List<Sobject>>( );
        oldDataMap.put( 'obj', new List<Sobject> {externalSourceMapping} );

        externalSourceMapping.OB_ReportType__c = EXTERNAL_SOURCE_MAPPING_REPORT_TYPE_SOCIETA_CUMULATIVO;
        Map<String, List<Sobject>> newDataMap = new Map<String, List<Sobject>>( );
        newDataMap.put( 'obj', new List<Sobject> {externalSourceMapping} );

        List <OB_LogRequest__c> testLogRequests = new List<OB_LogRequest__c>( );
        OB_LogRequest__c mainLogRequest = new OB_LogRequest__c( );
        mainLogRequest.OB_ReducedOldData__c = JSON.serialize( oldDataMap );
        mainLogRequest.OB_ReducedNewData__c = JSON.serialize( newDataMap );
        testLogRequests.add( mainLogRequest );
        OB_Util006_MaintenanceAnagrafica.resolveExternalSourceMappingChangeReportTypeLogRequest( testLogRequests );

        List<ExternalSourceMapping__c> result = [ SELECT OB_ReportType__c FROM ExternalSourceMapping__c LIMIT 1 ];
        System.assertEquals( EXTERNAL_SOURCE_MAPPING_REPORT_TYPE_SOCIETA_CUMULATIVO, result.get( 0 ).OB_ReportType__c );
    }
}