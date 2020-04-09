/*******************************************************************************
Purpose:  Class to send the request and handle the response of AVR/SOS integration
Parameters: -
Returns: -

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         Kinga Fornal            19/07/2019      Created         NEXI-214
********************************************************************************/
public without sharing class OB_Util009_AVRSOS
{
    public static final Id RECORD_TYPE_ESECUTORE = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.ESECUTORE ).getRecordTypeId( );
    public static final Id RECORD_TYPE_TITOLARE_EFFETTIVO = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.TITOLARE_EFFETTIVO ).getRecordTypeId( );
    public static final String FATAL_ERROR = 'Fatal_Error';
    public static String logStructureProcessingTime;
    // NEXI-281 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 28/08/2019 START
    private static final String LOGREQUEST_TYPE = 'OB_LogRequest__c';
    private static final String ORDERHEADER_TYPE = 'NE__Order_Header__c';
    // NEXI-281 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 28/08/2019 STOP

    /*******************************************************************************
    Purpose:  Class represents the AVR/SOS Request
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            19/07/2019      Created         NEXI-214
    ********************************************************************************/
    public class AVRSOSRequest
    {
        public AVRSOSMerchant merchant;
        public AVRSOSExecutor executor;
        public List<AVRSOSActualOwner> actualOwners;
    }

    /*******************************************************************************
    Purpose:  Class represents the merchant object is AVR/SOS request
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            19/07/2019      Created         NEXI-214
    1.1         Joanna Mielczarek       09/09/2019      Modified        NEXI-319 added proposerABI field
    ********************************************************************************/
    public class AVRSOSMerchant
    {
        public String proposerABI; // NEXI-319 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 09/09/2019
        public String name;
        public String vatNumber;
        public String taxCode;
        public String legalForm;
        public String atecoCode;
        public String commoditySectorCodeSAE;
        public String flagNoProfit;
        public String beneficiariesDescription;
        public String annualRevenue;
        public String employeesNumber;
        public AVRSOSRegisteredOfficeAddress registeredOfficeAddress;
    }

    /*******************************************************************************
    Purpose:  Class represents the registeredOfficeAddress object is AVR/SOS request
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            19/07/2019      Created         NEXI-214
    ********************************************************************************/
    public class AVRSOSRegisteredOfficeAddress
    {
        public String street;
        public String province;
        public String postalCode;
        public String country;
        public String civicNumber;
        public String city;
        public String careOf;
    }

    /*******************************************************************************
    Purpose:  Class represents the executor object is AVR/SOS request
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            19/07/2019      Created         NEXI-214
    ********************************************************************************/
    public class AVRSOSExecutor
    {
        public String vat;
        public String fiscalCode;
        public String lastName;
        public String firstName;
        public String gender;
        public String birthDate;
        public String birthCity;
        public String birthStateCode;
        public String birthCountry;
        public String citizenship;
        public String flagPep;
        public AVRSOSAddress address;
        public AVRSOSPersonalDocument personalDocument;
        public AVRSOSRiskRange riskRange;
    }

    /*******************************************************************************
    Purpose:  Class represents the ActualOwner object is AVR/SOS request
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            19/07/2019      Created         NEXI-214
    ********************************************************************************/
    public class AVRSOSActualOwner
    {
        public String fiscalCode;
        public String lastName;
        public String firstName;
        public String gender;
        public String birthDate;
        public String birthCity;
        public String birthStateCode;
        public String birthCountry;
        public String citizenship;
        public String flagPep;
        public AVRSOSAddress address;
        public AVRSOSPersonalDocument personalDocument;
        public AVRSOSRiskRange riskRange;
    }

    /*******************************************************************************
    Purpose:  Class represents the address object is AVR/SOS request
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            19/07/2019      Created         NEXI-214
    ********************************************************************************/
    public class AVRSOSAddress
    {
        public String street;
        public String civicNumber;
        public String postalCode;
        public String city;
        public String province;
        public String country;
    }

    /*******************************************************************************
    Purpose:  Class represents the personalDocument object is AVR/SOS request
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            19/07/2019      Created         NEXI-214
    1.1         Kinga Fornal            23/09/2019      Modified        NEXI-345 added expirationDate
    ********************************************************************************/
    public class AVRSOSPersonalDocument
    {
        public String documentType;
        public String documentNumber;
        public String releaseDate;
        public String releaseAuthority;
        public String releaseCity;
        public String releaseProvince;
        public String releaseCountry;
        public String expirationDate;
    }

    /*******************************************************************************
    Purpose:  Class represents the riskRange object is AVR/SOS request
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            19/07/2019      Created         NEXI-214
    ********************************************************************************/
    public class AVRSOSRiskRange
    {
        public String range;
        public String month;
        public String score;
    }

    /*******************************************************************************
    Purpose:  Class represents the repsonse from AVR/SOS
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            19/07/2019      Created         NEXI-214
    ********************************************************************************/
    public class AVRSOSResponse
    {
        public String dossierId;
    }

    /*******************************************************************************
    Purpose:  Class for the custom AVR/SOS Exception
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            22/07/2019      Created         NEXI-214
    ********************************************************************************/
    public class AVRSOSException extends Exception
    {
    }

    /*******************************************************************************
    Purpose:  Method to perform AVRSOSCallout
    Parameters: Id inAccountId, Id objectId, String processName
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            19/07/2019      Created         NEXI-214
    1.1         Damian Krzyzaniak       22/08/2019      Modified        DossierID mock is now inObjectId instead of static number
    1.2         Joanna Mielczarek       09/09/2019      Modified        Changed endpoint if process name is Setup
    ********************************************************************************/
    @Future( callout=true )
    public static void calloutAVRSOS( Id inAccountId, Id inObjectId, String inProcessName )
    {
        System.debug( LoggingLevel.INFO, 'OB_Util009_AVRSOS.AVRSOSCallout inProcessName: ' + inProcessName );
        System.debug( LoggingLevel.INFO, 'OB_Util009_AVRSOS.AVRSOSCallout inAccountId: ' + inAccountId );
        System.debug( LoggingLevel.INFO, 'OB_Util009_AVRSOS.AVRSOSCallout inObjectId: ' + inObjectId );

        if ( inAccountId == null || inObjectId == null || String.isBlank( inProcessName ) )
        {
            throw new AVRSOSException( 'OB_Util009_AVRSOS.calloutAVRSOS: Missing entry parameters to perform the callout' );
        }
        try
        {
            Account merchantAccount = getAccounts( inAccountId ).get( 0 );
            Contact executorContact = getEsecutoreContact( inAccountId, inObjectId, inProcessName ); // NEXI-367, Wojciech Szuba, <wojciech.szuba@accenture.com>, 14/10/2019
            List<Contact> titolareContacts = getRelatedContacts( inAccountId, RECORD_TYPE_TITOLARE_EFFETTIVO );
            AVRSOSRequest avrSosRequest = prepareRequest( merchantAccount, executorContact, titolareContacts, inObjectId ); // NEXI-281 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 28/08/2019
            System.debug( LoggingLevel.INFO, 'OB_Util009_AVRSOS.AVRSOSCallout Request JSON: ' + JSON.serialize( avrSosRequest ) );

            String endpoint = '';
            if ( OB_UtilityConstants.SETUP.equalsIgnoreCase( inProcessName ) )
            {
                List<NE__Order__c> relatedOrder = getRelatedOrder( inAccountId, inObjectId );
                endpoint = OB_UtilityConstants.NAMED_CREDENTIAL_SERVICE + '/api/merchants/' + merchantAccount.Id + '/sales-points/' + relatedOrder.get( 0 ).OB_Service_Point__c + '/orders/' + relatedOrder.get( 0 ).Id + '/dossiers';
            }
            else
            {
                endpoint = OB_UtilityConstants.NAMED_CREDENTIAL_SERVICE + '/api/merchants/' + merchantAccount.Id + '/requests/' + inObjectId + '/dossiers';
            }
            HttpResponse calloutResponse = callAVRSOS( JSON.serialize( avrSosRequest ), endpoint, inObjectId );
            System.debug( LoggingLevel.INFO, 'OB_Util009_AVRSOS.AVRSOSCallout Response: ' + JSON.serialize( calloutResponse.getBody( ) ) );

            OB_ConfigurationInformation__mdt listOfConfigurationInformations =
            [
                    SELECT OB_String_Value__c,
                            OB_String_Value_2__c
                    FROM OB_ConfigurationInformation__mdt
                    WHERE QualifiedApiName = 'OB_AvrsosIntegration'
                    LIMIT 1
            ];

            if ( Test.isRunningTest( ) || !Boolean.valueOf( listOfConfigurationInformations.OB_String_Value__c ) )
            {
                AVRSOSResponse resp = new AVRSOSResponse( );
                resp.dossierId = inObjectId;
                calloutResponse.setBody( JSON.serialize( resp ) );
                calloutResponse.setStatusCode( 200 );
                System.debug( LoggingLevel.INFO, 'OB_Util009_AVRSOS.AVRSOSCallout mock response dossierId : ' + resp.dossierId );
            }
            if ( calloutResponse.getStatusCode( ) == 200 )
            {
                System.debug( LoggingLevel.INFO, 'OB_Util009_AVRSOS.AVRSOSCallout Response before handler: ' + JSON.serialize( calloutResponse.getBody( ) ) );
                handleAVRSOSResponse( calloutResponse, inObjectId, inProcessName );
            }
        } catch ( Exception ex )
        {
            List<Plc_Log__c> logStructures = new List<Plc_Log__c>( );
            if ( String.isNotBlank( logStructureProcessingTime ) )
            {
                logStructures =
                [
                        SELECT Id
                        FROM Plc_Log__c
                        WHERE Plc_ProcessingTime__c = :logStructureProcessingTime
                        AND CreatedDate = TODAY AND HOUR_IN_DAY(CreatedDate) > 1
                        ORDER BY CreatedDate DESC
                        LIMIT 1
                ];
            }
            Plc_Log__c plcLog = new Plc_Log__c( );
            plcLog.Plc_RequestHeader__c = Label.OB_Avrsos_Plc_Log_Exception;
            plcLog.Plc_ProcessingTime__c = String.valueOf( DateTime.now( ).getTime( ) );
            if ( !logStructures.isEmpty( ) )
            {
                plcLog.Plc_RequestHeader__c = Label.OB_Avrsos_Second_Plc_Log_Exception;
                plcLog.Plc_RequestBody__c = logStructures.get( 0 ).Id;
                plcLog.Plc_ResponseBody__c = 'Exception: ' + ex.getMessage( ) + 'Stack trace: ' + ex.getStackTraceString( );
            }
            insert plcLog;

            System.debug( LoggingLevel.ERROR, '[EXC] AVRSOSCallout error: ' + ex.getMessage( ) + ' Stack trace: ' + ex.getStackTraceString( ) );
        }

    }

    /*******************************************************************************
    Purpose: Method to select the Accounts based on Id
    Parameters: String inAccountId
    Returns: List<Account>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            19/07/2019      Created         NEXI-214
    1.1         Kinga Fornal            23/09/2019      Modified        NEXI-345 added codes related to address
    ********************************************************************************/
    private static List<Account> getAccounts( String inAccountId )
    {
        return
        [
                SELECT Id,
                        OB_No_Profit_Recipient_Class__c,
                        OB_Legal_Address_Country__c,
                        OB_Legal_Address_Country_Code__c,
                        OB_Legal_Address_Street__c,
                        OB_Legal_Address_State__c,
                        OB_Legal_Address_State_Code__c,
                        OB_Legal_Address_ZIP__c,
                        OB_Legal_Address_Street_Number__c,
                        OB_Legal_Address_City__c,
                        OB_ATECO__c,
                        NE__Fiscal_code__c,
                        OB_SAE_Code__c,
                        Name,
                        AnnualRevenue,
                        OB_Annual_Revenue__c,
                        OB_Legal_Form__c,
                        OB_Legal_Form_Code__c,
                        OB_Employees_Number__c,
                        OB_Administrative_Office_Country__c,
                        OB_Merchants_Mngmnt_Office_Country__c,
                        NE__VAT__c,
                        OB_CCIAA_Province__c
                FROM Account
                WHERE Id = :inAccountId
        ];
    }

    /*******************************************************************************
    Purpose: Method to select the Contact based on Account Id and recordtype Id
    Parameters: Id inAccountId, Id inRecordtypeId
    Returns: List<Contact>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            19/07/2019      Created         NEXI-214
    1.1         Kinga Fornal            23/09/2019      Modified        NEXI-345 added expirationDate and codes related to address
    ********************************************************************************/

    private static List<Contact> getRelatedContacts( Id inAccountId, Id inRecordtypeId )
    {
        return
        [
                SELECT Id,
                        OB_Citizenship__c,
                        OB_Fiscal_Code__c,
                        LastName,
                        FirstName,
                        OB_Sex__c,
                        OB_Birth_Date__c,
                        OB_Birth_State_Code__c,
                        OB_Country_Birth_Code__c,
                        OB_Birth_City__c,
                        OB_PEP__c,
                        OB_Country_Birth__c,
                        OB_Address_Country__c,
                        OB_Address_Country_Code__c,
                        OB_Address_City__c,
                        OB_Address_State__c,
                        OB_Address_State_Code__c,
                        OB_Address_PostalCode__c,
                        OB_Address_Street_Number__c,
                        OB_Address_Street__c,
                        OB_Document_Type__c,
                        OB_Document_Number__c,
                        OB_Document_Release_Date__c,
                        OB_Document_Release_Authority__c,
                        OB_Document_Release_City__c,
                        OB_Document_Release_State__c,
                        OB_Document_Release_State_Code__c,
                        OB_Document_Release_Country__c,
                        OB_Document_Release_Country_Code__c,
                        OB_Gianos__c,
                        OB_Service_Point__c,
                        OB_Document_Expiration_Date__c
                FROM Contact
                WHERE AccountId = :inAccountId
                AND RecordTypeId = :inRecordtypeId
        ];
    }

    /*******************************************************************************
    Purpose: Method to select the Contact based on Account Id, Process Name and Log Request Id
    Parameters: Id inAccountId, Id inObjectId, String inProcessName
    Returns: Contact

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba          15/10/2019      Created         NEXI-367
    ********************************************************************************/
    private static Contact getEsecutoreContact( Id inAccountId, Id inObjectId, String inProcessName )
    {
        Boolean isExecutorContactOld = true;
        List<Contact> newContacts = new List<Contact>( );
        Contact executorContact = new Contact( );
        if ( isExpectedId( inObjectId, 'OB_LogRequest__c' ) && OB_UtilityConstants.MAINTENANCE.equalsIgnoreCase( inProcessName ) )
        {
            List<OB_LogRequest__c> logRequestsFromProcess = OB_Util006_MaintenanceAnagrafica.getLogRequest( new List<String>{ inObjectId } );
            if ( !logRequestsFromProcess.isEmpty( ) )
            {
                OB_Util006_MaintenanceAnagrafica.DeserializedLogRequestContent logRequestContent = new OB_Util006_MaintenanceAnagrafica.DeserializedLogRequestContent( logRequestsFromProcess.get( 0 ) );
                newContacts = logRequestContent.newContactLists;
                for ( Contact singleContact : newContacts )
                {
                    if ( OB_UtilityConstants.STATUS_ACTIVE.equalsIgnoreCase( singleContact.OB_Contact_State__c ) && singleContact.Id == null )
                    {
                        executorContact = singleContact;
                        isExecutorContactOld = false;
                        break;
                    }
                }
            }
        }
        if ( isExecutorContactOld )
        {
            newContacts = getRelatedContacts( inAccountId, RECORD_TYPE_ESECUTORE );
            if ( !newContacts.isEmpty( ) )
            {
                executorContact = newContacts.get( 0 );
            }
        }
        return executorContact;
    }

    /*******************************************************************************
    Purpose: Method to get Order related to Account and Order Header
    Parameters: inAccountId, Id inOrderHeaderId
    Returns: List<NE__Order__c>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            19/07/2019      Created         NEXI-214
    ********************************************************************************/
    private static List<NE__Order__c> getRelatedOrder( Id inAccountId, Id inOrderHeaderId )
    {
        return
        [
                SELECT Id,
                       OB_Service_Point__c // NEXI-319 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 09/09/2019
                FROM NE__Order__c
                WHERE NE__AccountId__c = :inAccountId
                AND NE__Order_Header__c = :inOrderHeaderId
        ];
    }

    /*******************************************************************************
    Purpose:  Method to prepare JSON data to perform AVR/SOS callout
    Parameters: Account inMerchantAccount, Contact inExecutorContact, List<Contact> inTitolareContacts, Id inObjectId
    Returns: AVRSOSRequest

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            19/07/2019      Created         NEXI-214
    1.1         Joanna Mielczarek       28/08/2019      Modified        NEXI-281 added Id to params
    ********************************************************************************/
    private static AVRSOSRequest prepareRequest( Account inMerchantAccount, Contact inExecutorContact, List<Contact> inTitolareContacts, Id inObjectId )
    {
        System.debug( LoggingLevel.INFO, 'OB_Util009_AVRSOS.prepareRequest inMerchantAccount: ' + inMerchantAccount );
        System.debug( LoggingLevel.INFO, 'OB_Util009_AVRSOS.prepareRequest inExecutorContact: ' + inExecutorContact );
        System.debug( LoggingLevel.INFO, 'OB_Util009_AVRSOS.prepareRequest inTitolareContacts: ' + inTitolareContacts );

        AVRSOSRequest request = new AVRSOSRequest( );
        AVRSOSMerchant merchant = prepareMerchant( inMerchantAccount, inObjectId ); // NEXI-319 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 09/09/2019
        AVRSOSExecutor executor = prepareExecutor( inExecutorContact );
        executor.vat = inMerchantAccount.NE__VAT__c;

        List<AVRSOSActualOwner> actualOwners = new List<AVRSOSActualOwner>( );
        for ( Contact actualOwnerContact : inTitolareContacts )
        {
            actualOwners.add( prepareActualOwner( actualOwnerContact ) );
        }
        request.merchant = merchant;
        request.executor = executor;
        request.actualOwners = actualOwners;

        System.debug( LoggingLevel.INFO, 'OB_Util009_AVRSOS.prepareRequest result : ' + request );
        return request;
    }

    /*******************************************************************************
    Purpose: Method to handle the AVR/SOS response
    Parameters: HTTPResponse inCalloutResponse, String inObjectId, String inProcessName
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            19/07/2019      Created         NEXI-214
    1.1         Damian Krzyzaniak       22/08/2019      Modified        Objects are unlocked during approval process to update them and then immediately locked again
    ********************************************************************************/
    private static void handleAVRSOSResponse( HTTPResponse inCalloutResponse, String inObjectId, String inProcessName )
    {
        System.debug( LoggingLevel.INFO, 'OB_Util009_AVRSOS.handleAVRSOSResponse inCalloutResponse: ' + inCalloutResponse );
        System.debug( LoggingLevel.INFO, 'OB_Util009_AVRSOS.handleAVRSOSResponse inObjectId: ' + inObjectId );
        System.debug( LoggingLevel.INFO, 'OB_Util009_AVRSOS.handleAVRSOSResponse inProcessName: ' + inProcessName );

        AVRSOSResponse responseWrapper = ( AVRSOSResponse ) JSON.deserialize( inCalloutResponse.getBody( ), AVRSOSResponse.class );
        String dossierId = responseWrapper.dossierId;
        System.debug( LoggingLevel.INFO, 'OB_Util009_AVRSOS.handleAVRSOSResponse dossierId : ' + dossierId );

        if ( OB_UtilityConstants.SETUP.equalsIgnoreCase( inProcessName ) )
        {
            List<NE__Order_Header__c> orderHeaders = [ SELECT Id, OB_AVRSOSPracticeId__c FROM NE__Order_Header__c WHERE Id = :inObjectId LIMIT 1 ];
            if ( !orderHeaders.isEmpty( ) )
            {
                orderHeaders.get( 0 ).OB_AVRSOSPracticeId__c = dossierId;
            }
            update orderHeaders;
        }
        else
        {
            List<OB_LogRequest__c> logRequests = [ SELECT Id, OB_AVRSOSPracticeId__c FROM OB_LogRequest__c WHERE Id = :inObjectId LIMIT 1 ];
            if ( !logRequests.isEmpty( ) )
            {
                System.debug( LoggingLevel.INFO, 'OB_Util009_AVRSOS.handleAVRSOSResponse before update : ' + logRequests.get( 0 ) );
                logRequests.get( 0 ).OB_AVRSOSPracticeId__c = dossierId;
                if ( Approval.isLocked( logRequests.get( 0 ).Id ) )
                {
                    Approval.unlock( logRequests.get( 0 ).Id );
                }
            }
            update logRequests;
            if ( !logRequests.isEmpty( ) && !Approval.isLocked( logRequests.get( 0 ).Id ) )
            {
                Approval.lock( logRequests.get( 0 ).Id );
            }
        }
    }

    /*******************************************************************************
    Purpose: Method to prepare merchant object for the AVR/SOS request
    Parameters: Account inAccountMerchant, Id inObjectId
    Returns: AVRSOSMerchant

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            19/07/2019      Created         NEXI-214
    1.1         Joanna Mielczarek       09/09/2019      Modified        NEXI-319 added proposerABI
    1.2         Kinga Fornal            23/09/2019      Modified        NEXI-345 added codes related to address
    ********************************************************************************/
    private static AVRSOSMerchant prepareMerchant( Account inAccountMerchant, Id inObjectId )
    {
        System.debug( LoggingLevel.INFO, 'OB_Util009_AVRSOS.prepareMerchant inAccountMerchant: ' + inAccountMerchant );

        AVRSOSMerchant merchant = new AVRSOSMerchant( );
        merchant.proposerABI = getMerchantProposerAbi( inObjectId ); // NEXI-319 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 09/09/2019
        merchant.name = inAccountMerchant.Name;
        merchant.vatNumber = inAccountMerchant.NE__VAT__c;
        merchant.taxCode = inAccountMerchant.NE__Fiscal_code__c;
        merchant.legalForm = inAccountMerchant.OB_Legal_Form_Code__c;
        merchant.atecoCode = inAccountMerchant.OB_ATECO__c;
        merchant.commoditySectorCodeSAE = inAccountMerchant.OB_SAE_Code__c;
        merchant.flagNoProfit = null;
        merchant.beneficiariesDescription = inAccountMerchant.OB_No_Profit_Recipient_Class__c;
        merchant.annualRevenue = String.valueOf( inAccountMerchant.OB_Annual_Revenue__c );
        merchant.employeesNumber = inAccountMerchant.OB_Employees_Number__c;

        AVRSOSRegisteredOfficeAddress officeAddress = new AVRSOSRegisteredOfficeAddress( );
        officeAddress.street = inAccountMerchant.OB_Legal_Address_Street__c;
        officeAddress.province = inAccountMerchant.OB_Legal_Address_State_Code__c;  // NEXI-345 Kinga Fornal <kinga.fornal@accenture.com>, 23/09/2019
        officeAddress.postalCode = inAccountMerchant.OB_Legal_Address_ZIP__c;
        officeAddress.country = inAccountMerchant.OB_Legal_Address_Country_Code__c; // NEXI-345 Kinga Fornal <kinga.fornal@accenture.com>, 23/09/2019
        officeAddress.civicNumber = inAccountMerchant.OB_Legal_Address_Street_Number__c;
        officeAddress.city = inAccountMerchant.OB_Legal_Address_City__c;
        officeAddress.careOf = null;
        merchant.registeredOfficeAddress = officeAddress;

        return merchant;
    }

    /*******************************************************************************
    Purpose: Method to prepare actualowner object for the AVR/SOS request
    Parameters: Contact inTitolareContact
    Returns: AVRSOSActualOwner

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            19/07/2019      Created         NEXI-214
    1.1         Kinga Fornal            23/09/2019      Modified        NEXI-345 added expirationDate
    ********************************************************************************/
    private static AVRSOSActualOwner prepareActualOwner( Contact inTitolareContact )
    {
        System.debug( LoggingLevel.INFO, 'OB_Util009_AVRSOS.prepareActualOwner inTitolareContact: ' + inTitolareContact );

        AVRSOSActualOwner actualOwner = new AVRSOSActualOwner( );
        actualOwner.fiscalCode = inTitolareContact.OB_Fiscal_Code__c;
        actualOwner.lastName = inTitolareContact.LastName;
        actualOwner.firstName = inTitolareContact.FirstName;
        actualOwner.gender = inTitolareContact.OB_Sex__c;
        actualOwner.birthDate = convertDate( inTitolareContact.OB_Birth_Date__c );
        actualOwner.birthCity = inTitolareContact.OB_Birth_City__c;
        actualOwner.birthStateCode = inTitolareContact.OB_Birth_State_Code__c;
        actualOwner.birthCountry = inTitolareContact.OB_Country_Birth_Code__c; // NEXI-345 Kinga Fornal <kinga.fornal@accenture.com>, 23/09/2019
        actualOwner.citizenship = inTitolareContact.OB_Citizenship__c;
        actualOwner.flagPep = String.valueOf( inTitolareContact.OB_PEP__c );

        AVRSOSAddress address = new AVRSOSAddress( );
        address.street = inTitolareContact.OB_Address_Street__c;
        address.civicNumber = inTitolareContact.OB_Address_Street_Number__c;
        address.postalCode = inTitolareContact.OB_Address_PostalCode__c;
        address.city = inTitolareContact.OB_Address_City__c;
        // NEXI-345 Kinga Fornal <kinga.fornal@accenture.com>, 23/09/2019 START
        address.province = inTitolareContact.OB_Address_State_Code__c;
        address.country = inTitolareContact.OB_Address_Country_Code__c;
        // NEXI-345 Kinga Fornal <kinga.fornal@accenture.com>, 23/09/2019 STOP
        actualOwner.address = address;

        AVRSOSPersonalDocument personalDocument = new AVRSOSPersonalDocument( );
        personalDocument.documentType = inTitolareContact.OB_Document_Type__c;
        personalDocument.documentNumber = inTitolareContact.OB_Document_Number__c;
        personalDocument.releaseDate = convertDate( inTitolareContact.OB_Document_Release_Date__c );
        personalDocument.releaseAuthority = inTitolareContact.OB_Document_Release_Authority__c;
        personalDocument.releaseCity = inTitolareContact.OB_Document_Release_City__c;
        // NEXI-345 Kinga Fornal <kinga.fornal@accenture.com>, 23/09/2019 START
        personalDocument.releaseProvince = inTitolareContact.OB_Document_Release_State_Code__c;
        personalDocument.releaseCountry = inTitolareContact.OB_Document_Release_Country_Code__c;
        personalDocument.expirationDate = convertDate( inTitolareContact.OB_Document_Expiration_Date__c );
        // NEXI-345 Kinga Fornal <kinga.fornal@accenture.com>, 23/09/2019 STOP
        actualOwner.personalDocument = personalDocument;

        AVRSOSRiskRange riskRange = new AVRSOSRiskRange( );
        riskRange.range = null;
        riskRange.month = null;
        riskRange.score = inTitolareContact.OB_Gianos__c;
        actualOwner.riskRange = riskRange;

        return actualOwner;
    }

    /*******************************************************************************
    Purpose: Method to prepare executor object for the AVR/SOS request
    Parameters: Contact inContactExecutor
    Returns: AVRSOSExecutor

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            19/07/2019      Created         NEXI-214
    1.1         Kinga Fornal            23/09/2019      Modified        NEXI-345 added expirationDate & changes country and province to codes
    ********************************************************************************/
    private static AVRSOSExecutor prepareExecutor( Contact inContactExecutor )
    {
        System.debug( LoggingLevel.INFO, 'OB_Util009_AVRSOS.prepareExecutor inContactExecutor: ' + inContactExecutor );

        AVRSOSExecutor executor = new AVRSOSExecutor( );
        executor.fiscalCode = inContactExecutor.OB_Fiscal_Code__c;
        executor.lastName = inContactExecutor.LastName;
        executor.firstName = inContactExecutor.FirstName;
        executor.gender = inContactExecutor.OB_Sex__c;
        executor.birthDate = convertDate( inContactExecutor.OB_Birth_Date__c );
        executor.birthCity = inContactExecutor.OB_Birth_City__c;
        executor.birthStateCode = inContactExecutor.OB_Birth_State_Code__c;
        executor.birthCountry = inContactExecutor.OB_Country_Birth_Code__c; // NEXI-345 Kinga Fornal <kinga.fornal@accenture.com>, 23/09/2019
        executor.citizenship = inContactExecutor.OB_Citizenship__c;
        executor.flagPep = String.valueOf( inContactExecutor.OB_PEP__c );

        AVRSOSAddress address = new AVRSOSAddress( );
        address.street = inContactExecutor.OB_Address_Street__c;
        address.civicNumber = inContactExecutor.OB_Address_Street_Number__c;
        address.postalCode = inContactExecutor.OB_Address_PostalCode__c;
        address.city = inContactExecutor.OB_Address_City__c;
        // NEXI-345 Kinga Fornal <kinga.fornal@accenture.com>, 23/09/2019 START
        address.province = inContactExecutor.OB_Address_State_Code__c;
        address.country = inContactExecutor.OB_Address_Country_Code__c;
        // NEXI-345 Kinga Fornal <kinga.fornal@accenture.com>, 23/09/2019 STOP
        executor.address = address;

        AVRSOSPersonalDocument personalDocument = new AVRSOSPersonalDocument( );
        personalDocument.documentType = inContactExecutor.OB_Document_Type__c;
        personalDocument.documentNumber = inContactExecutor.OB_Document_Number__c;
        personalDocument.releaseDate = convertDate( inContactExecutor.OB_Document_Release_Date__c );
        personalDocument.releaseAuthority = inContactExecutor.OB_Document_Release_Authority__c;
        personalDocument.releaseCity = inContactExecutor.OB_Document_Release_City__c;
        // NEXI-345 Kinga Fornal <kinga.fornal@accenture.com>, 23/09/2019 START
        personalDocument.releaseProvince = inContactExecutor.OB_Document_Release_State_Code__c;
        personalDocument.releaseCountry = inContactExecutor.OB_Document_Release_Country_Code__c;
        personalDocument.expirationDate = convertDate( inContactExecutor.OB_Document_Expiration_Date__c );
        executor.personalDocument = personalDocument;
        // NEXI-345 Kinga Fornal <kinga.fornal@accenture.com>, 23/09/2019 STOP
        AVRSOSRiskRange riskRange = new AVRSOSRiskRange( );
        riskRange.range = null;
        riskRange.month = null;
        riskRange.score = inContactExecutor.OB_Gianos__c;
        executor.riskRange = riskRange;

        return executor;

    }

    /*******************************************************************************
    Purpose:  Method to perform callout to AVR/SOS
    Parameters: String requestBody, String endpoint
    Returns: HTTPResponse

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            18/07/2019      Created         NEXI-214
    ********************************************************************************/
    public static HTTPResponse callAVRSOS( String inRequestBody, String inEndpoint, Id inObjectId )
    {
        System.debug( LoggingLevel.INFO, 'OB_Util009_AVRSOS.callAVRSOS inRequestBody: ' + inRequestBody );
        System.debug( LoggingLevel.INFO, 'OB_Util009_AVRSOS.callAVRSOS inEndpoint: ' + inEndpoint );

        if ( String.isBlank( inRequestBody ) || String.isBlank( inEndpoint ) )
        {
            throw new AVRSOSException( 'OB_Util009_AVRSOS.callAVRSOS: Missing entry parameters to perform the callout' );
        }

        String token = OB_UtilityCallingServices.checkToken( );

        HttpRequest request = new HttpRequest( );
        request.setTimeOut( 40000 );
        request.setEndpoint( inEndpoint );
        request.setMethod( OB_UtilityConstants.METHOD_POST );
        request.setHeader( OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX + token );
        request.setHeader( 'Content-Type', 'application/json' );
        request.setBody( inRequestBody );

        Http http = new Http( );
        HTTPResponse response = http.send( request );
        System.debug( LoggingLevel.INFO, 'OB_Util009_AVRSOS.callAVRSOS after send : ' + JSON.serialize( response.getBody( ) ) + ' ' + response.getStatus( ) );
        Plc_LogHelper.LogStructure logStructure = new Plc_LogHelper.LogStructure( );
        logStructure.processingTime = String.valueOf( DateTime.now( ).getTime( ) );
        logStructureProcessingTime = logStructure.processingTime;
        logStructure.httpMethod = OB_UtilityConstants.METHOD_POST;
        logStructure.requestUri = inEndpoint;
        logStructure.requestHeader = OB_UtilityConstants.AUTH + ',' + OB_UtilityConstants.PREFIX + token;
        logStructure.requestBody = inRequestBody;
        logStructure.responseBody = response.getBody( );
        logStructure.responseStatus = 'S';
        logStructure.responseMessage = response.getStatus( );
        logStructure.responseStackTrace = String.valueOF( response.getStatusCode( ) );
        logStructure.recordUrl = URL.getOrgDomainUrl( ).toString( ) + '/' + String.valueOf( inObjectId );
        try
        {
            Id plcId = Plc_LogHelper.logCall( logStructure ); //francesca.ribezzi 26/09/19 - F2WAVE2-189 - logCall returns the plc id
            //francesca.ribezzi 26/09/19 - F2WAVE2-189 - updating the new plcLog
          	OB_Utility.updateLogRequestOrderIdOnPlcLog(plcId, inObjectId); 
        } catch ( DmlException ex )
        {
            Plc_LogHelper.LogStructure errorLogStructure = new Plc_LogHelper.LogStructure( );
            errorLogStructure.processingTime = String.valueOf( DateTime.now( ).getTime( ) );
            logStructureProcessingTime = errorLogStructure.processingTime;

            String errorMessage = 'Error on Plc_LogHelper creation: ' + ex.getMessage( ) + ' Stack trace: ' + ex.getStackTraceString( );
            errorLogStructure.requestHeader = errorMessage.substring( 0, errorMessage.length( ) > 255 ? 254 : errorMessage.length( ) );
            errorLogStructure.requestBody = inRequestBody;
            errorLogStructure.responseBody = response.getBody( );
            Id plcId = Plc_LogHelper.logCall( errorLogStructure ); //francesca.ribezzi 26/09/19 - F2WAVE2-189 - logCall returns the plc id
            //francesca.ribezzi 26/09/19 - F2WAVE2-189 - updating the new plcLog
          	OB_Utility.updateLogRequestOrderIdOnPlcLog(plcId, inObjectId); 
        }

        return response;
    }

    /*******************************************************************************
    Purpose:  Method to convert date to string
    Parameters: Date inDate
    Returns: String

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            18/07/2019      Created         NEXI-214
    1.1         Joanna Mielczarek       09/09/2019      Modified        NEXI-319 changed format of date
    ********************************************************************************/
    private static String convertDate( Date inDate )
    {
        if ( inDate == null )
        {
            return '';
        }
        String year = String.valueOf( inDate.year( ) );
        String day = String.valueOf( inDate.day( ) );
        day = day.length( ) == 2 ? day : '0' + day;
        String month = String.valueOf( inDate.month( ) );
        month = month.length( ) == 2 ? month : '0' + month;
        return year + month + day;
    }

    /*******************************************************************************
    Purpose:  Method returns ProposerABI depending of object and maintenance flow type
    Parameters: SObject inObject
    Returns: String

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       28/08/2019      Created         NEXI-281
    1.1         Joanna Mielczarek       09/09/2019      Modified        NEXI-319 changed to merchant proposerABI, changed if statements
    ********************************************************************************/
    private static String getMerchantProposerAbi( Id inObjectId )
    {
        System.debug( LoggingLevel.FINE, 'OB_Util009_AVRSOS.getMerchantProposerAbi : into method with param : ' + inObjectId );
        if ( isExpectedId( inObjectId, ORDERHEADER_TYPE ) )
        {
            List<NE__Order_Header__c> orderHeaders =
            [
                    SELECT OB_ABI__c,
                            OB_Main_Process__c,
                            CreatedById
                    FROM NE__Order_Header__c
                    WHERE Id = :inObjectId
                    LIMIT 1
            ];
            if ( orderHeaders.isEmpty( ) )
            {
                return '';
            }

            System.debug( LoggingLevel.FINE, 'OB_Util009_AVRSOS.getMerchantProposerAbi : OrderHeader object : ' + orderHeaders.get( 0 ) );

            String abi = orderHeaders.get( 0 ).OB_ABI__c;
            return String.isBlank( abi ) ? '' : abi;
        }
        else if ( isExpectedId( inObjectId, LOGREQUEST_TYPE ) )
        {
            List<OB_LogRequest__c> logRequests =
            [
                    SELECT OB_ABI__c,
                            OB_MaintenanceType__c,
                            CreatedById
                    FROM OB_LogRequest__c
                    WHERE Id = :inObjectId
                    LIMIT 1
            ];
            if ( logRequests.isEmpty( ) )
            {
                return '';
            }

            OB_LogRequest__c logRequest = logRequests.get( 0 );

            System.debug( LoggingLevel.FINE, 'OB_Util009_AVRSOS.getMerchantProposerAbi : LogRequest object : ' + logRequest );

            String userProfile =
                    [
                            SELECT Profile.Name
                            FROM User
                            WHERE Id = :logRequest.CreatedById
                            LIMIT 1
                    ].get( 0 ).Profile.Name;
            if ( OB_UtilityConstants.OPERATION.equalsIgnoreCase( userProfile ) )
            {
                return '00000';
            }
            if ( OB_UtilityConstants.ANAGRAFICA.equalsIgnoreCase( logRequest.OB_MaintenanceType__c ) )
            {
                String abi = logRequest.OB_ABI__c;
                return String.isEmpty( abi ) ? '' : abi;
            }
        }
        return '';
    }

    /*******************************************************************************
    Purpose:  Method checks if object with given Id is expected ones
    Parameters: String inParamId, String inExpectedObjectAPIName
    Returns: Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       28/08/2019      Created         NEXI-281
    ********************************************************************************/
    public static Boolean isExpectedId( String inParamId, String inExpectedObjectAPIName )
    {
        System.debug( LoggingLevel.FINE, 'OB_Util009_AVRSOS.isExpectedId : into method with params : ' + inParamId + ' / ' + inExpectedObjectAPIName );
        Boolean result = false;
        if ( String.isNotBlank( inParamId ) && String.isNotBlank( inExpectedObjectAPIName ) && inParamId instanceOf Id )
        {
            String prefixId = inParamId.substring( 0, 3 );
            String prefixObjectId = Schema.getGlobalDescribe( ).get( inExpectedObjectAPIName ).getDescribe( ).getKeyPrefix( );
            if ( prefixObjectId.equals( prefixId ) )
            {
                result = true;
            }
        }
        System.debug( LoggingLevel.FINE, 'OB_Util009_AVRSOS.isExpectedId : ended with result = ' + result );
        return result;
    }
}