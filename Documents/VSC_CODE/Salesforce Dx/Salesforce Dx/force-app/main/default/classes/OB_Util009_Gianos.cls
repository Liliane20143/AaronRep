/*******************************************************************************
Purpose:  Class that prepare data and send it to Gianos and handle response
Parameters: -
Returns: -

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-202
1.0         Adrian Dlugolecki       04/09/2019      Updated         NEXI-289
********************************************************************************/
public with sharing class OB_Util009_Gianos
{
    public static final Id RECORD_TYPE_ESECUTORE = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.ESECUTORE ).getRecordTypeId( );
    public static final Id RECORD_TYPE_TITOLARE_EFFETTIVO = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.TITOLARE_EFFETTIVO ).getRecordTypeId( );
    public static final List<String> MERCHANT_INPUT_FIELDS = new List<String>
    {
            'taxCode',
            'name',
            'registeredOfficeAddressCountry',
            // 'vatNumber', // Antonio.vatrano 04/10/2019 r1f3-134
            'provinceRegisteredOffice'
    };//NEXI-289 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 04/09/2019 remove not needed fields

    public static final String FATAL_ERROR = 'Fatal_Error';
    public static Boolean mockResponse = true;

    public class GianosException extends Exception
    {
    }

    /*******************************************************************************
    Purpose:  Class that is container for request to Gianos
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-202
    ********************************************************************************/
    public class GianosRequest
    {
        //NEXI-289 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 04/09/2019 Start
        public String internalCode = '35288';
        public String processingType = '01';
        //NEXI-289 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 04/09/2019 Stop
        public GianosMerchant merchant;
        public GianosExecutor executor;
        public List<GianosOwner> actualOwners;
    }

    /*******************************************************************************
    Purpose:  Class that is container for merchant part of request to Gianos
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-202
    ********************************************************************************/
    public class GianosMerchant
    {
        public String beneficiariesType;
        public String headOfficeCountry;
        public String atecoCode;
        public String taxCode;
        public String commoditySectorCodeSAE;
        public String name;
        public String annualRevenue;
        public String revenue;
        public String flagPEP;
        public String legalForm;
        public String legalFormSubcategory;
        public String employeesNumber;
        public String administrativeOfficeAddressCountry;
        public String related;
        public String registeredOfficeAddressCountry;
        public String vatNumber;
        public String fundSource;
        public String provinceChamberOfCommerce;
        public String provinceRegisteredOffice;
        public String relationshipPurpose;
        public String mcc;
        public String productType;
    }

    /*******************************************************************************
    Purpose:  Class that is container for executor part of request to Gianos
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-202
    ********************************************************************************/
    public class GianosExecutor
    {
        public String citizenship;
        public String fiscalCode;
        public String lastName;
        public String birthDate;
        public String flagPEP;
        public String birthCountry;
        public String residenceAddressCountry;
        public String firstName;
        public String job;
        public String residenceAddressProvince;
        public String tae;
    }

    /*******************************************************************************
    Purpose:  Class that is container for actual owner part of request to Gianos
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-202
    ********************************************************************************/
    public class GianosOwner
    {
        public String citizenship;
        public String fiscalCode;
        public String lastName;
        public String birthDate;
        public String flagPEP;
        public String birthCountry;
        public String residenceAddressCountry;
        public String firstName;
        public String residenceAddressProvince;
    }

    /*******************************************************************************
    Purpose:  Class that is container for all data that will be updated when positive response will be recived
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-202
    ********************************************************************************/
    public class DataWrapperForUpdate
    {
        Account merchant;
        Contact executor;
        List<Contact> owners;
    }

    /*******************************************************************************
    Purpose:  Method check if required fields are not empty
    Parameters: String inJsonData, List<String> inFieldsToCheck
    Returns: List<String> list of missing fields

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       22/07/2019      Created         NEXI-202
    ********************************************************************************/
    public static List<String> checkRequiredFields( String inJsonData, List<String> inFieldsToCheck )
    {
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.checkRequiredFields Start inJsonData' + inJsonData );
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.checkRequiredFields Start inFieldsToCheck' + inFieldsToCheck );
        List<String> result = new List<String>( );
        try
        {
            Map<String, Object> dataMap = ( Map<String, Object> ) JSON.deserializeUntyped( inJsonData );
            for ( String fieldName : inFieldsToCheck )
            {
                Object fieldValue = dataMap.get( fieldName );
                if ( fieldValue == null || String.isBlank( ( String.valueOf( fieldValue ) ) ) )
                {
                    result.add( fieldName );
                }
            }
        } catch ( Exception ex )
        {
            System.debug( LoggingLevel.ERROR, '[EXC] Exception ' + ex.getMessage( ) + ' stacktrace ' + ex.getStackTraceString( ) );
            return new List<String> {FATAL_ERROR};
        }
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.checkRequiredFields Stop ' + result );
        return result;
    }

    /*******************************************************************************
    Purpose:  Method prepare data that is related to merchant(Account)
    Parameters: InputDataWrapper inData, DataWrapperForUpdate outDataContainer
    Returns: GianosMerchant

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-202
    ********************************************************************************/
    private static GianosMerchant prepareGianosMerchant( InputDataWrapper inData, DataWrapperForUpdate outDataContainer )
    {
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.prepareGianosMerchant Start inData' + inData );
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.prepareGianosMerchant Start outDataContainer' + outDataContainer );
        GianosMerchant result = new GianosMerchant( );
        List<Account> relatedAcounts =
        [
                SELECT Id,
                        OB_Legal_Address_Country_Code__c,
                        OB_ATECO__c,
                        NE__Fiscal_code__c,
                        OB_SAE_Code__c,
                        Name,
                        OB_Legal_Form__c,
                        OB_Employees_Number__c,
                        NE__VAT__c,
                        OB_Legal_Address_State_Code__c //NEXI-319 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 09/09/2019 change to code field
                FROM Account
                WHERE Id = :inData.accountId
        ];
        if ( relatedAcounts.isEmpty( ) )
        {
            System.debug( LoggingLevel.ERROR, 'OB_Util009_Gianos.prepareGianosMerchant Stop No Account found for ' + inData.accountId );
            throw new GianosException( 'No Account found for ' + inData.accountId );
        }
        Account mainAccount = relatedAcounts.get( 0 );
        outDataContainer.merchant = mainAccount;
        //NEXI-289 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 04/09/2019 Start
        //NEXI-316 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 11/09/2019 Start (Protect against null)
        result.beneficiariesType = '';
        result.headOfficeCountry = mainAccount.OB_Legal_Address_Country_Code__c == null ? '' : mainAccount.OB_Legal_Address_Country_Code__c;
        result.atecoCode = mainAccount.OB_ATECO__c == null ? '' : mainAccount.OB_ATECO__c;
        result.taxCode = mainAccount.NE__Fiscal_code__c == null ? '' : mainAccount.NE__Fiscal_code__c;
        result.commoditySectorCodeSAE = mainAccount.OB_SAE_Code__c == null ? '' : mainAccount.OB_SAE_Code__c;
        result.name = mainAccount.Name == null ? '' : mainAccount.Name;
        result.annualRevenue = '';
        result.revenue = '';
        result.legalForm = '00';
        result.legalFormSubcategory = '00';
        result.employeesNumber = mainAccount.OB_Employees_Number__c == null ? '' : mainAccount.OB_Employees_Number__c;
        result.administrativeOfficeAddressCountry = '';
        result.related = '';
        result.registeredOfficeAddressCountry = mainAccount.OB_Legal_Address_Country_Code__c == null ? '' : mainAccount.OB_Legal_Address_Country_Code__c;
        result.vatNumber = mainAccount.NE__VAT__c == null ? '' : mainAccount.NE__VAT__c;
        result.fundSource = '';
        result.provinceChamberOfCommerce = '';
        result.provinceRegisteredOffice = mainAccount.OB_Legal_Address_State_Code__c == null ? '' : mainAccount.OB_Legal_Address_State_Code__c;//NEXI-319 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 09/09/2019 change to code field
        result.relationshipPurpose = '09';
        //NEXI-289 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 04/09/2019 Stop
        result.mcc = inData.mcc == null ? '' : inData.mcc;
        //NEXI-316 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 11/09/2019 Stop
        result.productType = '01';
        List<String> missingFields = checkRequiredFields( JSON.serialize( result ), MERCHANT_INPUT_FIELDS );
        if ( !missingFields.isEmpty( ) )
        {
            System.debug( LoggingLevel.ERROR, 'OB_Util009_Gianos.prepareGianosMerchant Stop missing data' + result );
            throw new GianosException( 'Missing fields on Merchant input:  ' + String.join( missingFields, ',' ) );
        }
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.prepareGianosMerchant Stop ' + result );
        return result;
    }

    /*******************************************************************************
    Purpose:  Method select Contacts related to Account, with given record type id
    Parameters: Id inAccountId, Id inRecordtypeId
    Returns: List<Contact>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-202
    ********************************************************************************/
    private static List<Contact> getRelatedContacts( Id inAccountId, Id inRecordtypeId )
    {
        return
        [
                SELECT Id,
                        OB_Citizenship__c,
                        OB_Fiscal_Code__c,
                        LastName,
                        OB_Birth_Date__c,
                        OB_PEP__c,
                        OB_Country_Birth_Code__c,
                        OB_Address_Country_Code__c,
                        FirstName,
                        OB_Address_State_Code__c//NEXI-319 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 09/09/2019 change to code field
                FROM Contact
                WHERE AccountId = :inAccountId
                AND RecordTypeId = :inRecordtypeId
        ];
    }

    /*******************************************************************************
    Purpose:  Method convert Date to string format accepted by Gianos
    Parameters: Date inDate
    Returns: String

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-202
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
        return year + month + day;//NEXI-319 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 09/09/2019 change format
    }

    /*******************************************************************************
    Purpose:  Method prepare executor data that will be send to Gianos
    Parameters: Id inAccountId, DataWrapperForUpdate outDataContainer
    Returns: GianosExecutor

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-202
    1.1         Antonio.Vatrano         03/10/2019      change          R1f3-134
    ********************************************************************************/
    private static GianosExecutor prepareGianosExecutor( InputDataWrapper inData, DataWrapperForUpdate outDataContainer )
    {
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.prepareGianosExecutor Start inAccountId ' + inData );
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.prepareGianosExecutor Start outDataContainer ' + outDataContainer );
        GianosExecutor result = new GianosExecutor( );
        //Start antonio.vatrano r1f3-134 04/10/2019
        Id inAccountId = inData.accountId;
        List<Contact> executors = new List<Contact>();
        if(inData.logReq != null){
            OB_LogRequest__c tmpLog = inData.logReq;
            if(tmpLog.OB_NewLegalRepresentative__c){
                executors = getContactFromLR(tmpLog.OB_ReducedNewData__c,RECORD_TYPE_ESECUTORE);
            }else{
                executors = getRelatedContacts( inAccountId, RECORD_TYPE_ESECUTORE );
            }
        }else{
            executors = getRelatedContacts( inAccountId, RECORD_TYPE_ESECUTORE );
        }
        //End antonio.vatrano r1f3-134 04/10/2019
        if ( executors.isEmpty( ) )
        {
            return result;
        }
        Contact executor = executors.get( 0 );
        outDataContainer.executor = executor;
        //NEXI-316 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 11/09/2019 Start (Protect against null)
        result.citizenship = executor.OB_Citizenship__c == null ? '' : executor.OB_Citizenship__c;
        result.fiscalCode = executor.OB_Fiscal_Code__c == null ? '' : executor.OB_Fiscal_Code__c;
        result.lastName = executor.LastName == null ? '' : executor.LastName;
        result.birthDate = convertDate( executor.OB_Birth_Date__c );
        result.flagPEP = String.valueOf( executor.OB_PEP__c );
        //NEXI-289 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 04/09/2019 Start
        result.birthCountry = executor.OB_Country_Birth_Code__c == null ? '' : executor.OB_Country_Birth_Code__c;
        result.residenceAddressCountry = executor.OB_Address_Country_Code__c == null ? '' : executor.OB_Address_Country_Code__c;
        result.firstName = executor.FirstName == null ? '' : executor.FirstName;
        result.job = '';
        result.residenceAddressProvince = executor.OB_Address_State_Code__c == null ? '' : executor.OB_Address_State_Code__c;//NEXI-319 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 09/09/2019 change to code field
        //NEXI-316 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 11/09/2019 Stop
        result.tae = '';
        //NEXI-289 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 04/09/2019 Stop
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.prepareGianosExecutor Stop ' + result );
        return result;
    }

    /*******************************************************************************
    Purpose:  Method prepare actual owner data that will be send to Gianos
    Parameters: Contact inContact
    Returns: GianosOwner

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-202
    ********************************************************************************/
    private static GianosOwner prepareGianosOwner( Contact inContact )
    {
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.prepareGianosOwner Start ' + inContact );
        GianosOwner result = new GianosOwner( );
        //NEXI-316 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 11/09/2019 Start (Protect against null)
        result.citizenship = inContact.OB_Citizenship__c == null ? '' : inContact.OB_Citizenship__c;
        result.fiscalCode = inContact.OB_Fiscal_Code__c == null ? '' : inContact.OB_Fiscal_Code__c;
        result.lastName = inContact.LastName == null ? '' : inContact.LastName;
        //NEXI-289 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 04/09/2019 Start
        result.birthDate = convertDate( inContact.OB_Birth_Date__c );
        result.flagPEP = String.valueOf( inContact.OB_PEP__c );
        result.birthCountry = inContact.OB_Country_Birth_Code__c == null ? '' : inContact.OB_Country_Birth_Code__c;
        result.residenceAddressCountry = inContact.OB_Address_Country_Code__c == null ? '' : inContact.OB_Address_Country_Code__c;
        result.firstName = inContact.FirstName == null ? '' : inContact.FirstName;
        result.residenceAddressProvince = inContact.OB_Address_State_Code__c == null ? '' : inContact.OB_Address_State_Code__c;//NEXI-319 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 09/09/2019 change to code field
        //NEXI-289 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 04/09/2019 Stop
        //NEXI-316 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 11/09/2019 Stop
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.prepareGianosOwner Stop ' + result );
        return result;
    }

    /*******************************************************************************
    Purpose:  Method prepare actual owners data that will be send to Gianos
    Parameters: Id inAccountId, DataWrapperForUpdate outDataContainer
    Returns: List<GianosOwner>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-202
    1.1         Antonio.Vatrano         03/10/2019      change          R1f3-134
    ********************************************************************************/
    private static List<GianosOwner> prepareGianosOwners( InputDataWrapper inData, DataWrapperForUpdate outDataContainer )
    {
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.prepareGianosOwners Start inAccountId ' + inData );
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.prepareGianosOwners Start outDataContainer ' + outDataContainer );
        List<GianosOwner> result = new List<GianosOwner>( );
        //STart  antonio.vatrano r1f3-134 04/10/2019
        Id inAccountId = inData.accountId;
        List<Contact> gianosOwnersContacts = new List<Contact>();
        if(inData.logReq != null){
            OB_LogRequest__c tmpLog = inData.logReq;
            if(tmpLog.OB_NewLegalRepresentative__c){
                gianosOwnersContacts = getContactFromLR(tmpLog.OB_ReducedNewData__c,RECORD_TYPE_TITOLARE_EFFETTIVO);
            }else{
                gianosOwnersContacts = getRelatedContacts( inAccountId, RECORD_TYPE_TITOLARE_EFFETTIVO );
            }
        }else{
            gianosOwnersContacts = getRelatedContacts( inAccountId, RECORD_TYPE_TITOLARE_EFFETTIVO );
        }
        //End  antonio.vatrano r1f3-134 04/10/2019
        for ( Contact loopContact : gianosOwnersContacts )
        {
            result.add( prepareGianosOwner( loopContact ) );
        }
        outDataContainer.owners = gianosOwnersContacts;
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.prepareGianosOwners Stop ' + result );
        return result;
    }

    /*******************************************************************************
    Purpose:  Method convert DB date into integrationData for some specific fields and validate country fields
    Parameters: GianosRequest inOutGianosRequest
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       03/09/2019      Created         NEXI-289
    1.0         Adrian Dlugolecki       11/09/2019      Change          NEXI-316 null check changed to string ones
    ********************************************************************************/
    private static void convertDbData( GianosRequest inOutGianosRequest )
    {
        String spazio = 'SPAZIO';
        String si = 'SI';
        String no = 'NO';
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.convertDbData Start ' + inOutGianosRequest );
        inOutGianosRequest.merchant.flagPEP = 'null'.equalsIgnoreCase( inOutGianosRequest.merchant.flagPEP ) ? spazio : ( 'true'.equalsIgnoreCase( inOutGianosRequest.merchant.flagPEP ) ? si : no );
        inOutGianosRequest.merchant.employeesNumber = 'Minore di 10'.equalsIgnoreCase( inOutGianosRequest.merchant.employeesNumber ) ? '0' : ( 'Maggiore uguale di 10'.equalsIgnoreCase( inOutGianosRequest.merchant.employeesNumber ) ? '1' : '2' );
        inOutGianosRequest.executor.flagPEP = 'null'.equalsIgnoreCase( inOutGianosRequest.executor.flagPEP ) ? spazio : ( 'true'.equalsIgnoreCase( inOutGianosRequest.executor.flagPEP ) ? si : no );

        List<Boolean> aoCitizenship = new List<Boolean>( );
        List<Boolean> aoResidenceAddressCountry = new List<Boolean>( );
        List<Boolean> aoBirthCountry = new List<Boolean>( );

        Set<String> countryToSearch = new Set<String>( );
        Set<String> countryLongToSearch = new Set<String>( );
        countryToSearch.add( inOutGianosRequest.merchant.headOfficeCountry );
        countryToSearch.add( inOutGianosRequest.merchant.registeredOfficeAddressCountry );
        countryLongToSearch.add( inOutGianosRequest.executor.citizenship );
        countryToSearch.add( inOutGianosRequest.executor.residenceAddressCountry );
        for ( GianosOwner loopGianosOwner : inOutGianosRequest.actualOwners )
        {
            loopGianosOwner.flagPEP = 'null'.equalsIgnoreCase( loopGianosOwner.flagPEP ) ? spazio : ( 'true'.equalsIgnoreCase( loopGianosOwner.flagPEP ) ? si : no );
            countryLongToSearch.add( loopGianosOwner.citizenship );
            countryToSearch.add( loopGianosOwner.birthCountry );
            countryToSearch.add( loopGianosOwner.residenceAddressCountry );
            aoCitizenship.add( String.isBlank( loopGianosOwner.citizenship ) );
            aoBirthCountry.add( String.isBlank( loopGianosOwner.birthCountry ) );
            aoResidenceAddressCountry.add( String.isBlank( loopGianosOwner.residenceAddressCountry ) );
        }
        countryToSearch.remove( null );
        //NEXI-319 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 09/09/2019 Start (Change country select and convert country name into iso code
        List<NE__Lov__c> countryLove =
        [
                SELECT NE__Value1__c,
                        NE__Value2__c,
                        NE__Value3__c
                FROM NE__Lov__c
                WHERE Name = 'COUNTRY'
                AND ( NE__Value1__c IN :countryToSearch
                OR NE__Value2__c IN :countryToSearch)
                LIMIT 50000
        ];
        Boolean headOfficeCountryCheck = String.isBlank( inOutGianosRequest.merchant.headOfficeCountry );
        Boolean registeredOfficeAddressCountryCheck = String.isBlank( inOutGianosRequest.merchant.registeredOfficeAddressCountry );
        Boolean executorCitizenshipCheck = String.isBlank( inOutGianosRequest.executor.citizenship );
        Boolean executorResidenceAddressCountryCheck = String.isBlank( inOutGianosRequest.executor.residenceAddressCountry );
        Boolean executorBirthCountryCheck = String.isBlank( inOutGianosRequest.executor.birthCountry );

        for ( NE__Lov__c loopLove : countryLove )
        {
            if ( !headOfficeCountryCheck && loopLove.NE__Value2__c.equalsIgnoreCase( inOutGianosRequest.merchant.headOfficeCountry ) )
            {
                inOutGianosRequest.merchant.headOfficeCountry = loopLove.NE__Value3__c;
                headOfficeCountryCheck = true;
            }
            if ( !registeredOfficeAddressCountryCheck && loopLove.NE__Value2__c.equalsIgnoreCase( inOutGianosRequest.merchant.registeredOfficeAddressCountry ) )
            {
                inOutGianosRequest.merchant.registeredOfficeAddressCountry = loopLove.NE__Value3__c;
                registeredOfficeAddressCountryCheck = true;
            }
            if ( !executorCitizenshipCheck && loopLove.NE__Value1__c.equalsIgnoreCase( inOutGianosRequest.executor.citizenship ) )
            {
                inOutGianosRequest.executor.citizenship = loopLove.NE__Value3__c;
                executorCitizenshipCheck = true;
            }
            if ( !executorResidenceAddressCountryCheck && loopLove.NE__Value2__c.equalsIgnoreCase( inOutGianosRequest.executor.residenceAddressCountry ) )
            {
                inOutGianosRequest.executor.residenceAddressCountry = loopLove.NE__Value3__c;
                executorResidenceAddressCountryCheck = true;
            }
            if ( !executorBirthCountryCheck && loopLove.NE__Value2__c.equalsIgnoreCase( inOutGianosRequest.executor.birthCountry ) )
            {
                inOutGianosRequest.executor.birthCountry = loopLove.NE__Value3__c;
                executorBirthCountryCheck = true;
            }
            for ( Integer i = 0; i < inOutGianosRequest.actualOwners.size( ); i++ )
            {
                if ( !aoCitizenship[ i ] && loopLove.NE__Value1__c.equalsIgnoreCase( inOutGianosRequest.actualOwners[ i ].citizenship ) )
                {
                    inOutGianosRequest.actualOwners[ i ].citizenship = loopLove.NE__Value3__c;
                    aoCitizenship[ i ] = true;
                }
                if ( !aoBirthCountry[ i ] && loopLove.NE__Value2__c.equalsIgnoreCase( inOutGianosRequest.actualOwners[ i ].birthCountry ) )
                {
                    inOutGianosRequest.actualOwners[ i ].birthCountry = loopLove.NE__Value3__c;
                    aoBirthCountry[ i ] = true;
                }
                if ( !aoResidenceAddressCountry[ i ] && loopLove.NE__Value2__c.equalsIgnoreCase( inOutGianosRequest.actualOwners[ i ].residenceAddressCountry ) )
                {
                    inOutGianosRequest.actualOwners[ i ].residenceAddressCountry = loopLove.NE__Value3__c;
                    aoResidenceAddressCountry[ i ] = true;
                }
            }
        }
        //NEXI-319 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 09/09/2019 Stop

        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.convertDbData headOfficeCountryCheck ' + headOfficeCountryCheck );
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.convertDbData registeredOfficeAddressCountryCheck ' + registeredOfficeAddressCountryCheck );
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.convertDbData executorCitizenshipCheck ' + executorCitizenshipCheck );
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.convertDbData executorResidenceAddressCountryCheck ' + executorResidenceAddressCountryCheck );
        if ( !( headOfficeCountryCheck && registeredOfficeAddressCountryCheck && executorCitizenshipCheck && executorResidenceAddressCountryCheck ) )
        {
            System.debug( LoggingLevel.ERROR, 'OB_Util009_Gianos.convertDbData Stop bad country data merchant ' + inOutGianosRequest.merchant + ' executor ' + inOutGianosRequest.executor );
            throw new GianosException( '[EXC]Gianos Validation failed' );
        }
        for ( Integer i = 0; i < inOutGianosRequest.actualOwners.size( ); i++ )
        {
            System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.convertDbData aoCitizenship[' + i + '] ' + aoCitizenship[ i ] );
            System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.convertDbData aoCitizenship[' + i + '] ' + aoBirthCountry[ i ] );
            System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.convertDbData aoCitizenship[' + i + '] ' + aoResidenceAddressCountry[ i ] );
            if ( !( aoCitizenship[ i ] && aoBirthCountry[ i ] && aoResidenceAddressCountry[ i ] ) )
            {
                System.debug( LoggingLevel.ERROR, 'OB_Util009_Gianos.convertDbData Stop bad country data ' + inOutGianosRequest.actualOwners[ i ] );
                throw new GianosException( '[EXC]Gianos Validation failed' );
            }
        }
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.convertDbData Stop ' + inOutGianosRequest );
    }


    /*******************************************************************************
    Purpose:  Method gather all prepared data into one main request
    Parameters: InputDataWrapper inData, DataWrapperForUpdate outDataContainer
    Returns: GianosRequest

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-202
    1.1         Antonio Vatrano         04/10/2019      Change           r1f3-134
    ********************************************************************************/
    private static GianosRequest prepareMainInputData( InputDataWrapper inData, DataWrapperForUpdate outDataContainer )
    {
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.prepareMainInputData Start inData ' + inData );
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.prepareMainInputData Start outDataContainer ' + outDataContainer );
        GianosRequest requestToGianos = new GianosRequest( );
        requestToGianos.merchant = prepareGianosMerchant( inData, outDataContainer );// Antonio.vatrano r1f3-134 04/10/2019
        requestToGianos.executor = prepareGianosExecutor( inData, outDataContainer );// Antonio.vatrano r1f3-134 04/10/2019
        requestToGianos.merchant.flagPEP = requestToGianos.executor.flagPEP;
        requestToGianos.actualOwners = prepareGianosOwners( inData, outDataContainer );
        convertDbData( requestToGianos );//NEXI-289 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 04/09/2019
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.prepareMainInputData Stop ' + requestToGianos );
        return requestToGianos;
    }

    /*******************************************************************************
    Purpose:  Class that is wrapper for required data (account id and if needed mcc)
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-202
    ********************************************************************************/
    private class InputDataWrapper
    {
        Id accountId;
        String mcc;
        OB_LogRequest__c logReq; //antonio.vatrano r1f3-134 04/10/2019
    }

    /*******************************************************************************
    Purpose:  Method select Account id and if needed mcc
    Parameters: Id inLogRequestOrOrderHeaderId, Boolean isLogRequeuest
    Returns: InputDataWrapper

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-202
    ********************************************************************************/
    private static InputDataWrapper getAccountIdAndMcc( Id inLogRequestOrOrderHeaderId, Boolean isLogRequeuest )
    {
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.getAccountIdAndMcc Start inLogRequestOrOrderHeaderId ' + inLogRequestOrOrderHeaderId );
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.getAccountIdAndMcc Start isLogRequeuest ' + isLogRequeuest );
        InputDataWrapper result = new InputDataWrapper( );
        if ( isLogRequeuest )
        {
            //antonio.vatrano r1f3-134 04/10/2019 add fields
            List<OB_LogRequest__c> logRequests =
            [
                    SELECT OB_AccountId__c,
                            OB_ReducedNewData__c, 
                            OB_NewLegalRepresentative__c, 
                            OB_Change_of_data_of_beneficial_owners__c
                    FROM OB_LogRequest__c
                    WHERE Id = :inLogRequestOrOrderHeaderId
            ];
            if ( logRequests.isEmpty( ) )
            {
                System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.getAccountIdAndMcc Stop no log request' );
                return result;
            }
            result.accountId = logRequests.get( 0 ).OB_AccountId__c;
            result.logReq = logRequests.get( 0 ); //antonio.vatrano r1f3-134 04/10/2019
        }
        else
        {
            List<NE__Order_Header__c> orderHeaders =
            [
                    SELECT NE__AccountId__c
                    FROM NE__Order_Header__c
                    WHERE Id = :inLogRequestOrOrderHeaderId
            ];
            if ( orderHeaders.isEmpty( ) )
            {
                System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.getAccountIdAndMcc Stop no order header' );
                return result;
            }
            result.accountId = orderHeaders.get( 0 ).NE__AccountId__c;
            List<NE__Order__c> relatedOrders = [ SELECT OB_MCC__c FROM NE__Order__c WHERE NE__Order_Header__c = :inLogRequestOrOrderHeaderId ];
            result.mcc = relatedOrders.isEmpty( ) ? null : relatedOrders.get( 0 ).OB_MCC__c;
        }
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.getAccountIdAndMcc Stop ' + result );
        return result;
    }

    /*******************************************************************************
    Purpose:  Method make callout to Gianos
    Parameters: GianosRequest inData, Id inObjectId
    Returns: HTTPResponse

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-202
    1.1         Adrian Dlugolecki       11/09/2019      Change          NEXI-316 remove timeout
    ********************************************************************************/
    private static HTTPResponse callGianos( GianosRequest inData, Id inObjectId )
    {
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.callGianos Start inData ' + inData );
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.callGianos Start inObjectId ' + inObjectId );
        HttpRequest requestToGianos = new HttpRequest( );
        requestToGianos.setEndpoint( 'callout:OB_callGianos' );
        requestToGianos.setMethod( OB_UtilityConstants.METHOD_POST );
        String token = OB_UtilityCallingServices.checkToken( );
        requestToGianos.setHeader( OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX + token );
        requestToGianos.setHeader( 'Content-Type', 'application/json' );
        String dataToSendJson = JSON.serialize( inData );
        requestToGianos.setBody( dataToSendJson );
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.callGianos data send ' + dataToSendJson );
        Http http = new Http( );
        Datetime dateNow = Datetime.now( );
        Integer startCall = dateNow.millisecond( );
        HTTPResponse gianosResponse = http.send( requestToGianos );
        Plc_LogHelper.LogStructure logStructure = new Plc_LogHelper.LogStructure( );
        dateNow = Datetime.now( );
        logStructure.processingTime = String.valueOf( dateNow.millisecond( ) - startCall );
        logStructure.httpMethod = OB_UtilityConstants.METHOD_POST;
        logStructure.requestUri = 'callout:OB_callGianos';
        logStructure.requestBody = String.ValueOf( requestToGianos.getBody( ) );
        logStructure.responseBody = gianosResponse.getBody( );
        logStructure.responseMessage = gianosResponse.toString( );
        logStructure.responseStatus = gianosResponse.getStatusCode( ) != 201 ? 'W' : 'S';
        logStructure.responseStackTrace = String.valueOf( gianosResponse.getStatusCode( ) );
        logStructure.recordUrl = URL.getOrgDomainUrl( ).toString( ) + '/' + String.valueOf( inObjectId );
        Id plcId = Plc_LogHelper.logCall( logStructure ); //francesca.ribezzi 26/09/19 - F2WAVE2-189 - logCall returns the plc id
        //francesca.ribezzi 26/09/19 - F2WAVE2-189 - updating the new plcLog:
     	OB_Utility.updateLogRequestOrderIdOnPlcLog(plcId, inObjectId);   
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.callGianos Stop ' + gianosResponse );
        return gianosResponse;
    }

    /*******************************************************************************
    Purpose:  Main Method that prepare data and send it to Gianos and handle response
    Parameters: Id inLogRequestOrOrderHeaderId, Boolean isLogRequeuest
    Returns: Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-202
    ********************************************************************************/
    public static Boolean callToGianos( Id inLogRequestOrOrderHeaderId, Boolean isLogRequeuest )
    {
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.callToGianos Start inLogRequestOrOrderHeaderId ' + inLogRequestOrOrderHeaderId );
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.callToGianos Start isLogRequeuest ' + isLogRequeuest );
        try
        {
            OB_ConfigurationInformation__mdt listOfConfigurationInformations =
            [
                    SELECT OB_String_Value__c,
                            OB_String_Value_2__c
                    FROM OB_ConfigurationInformation__mdt
                    WHERE QualifiedApiName = 'OB_GianosIntegration'
                    LIMIT 1
            ];
            if ( !Boolean.valueOf( listOfConfigurationInformations.OB_String_Value__c ) && !Test.isRunningTest( ) || ( Test.isRunningTest( ) && mockResponse ) )
            {
                return mockResponse( inLogRequestOrOrderHeaderId, isLogRequeuest, listOfConfigurationInformations.OB_String_Value_2__c );
            }
            if ( isLogRequeuest == null || inlogRequestorOrderHeaderId == null )
            {
                return false;
            }
            DataWrapperForUpdate dataContainer = new DataWrapperForUpdate( );
            InputDataWrapper inputData = getAccountIdAndMcc( inLogRequestOrOrderHeaderId, isLogRequeuest );
            GianosRequest dataToSend = prepareMainInputData( inputData, dataContainer );
            HTTPResponse gianosResponseObject = callGianos( dataToSend, inLogRequestOrOrderHeaderId );
            if ( gianosResponseObject.getStatusCode( ) == 200 )
            {
                handlerGianosResponse( gianosResponseObject, dataContainer, inLogRequestOrOrderHeaderId, isLogRequeuest );
            }
            else
            {
                System.debug( LoggingLevel.ERROR, '[EXC] callGianos error response from gianos code ' + gianosResponseObject.getStatusCode( ) + ' message ' + gianosResponseObject.getStatus( ) );
            }
        } catch ( Exception ex )
        {
            System.debug( LoggingLevel.ERROR, '[EXC] Exception ' + ex.getMessage( ) + ' stacktrace ' + ex.getStackTraceString( ) );
            return false;
        }
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.callToGianos Stop OK' );
        return true;
    }

    /*******************************************************************************
    Purpose:  Class that contain response from Gianos
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-202
    ********************************************************************************/
    public class GianosResponse
    {
        public GianosResponseMerchant merchant;
        public GianosResponseExecutorOrOwner executor;
        public List<GianosResponseExecutorOrOwner> actualOwners;
        public GianosResponseError error;
    }

    /*******************************************************************************
    Purpose:  Class that contain response from Gianos - merchant part
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-202
    ********************************************************************************/
    public class GianosResponseMerchant
    {
        public String vatNumber;
        public String taxCode;
        public String range;
        public String score;
    }

    /*******************************************************************************
    Purpose:  Class that contain response from Gianos - executor or actual owner part
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-202
    ********************************************************************************/
    public class GianosResponseExecutorOrOwner
    {
        public String fiscalCode;
        public String range;
        public String score;
    }

    /*******************************************************************************
    Purpose:  Class that contain response from Gianos - error part
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-202
    ********************************************************************************/
    public class GianosResponseError
    {
        public String code;
        public String description;
        public String retCode;
    }

    /*******************************************************************************
    Purpose:  Method that handle response from Gianos (update Gianos fields)
    Parameters: HTTPResponse inResponse, DataWrapperForUpdate inDataToHandle, Id inLogRequestOrOrderHeaderId, Boolean isLogRequeuest
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-202
    1.1         Adrian Dlugolecki       26/09/2019      Changed         NEXI-350 add bypass validation
    ********************************************************************************/
    private static void handlerGianosResponse( HTTPResponse inResponse, DataWrapperForUpdate inDataToHandle, Id inLogRequestOrOrderHeaderId, Boolean isLogRequeuest )
    {
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.handlerGianosResponse Start inResponse ' + inResponse );
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.handlerGianosResponse Start inDataToHandle ' + inDataToHandle );
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.handlerGianosResponse Start inLogRequestOrOrderHeaderId ' + inLogRequestOrOrderHeaderId );
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.handlerGianosResponse Start isLogRequeuest ' + isLogRequeuest );
        //NEXI-316 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 11/09/2019 Start fix for bad gianos outcome
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.handlerGianosResponse Start inResponse.getBody( ) ' + inResponse.getBody( ) );
        GianosResponse responseWrapper = ( GianosResponse ) JSON.deserialize( inResponse.getBody( ), GianosResponse.class );//NEXI-316 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 12/09/2019 remove workaround
        //NEXI-316 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 11/09/2019 Stop
        List<SObject> objectsToUpdate = new List<SObject>( );
        //Simone Misani fix 17/10/ 20.14 START
        if(responseWrapper.error != null){
            return ;
        }
        //Simone Misani fix 17/10/ 20.14 end
        Double riskEvaluation = String.isBlank( responseWrapper.merchant.score ) ? 0.0 : Double.valueOf( responseWrapper.merchant.score );
        objectsToUpdate.add( new Account( Id = inDataToHandle.merchant.Id, OB_Gianos__c = String.valueOf( riskEvaluation ), OB_BypassValidation__c = true ) );//Simone Misani WN-411 13/09/2019

        Double tempRiskEvaluation = String.isBlank( responseWrapper.executor.score ) ? 0.0 : Double.valueOf( responseWrapper.executor.score );
        riskEvaluation = riskEvaluation < tempRiskEvaluation ? tempRiskEvaluation : riskEvaluation;
        //Start antonio.vatrano 04/10/2019 r1f3-134
        if(!String.isBlank(inDataToHandle.executor.Id)){
            objectsToUpdate.add( new Contact( Id = inDataToHandle.executor.Id, OB_Gianos__c = String.valueOf( tempRiskEvaluation ), OB_BypassValidation__c = true ) );
        }else {
             List<OB_LogRequest__c> logRequests = [ SELECT OB_ReducedNewData__c FROM OB_LogRequest__c WHERE Id = :inLogRequestOrOrderHeaderId ];
            if ( !logRequests.isEmpty( ) )
            {
                String jsonString = logRequests.get(0).OB_ReducedNewData__c;
                Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
                List<Contact> lisCon =(List<Contact>) JSON.deserialize(JSON.serialize(jsonMap.get('obj')),List<Contact>.class);
                for ( Contact loopContact : lisCon )
                {
                    if(loopContact.OB_Fiscal_Code__c == inDataToHandle.executor.OB_Fiscal_Code__c){
                        loopContact.OB_Gianos__c = String.valueOf(tempRiskEvaluation);
                    }
                }
                jsonMap.put('obj', lisCon);
                logRequests.get(0).OB_ReducedNewData__c = JSON.serialize(jsonMap);
                update logRequests;
            }
        }
        //END antonio.vatrano 04/10/2019 r1f3-134

        Map<String, Id> contactIdByFiscalCode = new Map<String, Id>( );
        for ( Contact loopContact : inDataToHandle.owners )
        {
            contactIdByFiscalCode.put( loopContact.OB_Fiscal_Code__c, loopContact.Id );
        }
        Set<Id> contactsToUpdateSaveGuard = new Set<Id>( );
        if(responseWrapper.actualOwners != null){  //antonio.vatrano 03/09/2019 r1f3-132
            for ( GianosResponseExecutorOrOwner loopOwner : responseWrapper.actualOwners )
            {
                tempRiskEvaluation = String.isBlank( loopOwner.score ) ? 0.0 : Double.valueOf( loopOwner.score );
                riskEvaluation = riskEvaluation < tempRiskEvaluation ? tempRiskEvaluation : riskEvaluation;
                Id contactId = contactIdByFiscalCode.get( loopOwner.fiscalCode );
                if ( contactId != null && !contactsToUpdateSaveGuard.contains( contactId ) )
                {
                    objectsToUpdate.add( new Contact( Id = contactId, OB_Gianos__c = String.valueOf( tempRiskEvaluation ), OB_BypassValidation__c = true ) );
                    contactsToUpdateSaveGuard.add( contactId );
                }
            }
        }  //antonio.vatrano 03/09/2019 r1f3-132
        if ( isLogRequeuest )
        {
            objectsToUpdate.add( new OB_LogRequest__c( Id = inLogRequestOrOrderHeaderId, OB_Gianos__c = String.valueOf( riskEvaluation ) ) );
        }
        else
        {
            objectsToUpdate.add( new NE__Order_Header__c( Id = inLogRequestOrOrderHeaderId, OB_Gianos__c = String.valueOf( riskEvaluation ) ) );
        }
        System.debug( LoggingLevel.FINE, 'OB_Util009_Gianos.handlerGianosResponse Stop ' + objectsToUpdate );
        update objectsToUpdate;
    }

    /*******************************************************************************
    Purpose:  Mock method for Gianos response
    Parameters: Id inLogRequestOrOrderHeaderId, Boolean isLogRequeuest, String inGianosValue
    Returns: Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       22/07/2019      Created         NEXI-202
    ********************************************************************************/
    @TestVisible
    private static Boolean mockResponse( Id inLogRequestOrOrderHeaderId, Boolean isLogRequeuest, String inGianosValue )
    {
        if ( isLogRequeuest )
        {
            update new OB_LogRequest__c( Id = inLogRequestOrOrderHeaderId, OB_Gianos__c = inGianosValue );
        }
        else
        {
            update new NE__Order_Header__c( Id = inLogRequestOrOrderHeaderId, OB_Gianos__c = inGianosValue );
        }
        return true;
    }

    /*******************************************************************************
    Purpose:  retrieve contact from Logrequest reduceNewData
    Parameters: String strJson
    Returns: List<Contact>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Antonio.Vatrano       04/10/2019      Created           R1F3-134
    ********************************************************************************/
    @TestVisible
    private static List<Contact> getContactFromLR(String strJson, Id inRecordtypeId ){
        List<Contact> toReturn = new List<Contact>();
        Map<String, Object> reduceMap = (Map<String, Object>) JSON.deserializeUntyped(strJson);
        List<Contact> lisCon =(List<Contact>) JSON.deserialize(JSON.serialize(reduceMap.get('obj')),List<Contact>.class);
        for(Contact c : lisCon){
            if(c.OB_Contact_State__c == 'Active' && c.RecordTypeId == inRecordtypeId){
                toReturn.add(c);
            }
        }
        return toReturn;
    }

}