@isTest
public class OB_LogRequestTriggerHandler_Test // NEXI-148 Zuzanna Urban <z.urban@accenture.com> 02/07/2019, change name of the class
{
    @isTest
    public static void checkApprovalAction_Test( )
    {
        Map<Id, OB_LogRequest__c> oldOrds = new Map<Id, OB_LogRequest__c>( ) ;
        Map<Id, OB_LogRequest__c> newOrds = new Map<Id, OB_LogRequest__c>( );


        NE__Order_Header__c orderHeader = new NE__Order_Header__c( );
        orderHeader.OB_Main_Process__c = 'Maintenance';
        insert orderHeader;
        NE__Order__c configuration = new NE__Order__c( NE__Order_Header__c = orderHeader.Id );
        configuration.OB_ApprovalType__c = 'BIO';
        configuration.OB_BankApprovalStatus__c = 'Approvato' ;
        insert configuration;
        NE__OrderItem__c orderItem = new NE__OrderItem__c( NE__Qty__c = 10, NE__OrderId__c = configuration.id );
        insert orderItem;
        OB_LogRequest__c logRequest = new OB_LogRequest__c( );
        logRequest.OB_OrderId__c = configuration.Id;
        insert logRequest;
        oldOrds.put( logRequest.Id, logRequest );

        NE__Order_Header__c orderHeader2 = new NE__Order_Header__c( );
        orderHeader2.OB_Main_Process__c = 'Maintenance';
        insert orderHeader2;
        // System.Debug(orderHeader2.OB_Main_Process__c);
        System.Debug( 'orderHeader2 is : ' + orderHeader2 );

        NE__Order__c configuration2 = new NE__Order__c( );
        configuration2.NE__Order_Header__c = orderHeader2.Id;
        configuration2.OB_ApprovalType__c = 'BIO';
        configuration2.OB_BankApprovalStatus__c = 'Approvato' ;

        insert configuration2;
        System.Debug( 'configuration2 is : ' + configuration2 );


        NE__OrderItem__c orderItem2 = new NE__OrderItem__c( );
        orderItem2.NE__Qty__c = 10;
        orderItem2.NE__OrderId__c = configuration2.Id;
        insert orderItem2;
        System.Debug( 'orderItem2 is : ' + orderItem2 );

        OB_LogRequest__c logRequest2 = new OB_LogRequest__c( );
        logRequest2.OB_OrderId__c = configuration2.Id;
        insert logRequest2;

        System.debug( 'logRequest2: ' + JSON.serialize( logRequest2 ) );

        OB_LogRequest__c newlogRequest =
        [
                SELECT Id,
                        OB_OrderId__r.NE__Order_Header__r.OB_Main_Process__c,
                        OB_OrderId__r.OB_ApprovalType__c,
                        OB_OrderId__r.OB_BankApprovalStatus__c,
                        OB_ApprovalProcess__c
                FROM OB_LogRequest__c
                WHERE Id = :logRequest2.Id
                LIMIT 1
        ];

        System.Debug( 'newlogRequest is : ' + JSON.serialize( newlogRequest ) );

        newOrds.put( newlogRequest.Id, newlogRequest );

        System.Debug( 'newOrds map is' + newOrds );
        System.Debug( 'oldOrds map is' + oldOrds );


        Test.startTest( );
        OB_LogRequestTriggerHandler.checkApprovalAction( oldOrds, newOrds );
        Test.stopTest( );
    }

    /*******************************************************************************
    Purpose:  class that is wrapper for checkboxes fields on OB_LogRequest
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       18/06/2019         Created          NEXI-87
    ********************************************************************************/
    public class CheckboxesWrapper
    {
        public Boolean changeDataCompany;
        public Boolean changeDataBeneficialOwners;
        public Boolean changeLegalRepresentative;
        public Boolean newLegalRepresentative;
        public Boolean changeServicePointData;
    }

    /*******************************************************************************
    Purpose:  Method prepares data for happy flow of OB_LogRequestTriggerHandler.logRequestResolution
    Parameters: CheckboxesWrapper checkboxesWrapper
    Returns: OB_LogRequest__c mainLogRequest

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       06/06/2019      Created         NEXI-64
    1.1         Marta Stempien          10/06/2019      Modified        NEXI-97
    1.2         Marta Stempien          18/06/2019      Modified        NEXI-87
    ********************************************************************************/
    private static OB_LogRequest__c prepareDataForLogRequestResolutionChangeTest( CheckboxesWrapper checkboxesWrapper )
    {
        OB_LogRequest__c mainLogRequest = new OB_LogRequest__c( );
        mainLogRequest.RecordTypeId = OB_LogRequestTriggerHandler.MAINTENANCE_ANAGRAFICA_RECORD_TYPE;
        mainLogRequest.OB_Change_of_data_of_beneficial_owners__c = checkboxesWrapper.changeDataBeneficialOwners;
        mainLogRequest.OB_ChangeCompanyData__c = checkboxesWrapper.changeDataCompany;
        mainLogRequest.OB_ChangeLegalRepresentative__c = checkboxesWrapper.changeLegalRepresentative;
        mainLogRequest.OB_NewLegalRepresentative__c = checkboxesWrapper.newLegalRepresentative;
        mainLogRequest.OB_ChangeServicePointData__c = checkboxesWrapper.changeServicePointData;
        Account aAccount = OB_TestDataFactory.getAccount( );
        insert aAccount;
        Contact mainContact = OB_TestDataFactory.getContact( aAccount );
        Map<String, List<Sobject>> newDataMap = new Map<String, List<Sobject>>( );
        newDataMap.put( 'obj', new List<Sobject> {mainContact} );
        Map<String, List<Sobject>> oldDataMap = new Map<String, List<Sobject>>( );
        oldDataMap.put( 'obj', new List<Sobject> {mainContact} );
        mainLogRequest.OB_ReducedOldData__c = JSON.serialize( oldDataMap );
        mainLogRequest.OB_ReducedNewData__c = JSON.serialize( newDataMap );
        mainLogRequest.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA;
        return mainLogRequest;
    }

    /*******************************************************************************
    Purpose:  Method test OB_LogRequestTriggerHandler.logRequestResolution happy flow for SAE/ATECO process
    Parameters: -
    Returns: -

    History
    --------
    1.0         Marta Stempien          10/06/2019      Created        NEXI-97
    ********************************************************************************/
    @isTest
    private static void logRequestResolutionChangeSaeAtecoTest( )
    {
        CheckboxesWrapper checkboxesWrapper = new CheckboxesWrapper( );
        checkboxesWrapper.changeDataCompany = true;
        checkboxesWrapper.changeDataBeneficialOwners = false;
        checkboxesWrapper.changeLegalRepresentative = false;
        checkboxesWrapper.newLegalRepresentative = false;
        checkboxesWrapper.changeServicePointData = false;
        OB_LogRequest__c mainLogRequest = prepareDataForLogRequestResolutionChangeTest( checkboxesWrapper );
        insert mainLogRequest;
        mainLogRequest.OB_Status__c = OB_UtilityConstants.CONFERMATO;
        Test.startTest( );
        update mainLogRequest;
        Test.stopTest( );
        List <Contact> results = [ SELECT id FROM Contact ];
        System.assertNotEquals( false, results.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_LogRequestTriggerHandler.logRequestResolution happy flow for TE process
    Parameters: -
    Returns: -

    History
    --------
    1.0         Marta Stempien          10/06/2019      Created        NEXI-97
    ********************************************************************************/
    @isTest
    private static void logRequestResolutionChangeTETest( )
    {
        CheckboxesWrapper checkboxesWrapper = new CheckboxesWrapper( );
        checkboxesWrapper.changeDataCompany = false;
        checkboxesWrapper.changeDataBeneficialOwners = true;
        checkboxesWrapper.changeLegalRepresentative = false;
        checkboxesWrapper.newLegalRepresentative = false;
        checkboxesWrapper.changeServicePointData = false;
        OB_LogRequest__c mainLogRequest = prepareDataForLogRequestResolutionChangeTest( checkboxesWrapper );
        insert mainLogRequest;
        mainLogRequest.OB_Status__c = OB_UtilityConstants.CONFERMATO;
        Test.startTest( );
        update mainLogRequest;
        Test.stopTest( );
        List <Contact> results = [ SELECT id FROM Contact ];
        System.assertEquals( false, results.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_LogRequestTriggerHandler.logRequestResolution happy flow for change Executore process
    Parameters: -
    Returns: -

    History
    --------
    1.0         Marta Stempien          14/06/2019      Created        NEXI-94
    ********************************************************************************/
    @isTest
    private static void logRequestResolutionChangeExecutoreTest( )
    {
        CheckboxesWrapper checkboxesWrapper = new CheckboxesWrapper( );
        checkboxesWrapper.changeDataCompany = false;
        checkboxesWrapper.changeDataBeneficialOwners = false;
        checkboxesWrapper.changeLegalRepresentative = true;
        checkboxesWrapper.newLegalRepresentative = false;
        checkboxesWrapper.changeServicePointData = false;
        OB_LogRequest__c mainLogRequest = prepareDataForLogRequestResolutionChangeTest( checkboxesWrapper );
        insert mainLogRequest;
        mainLogRequest.OB_Status__c = OB_UtilityConstants.CONFERMATO;
        Test.startTest( );
        update mainLogRequest;
        Test.stopTest( );
        List <Contact> results = [ SELECT id FROM Contact ];
        System.assertNotEquals( false, results.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_LogRequestTriggerHandler.logRequestResolution happy flow for new Executore process
    Parameters: -
    Returns: -

    History
    --------
    1.0         Marta Stempien          14/06/2019      Created        NEXI-94
    ********************************************************************************/
    @isTest
    private static void logRequestResolutionNewExecutoreTest( )
    {
        CheckboxesWrapper checkboxesWrapper = new CheckboxesWrapper( );
        checkboxesWrapper.changeDataCompany = false;
        checkboxesWrapper.changeDataBeneficialOwners = false;
        checkboxesWrapper.changeLegalRepresentative = false;
        checkboxesWrapper.newLegalRepresentative = true;
        checkboxesWrapper.changeServicePointData = false;
        OB_LogRequest__c mainLogRequest = prepareDataForLogRequestResolutionChangeTest( checkboxesWrapper );
        insert mainLogRequest;
        mainLogRequest.OB_Status__c = OB_UtilityConstants.CONFERMATO;
        Test.startTest( );
        update mainLogRequest;
        Test.stopTest( );
        List <Contact> results = [ SELECT id FROM Contact ];
        System.assertEquals( false, results.isEmpty( ) );
    }


    /*******************************************************************************
    Purpose:  Method test OB_LogRequestTriggerHandler.logRequestResolution no change test
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       06/06/2019      Created         NEXI-64
    ********************************************************************************/
    @isTest
    private static void logRequestResolutionNoChangeTest( )
    {
        OB_LogRequest__c mainLogRequest = new OB_LogRequest__c( );
        insert mainLogRequest;
        mainLogRequest.OB_Change_of_data_of_beneficial_owners__c = true;
        Test.startTest( );
        update mainLogRequest;
        Test.stopTest( );
        System.assert( true );
    }

    /*******************************************************************************
    Purpose:  Method test OB_LogRequestTriggerHandler.logRequestResolution exception test
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       06/06/2019      Created         NEXI-64
	1.2         Zuzanna Urban			02/07/2019		Modyfied		NEXI-148
    ********************************************************************************/
    @isTest
    private static void logRequestResolutionExceptionTest( )
    {
        OB_LogRequest__c mainLogRequest = new OB_LogRequest__c( );
        mainLogRequest.RecordTypeId = OB_LogRequestTriggerHandler.MAINTENANCE_ANAGRAFICA_RECORD_TYPE;
        mainLogRequest.OB_Change_of_data_of_beneficial_owners__c = true;
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
        mainLogRequest.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA;
        insert mainLogRequest;
        delete mainContact;
        mainLogRequest.OB_Status__c = OB_UtilityConstants.CONFERMATO;
        Test.startTest( );
        // NEXI-148 Zuzanna Urban <z.urban@accenture.com> 02/07/2019 - Start
        Boolean isError = false;
        try
        {
            update mainLogRequest;
        } catch ( DmlException ex )
        {
            isError = true;
        }
        Test.stopTest( );
        System.assert( isError );
        // NEXI-148 Zuzanna Urban <z.urban@accenture.com> 02/07/2019 - Stop
        List<Contact> result = [ SELECT id FROM Contact ];
        System.assert( result.isEmpty( ) );
    }

    /*******************************************************************************
    Purpose:  Method tests OB_LogRequestTriggerHandler.setInAttesaStatusIfCompanyDataChanged for the scenario
              when OB_ChangeCompanyData__c is checked
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0      Marta Stempien          11/06/2019         Created           NEXI-97
    ********************************************************************************/
    @isTest
    private static void setInAttesaStatusIfCompanyDataChangedTest( )
    {
        CheckboxesWrapper checkboxesWrapper = new CheckboxesWrapper( );
        checkboxesWrapper.changeDataCompany = true;
        checkboxesWrapper.changeDataBeneficialOwners = false;
        checkboxesWrapper.changeLegalRepresentative = false;
        checkboxesWrapper.newLegalRepresentative = false;
        checkboxesWrapper.changeServicePointData = false;
        OB_LogRequest__c mainLogRequest = prepareDataForLogRequestResolutionChangeTest( checkboxesWrapper );
        mainLogRequest.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT;
        Test.startTest( );
        insert mainLogRequest;
        Test.stopTest( );
        System.assertEquals( OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT, [ //  Micol Ferrari <micol.ferrari@accenture.com>, 18/07/2019 
                SELECT Id, OB_Status__c
                FROM OB_LogRequest__c
                WHERE ID = :mainLogRequest.Id
        ].OB_Status__c );
    }

    /*******************************************************************************
    Purpose:  Method tests OB_LogRequestTriggerHandler.setInAttesaStatusIfCompanyDataChanged for the scenario
              when OB_ChangeCompanyData__c is not checked
    Parameters: -
    Returns: -

    History
    --------
    VERSION        AUTHOR               DATE          DETAIL       Description
    1.0         Marta Stempien       11/06/2019      Created         NEXI-64
    ********************************************************************************/
    @isTest
    private static void setInAttesaStatusIfCompanyDataChangedNothingToChangeTest( )
    {
        CheckboxesWrapper checkboxesWrapper = new CheckboxesWrapper( );
        checkboxesWrapper.changeDataCompany = false;
        checkboxesWrapper.changeDataBeneficialOwners = false;
        checkboxesWrapper.changeLegalRepresentative = false;
        checkboxesWrapper.newLegalRepresentative = false;
        checkboxesWrapper.changeServicePointData = false;
        OB_LogRequest__c mainLogRequest = prepareDataForLogRequestResolutionChangeTest( checkboxesWrapper );
        mainLogRequest.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT;
        Test.startTest( );
        insert mainLogRequest;
        Test.stopTest( );
        System.assertEquals( OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT, [
                SELECT Id, OB_Status__c
                FROM OB_LogRequest__c
                WHERE ID = :mainLogRequest.Id
        ].OB_Status__c );
    }

    /*******************************************************************************
    Purpose:  Method tests OB_LogRequestTriggerHandler.logRequestResolution for the scenario
              when OB_ChangeServicePointData__c is checked
    Parameters: -
    Returns: -

    History
    --------
    VERSION        AUTHOR               DATE          DETAIL       Description
    1.0         Marta Stempien       18/06/2019      Created         NEXI-67
    ********************************************************************************/
    @isTest
    private static void logRequestResolutionChangeServicePointTest( )
    {
        NE__Service_Point__c testServicePoint = OB_TestDataFactory.getServicePoint( );
        insert testServicePoint;
        CheckboxesWrapper checkboxesWrapper = new CheckboxesWrapper( );
        checkboxesWrapper.changeDataCompany = false;
        checkboxesWrapper.changeDataBeneficialOwners = false;
        checkboxesWrapper.changeLegalRepresentative = false;
        checkboxesWrapper.newLegalRepresentative = false;
        checkboxesWrapper.changeServicePointData = true;
        OB_LogRequest__c mainLogRequest = prepareDataForLogRequestResolutionChangeTest( checkboxesWrapper );
        mainLogRequest.OB_ServicePointId__c = testServicePoint.Id;
        ExternalSourceMapping__c externalSourceMapping = OB_TestDataFactory.getExternalSourceMapping( );
        externalSourceMapping.OB_Service_Point_ID__c = testServicePoint.Id;
        externalSourceMapping.OB_MCC__c = '5555';
        externalSourceMapping.OB_MCCL2__c = '5555';
        insert externalSourceMapping;
        Map<String, List<Sobject>> newDataMap = new Map<String, List<Sobject>>( );
        newDataMap.put( 'obj', new List<Sobject> {externalSourceMapping} );
        externalSourceMapping.OB_MCC__c = '8888';
        externalSourceMapping.OB_MCCL2__c = '8888';
        update externalSourceMapping;
        Map<String, List<Sobject>> oldDataMap = new Map<String, List<Sobject>>( );
        oldDataMap.put( 'obj', new List<Sobject> {externalSourceMapping} );
        mainLogRequest.OB_ReducedOldData__c = JSON.serialize( oldDataMap );
        mainLogRequest.OB_ReducedNewData__c = JSON.serialize( newDataMap );
        insert mainLogRequest;
        Asset testAsset = OB_TestDataFactory.getAsset( );
        testAsset.NE__Service_Point__c = testServicePoint.Id;
        testAsset.OB_MCC__c = '2222';
        testAsset.OB_MCCL2__c = '2222';
        insert testAsset;
        mainLogRequest.OB_Status__c = OB_UtilityConstants.CONFERMATO;
        Test.startTest( );
        update mainLogRequest;
        Test.stopTest( );
        System.assertEquals( [ SELECT OB_MCC__c FROM Asset WHERE Id = :testAsset.Id ].OB_MCC__c, '8888' );
    }

    /*******************************************************************************
    Purpose:  Method tests OB_LogRequestTriggerHandler.logRequestResolution - setting end date of removed contacts

    History
    --------
    VERSION        AUTHOR               DATE          DETAIL       Description
    1.0            Joanna Mielczarek    18/06/2019    Created      NEXI-60
    ********************************************************************************/
    @isTest
    private static void logRequestResolutionSettingContactEndDateTest( )
    {
        OB_LogRequest__c mainLogRequest = new OB_LogRequest__c( );
        mainLogRequest.RecordTypeId = OB_LogRequestTriggerHandler.MAINTENANCE_ANAGRAFICA_RECORD_TYPE;
        mainLogRequest.OB_Change_of_data_of_beneficial_owners__c = true;
        mainLogRequest.OB_ChangeCompanyData__c = false;
        mainLogRequest.OB_ChangeLegalRepresentative__c = false;
        mainLogRequest.OB_NewLegalRepresentative__c = false;

        Account aAccount = OB_TestDataFactory.getAccount( );
        insert aAccount;

        Contact mainContact = OB_TestDataFactory.getContact( aAccount );
        insert mainContact;

        Map<String, List<Sobject>> newDataMap = new Map<String, List<Sobject>>( );
        newDataMap.put( 'obj', new List<Sobject> {new Contact( )} );
        Map<String, List<Sobject>> oldDataMap = new Map<String, List<Sobject>>( );
        oldDataMap.put( 'obj', new List<Sobject> {mainContact} );
        mainLogRequest.OB_ReducedOldData__c = JSON.serialize( oldDataMap );
        mainLogRequest.OB_ReducedNewData__c = JSON.serialize( newDataMap );
        mainLogRequest.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA;
        insert mainLogRequest;

        mainLogRequest.OB_Status__c = OB_UtilityConstants.CONFERMATO;
        update mainLogRequest;

        List<Contact> contacts = [ SELECT Id, OB_EndDate__c FROM Contact ];
        System.assert( contacts.get( 0 ).OB_EndDate__c != null );
    }

    /*******************************************************************************
    Purpose:  Method test OB_LogRequestTriggerHandler.afterInsertHandler
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       11/07/2019      Created         NEXI-185
    ********************************************************************************/
    @isTest
    private static void afterInsertHandlerTest( )
    {
        OB_LogRequest__c mainLogRequest = OB_TestDataFactory.getLogRequest( );
        mainLogRequest.OB_Settlement_Procedure__c = true;
        insert mainLogRequest;
        System.assert( mainLogRequest.Id != null );
    }

    /*******************************************************************************
    Purpose:  Method test OB_LogRequestTriggerHandler.afterInsertHandler
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien       25/07/2019         Created         NEXI-181
    ********************************************************************************/
    @isTest
    private static void afterInsertHandlerTestForChangeRecordType( )
    {
        OB_LogRequest__c mainLogRequest = OB_TestDataFactory.getLogRequest( );
        mainLogRequest.OB_change_of_reporting_type__c = true;
        insert mainLogRequest;
        System.assert( mainLogRequest.Id != null );
    }

    /*******************************************************************************
    Purpose:  Method tests restarting approval process

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Zuzanna Urban       25/07/2019      	Created         NEXI-217
    1.1         Marta Stempien      30/08/2019          Modified        NEXI-287
    2.1        Adrian Dlugolecki    20/09/2019         Changed          NEXI-343
    ********************************************************************************/
    @isTest
    public static void restartApprovalProcessTest( )
    {
        OB_LogRequest__c oldLog = OB_TestDataFactory.getLogRequest( );
        insert oldLog;
        Map<Id, OB_LogRequest__c> dataToCheck = new Map<Id, OB_LogRequest__c>( );
        dataToCheck.put( oldLog.id, oldLog );
        Test.startTest( );
        OB_LogRequestTriggerHandler.startApproval( JSON.serialize( dataToCheck ) );
        Test.stopTest( );
        List <ProcessInstance> processesTest =
        [
                SELECT Id
                FROM ProcessInstance
                WHERE TargetObjectId = :oldLog.Id
        ];
        ProcessInstance processTest = !processesTest.isEmpty( ) ? processesTest.get( 0 ) : null;
        System.assert( processTest != null );
    }

    /*******************************************************************************
    Purpose:  Method calls setStatuses for either integrated or not integrated LR
    Parameters: Boolean isNotIntegrated
    Return:  Map<Id, OB_LogRequest__c>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien         02/10/2019       Created         NEXI-354
    ********************************************************************************/
    private static Map<Id, OB_LogRequest__c> callSetStatuses( Boolean isNotIntegrated )
    {
        OB_LogRequest__c newLogRequest = OB_TestDataFactory.getLogRequest( );
        newLogRequest.OB_ApprovalProcess__c = true;
        newLogRequest.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_INAPPROVAZIONE;
        newLogRequest.OB_isNotIntegrated__c = isNotIntegrated;
        insert newLogRequest;
        Map<Id, OB_LogRequest__c> newLogRequestsByIds = new Map<Id, OB_LogRequest__c>( );
        newLogRequestsByIds.put( newLogRequest.Id, newLogRequest );

        OB_LogRequest__c oldLogRequest = OB_TestDataFactory.getLogRequest( );
        oldLogRequest.OB_ApprovalProcess__c = false;
        Map<Id, OB_LogRequest__c> oldLogRequestsByIds = new Map<Id, OB_LogRequest__c>( );
        oldLogRequestsByIds.put( newLogRequest.Id, oldLogRequest );
        OB_LogRequestTriggerHandler.setStatuses( newLogRequestsByIds, oldLogRequestsByIds );
        return newLogRequestsByIds;
    }


    /*******************************************************************************
    Purpose:  Method tests setStatus Confermato for not integrated Log requests

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien         02/10/2019       Created         NEXI-354
    ********************************************************************************/
    @isTest
    private static void setStatusConfermatoTest( )
    {
        Map<Id, OB_LogRequest__c> newLogRequestsByIds = callSetStatuses( true );
        System.assertEquals( OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA, newLogRequestsByIds.values( ).get( 0 ).OB_Status__c );
    }

    /*******************************************************************************
    Purpose:  Method tests setStatus Bozza for integrated Log requests

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien         02/10/2019       Created         NEXI-354
    ********************************************************************************/
    @isTest
    private static void setStatusBozzaTest( )
    {
        Map<Id, OB_LogRequest__c> newLogRequestsByIds = callSetStatuses( false );
        System.assertEquals( OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT, newLogRequestsByIds.values( ).get( 0 ).OB_Status__c );
    }

    /*******************************************************************************
    Purpose:  Method tests setStatus Bozza null check

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien         02/10/2019       Created         NEXI-354
    ********************************************************************************/
    @isTest
    private static void setStatusNullTest( )
    {
        OB_LogRequestTriggerHandler.setStatuses( null, null );
        System.assert( true );
    }
}