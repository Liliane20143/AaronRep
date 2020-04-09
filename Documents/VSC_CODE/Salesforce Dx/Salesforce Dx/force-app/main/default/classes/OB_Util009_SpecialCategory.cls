/*********************************************************************
Name:  OB_Util009_SpecialCategory
======================================================================
History

  AUTHOR            DATE CREATED        DESCRIPTION
  Szuba          	25/07/2019			Class for checking special categories of Log Requests and OrderHeaders
  Wojciech

**********************************************************************/
public without sharing class OB_Util009_SpecialCategory
{
    /*******************************************************************************
    Purpose:  Wrapper for OB_Utility.detectSpecialCategory method

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba         	25/07/2019      Created         NEXI-208
    ********************************************************************************/
    public class SpecialCategoryWrapper
    {
        public Id objectId;
        public Id objectAccountId;
        public String accountLegalForm;
        public String accountLegalFormCode;
        public String accountCodeATECO;
        public String accountCodeSAE;
        public Boolean accountCrowdfunding;
        public String accountDescriptionVatNotPresent;
        public Boolean gambling;
        public Boolean fiduciarie;
        public Boolean onlus;
        public Boolean moneytransfer;
        public Boolean trust;
        public Boolean crowdfunding;
        public Boolean isLogRequest;
        public Boolean isOrderHeader;
        public Boolean isChange;
        public List<String> categoriesForThisObject;

        public SpecialCategoryWrapper( )
        {
            this.objectId = null;
            this.objectAccountId = null;
            this.accountLegalForm = '';
            this.accountLegalFormCode = '';
            this.accountCodeATECO = '';
            this.accountCodeSAE = '';
            this.accountCrowdfunding = false;
            this.accountDescriptionVatNotPresent = '';
            this.gambling = false;
            this.fiduciarie = false;
            this.onlus = false;
            this.moneytransfer = false;
            this.trust = false;
            this.crowdfunding = false;
            this.isLogRequest = false;
            this.isOrderHeader = false;
            this.isChange = false;
            this.categoriesForThisObject = new List<String>( );
        }

    }
    /*******************************************************************************
    Purpose:  Method to detect special category from Order Header or Log Request
    Parameters: List<Id> dectectedId
    Returns: Map<Id, List<String>>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Zuzanna Urban          	16/07/2019      Created         NEXI-208
    2.0         Wojciech Szuba          25/07/2019      Modified        NEXI-208
    ********************************************************************************/
    public static Map<Id, List<String>> detectSpecialCategory( List<Id> detectedIdList )
    {
        if ( detectedIdList.isEmpty( ) )
        {
            System.debug( LoggingLevel.ERROR, 'OB_Util009_SpecialCategory.detectSpecialCategory - Parameter is null' );
            return new Map<Id, List<String>>( );
        }
        Set<Id> logRequestIds = new Set<Id>( );
        Set<Id> orderHeaderIds = new Set<Id>( );
        List<SpecialCategoryWrapper> objectsWrapperList = new List<SpecialCategoryWrapper>( );
        String objectTypeString;
        for ( Id detectedId : detectedIdList )
        {
            objectTypeString = String.valueOf( detectedId.getSobjectType( ) );
            if ( OB_UtilityConstants.LOG_REQUEST_OBJECT.equals( objectTypeString ) )
            {
                logRequestIds.add( detectedId );
            }
            else if ( OB_UtilityConstants.ORDER_HEADER_OBJECT.equals( objectTypeString ) )
            {
                orderHeaderIds.add( detectedId );
            }
            else
            {
                System.debug( LoggingLevel.INFO, 'OB_Util009_SpecialCategory.detectSpecialCategory - Incorrect sObject type in list' );
            }
        }
        logRequestIds.remove( null );
        List<OB_LogRequest__c> listOfLogRequests = getLogRequestsList( logRequestIds );
        orderHeaderIds.remove( null );
        List<NE__Order_Header__c> listOfOrderHeaders = getOrderHeadersList( orderHeaderIds );
        SpecialCategoryWrapper objectWrapper;
        if ( !listOfLogRequests.isEmpty( ) )
        {
            objectWRapper = new SpecialCategoryWrapper( );
            for ( OB_LogRequest__c singleLogRequest : listOfLogRequests )
            {
                objectWrapper = populateObjectWrapperWithLogRequestData( singleLogRequest );
                objectsWrapperList.add( objectWrapper );
            }
        }
        else if ( !listOfOrderHeaders.isEmpty( ) )
        {
            objectWrapper = new SpecialCategoryWrapper( );
            for ( NE__Order_Header__c singleOrderHeader : listOfOrderHeaders )
            {
                objectWrapper = populateObjectWrapperWithOrderHeaderData( singleOrderHeader );
                objectsWrapperList.add( objectWrapper );
            }
        }
        else
        {
            System.debug( LoggingLevel.INFO, 'OB_Util009_SpecialCategory.detectSpecialCategory - There is no OrderHeader or LogRequest with given Id' );
            return new Map<Id, List<String>>( );
        }
        try
        {
            return checkObjectSpecialCategory( objectsWrapperList );
        } catch ( Exception ex )
        {
            System.debug( LoggingLevel.ERROR, '[EXC] Exception ' + ex.getMessage( ) + ' stacktrace ' + ex.getStackTraceString( ) );
            return new Map<Id, List<String>>( );
        }
    }

    /*******************************************************************************
    Purpose:  Method that populates fields of SpecialCategoryWrapper with Log Request data
    Parameters: OB_LogRequest__c singleLogRequest
    Returns: SpecialCategoryWrapper

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba          25/07/2019      Created         NEXI-208
    1.1         Joanna Mielczarek       13/09/2019      Modified        NEXI-318 trim value to avoid whitespaces
    ********************************************************************************/
    private static SpecialCategoryWrapper populateObjectWrapperWithLogRequestData( OB_LogRequest__c singleLogRequest )
    {
        SpecialCategoryWrapper objectWrapper = new SpecialCategoryWrapper( );
        objectWrapper.objectId = singleLogRequest.Id;
        objectWrapper.objectAccountId = singleLogRequest.OB_AccountId__c;
        objectWrapper.accountLegalForm = trimValue( singleLogRequest.OB_AccountId__r.OB_Legal_Form__c );
        objectWrapper.accountLegalFormCode = trimValue( singleLogRequest.OB_AccountId__r.OB_Legal_Form_Code__c );
        objectWrapper.accountCodeSAE = trimValue( singleLogRequest.OB_AccountId__r.OB_SAE_Code__c );
        objectWrapper.accountCodeATECO = trimValue( singleLogRequest.OB_AccountId__r.OB_ATECO__c );
        objectWrapper.accountCrowdfunding = singleLogRequest.OB_AccountId__r.OB_IsCrowdfunding__c;
        objectWrapper.accountDescriptionVatNotPresent = singleLogRequest.OB_AccountId__r.OB_DescriptionVATNotPresent__c;
        objectWrapper.gambling = singleLogRequest.OB_isGambling__c;
        objectWrapper.fiduciarie = singleLogRequest.OB_Fiduciarie__c;
        objectWrapper.onlus = singleLogRequest.OB_Onlus__c;
        objectWrapper.moneytransfer = singleLogRequest.OB_Moneytransfer__c;
        objectWrapper.trust = singleLogRequest.OB_Trust__c;
        objectWrapper.crowdfunding = singleLogRequest.OB_Crowdfunding__c;
        objectWrapper.isLogRequest = true;
        return objectWrapper;
    }

    /*******************************************************************************
    Purpose:  Method that populates fields of SpecialCategoryWrapper with Order Header data
    Parameters: OB_LogRequest__c singleLogRequest
    Returns: SpecialCategoryWrapper

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba          25/07/2019      Created         NEXI-208
    1.1         Joanna Mielczarek       13/09/2019      Modified        NEXI-318 trim value to avoid whitespaces
    ********************************************************************************/
    private static SpecialCategoryWrapper populateObjectWrapperWithOrderHeaderData( NE__Order_Header__c singleOrderHeader )
    {
        SpecialCategoryWrapper objectWrapper = new SpecialCategoryWrapper( );
        objectWrapper.objectId = singleOrderHeader.Id;
        objectWrapper.objectAccountId = singleOrderHeader.NE__AccountId__c;
        objectWrapper.accountLegalForm = trimValue( singleOrderHeader.NE__AccountId__r.OB_Legal_Form__c );
        objectWrapper.accountLegalFormCode = trimValue( singleOrderHeader.NE__AccountId__r.OB_Legal_Form_Code__c );
        objectWrapper.accountCodeSAE = trimValue( singleOrderHeader.NE__AccountId__r.OB_SAE_Code__c );
        objectWrapper.accountCodeATECO = trimValue( singleOrderHeader.NE__AccountId__r.OB_ATECO__c );
        objectWrapper.accountCrowdfunding = singleOrderHeader.NE__AccountId__r.OB_IsCrowdfunding__c;
        objectWrapper.accountDescriptionVatNotPresent = singleOrderHeader.NE__AccountId__r.OB_DescriptionVATNotPresent__c;
        objectWrapper.gambling = singleOrderHeader.OB_Gambling__c;
        objectWrapper.fiduciarie = singleOrderHeader.OB_Fiduciarie__c;
        objectWrapper.onlus = singleOrderHeader.OB_Onlus__c;
        objectWrapper.moneytransfer = singleOrderHeader.OB_Moneytransfer__c;
        objectWrapper.trust = singleOrderHeader.OB_Trust__c;
        objectWrapper.crowdfunding = singleOrderHeader.OB_Crowdfunding__c;
        objectWrapper.isOrderHeader = true;
        return objectWrapper;
    }

    /*******************************************************************************
    Purpose:  Method that returns the list of Log Requests
    Parameters: Set<Id> setOfIds
    Returns: List<OB_LogRequest__c>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba          25/07/2019      Created         NEXI-208
    ********************************************************************************/
    private static List<OB_LogRequest__c> getLogRequestsList( Set<Id> setOfIds )
    {
        List<OB_LogRequest__c> listOfLogRequests =
        [
                SELECT Id,
                        OB_AccountId__c,
                        OB_AccountId__r.OB_Legal_Form__c,
                        OB_AccountId__r.OB_Legal_Form_Code__c,
                        OB_AccountId__r.OB_SAE_Code__c,
                        OB_AccountId__r.OB_ATECO__c,
                        OB_AccountId__r.OB_IsCrowdfunding__c,
                        OB_AccountId__r.OB_DescriptionVATNotPresent__c,
                        OB_isGambling__c,
                        OB_Fiduciarie__c,
                        OB_Onlus__c,
                        OB_Moneytransfer__c,
                        OB_Trust__c,
                        OB_Crowdfunding__c
                FROM OB_LogRequest__c
                WHERE Id IN :setOfIds
                LIMIT 50000
        ];
        return listOfLogRequests;
    }

    /*******************************************************************************
    Purpose:  Method that returns the list of Order Headers
    Parameters: Set<Id> setOfIds
    Returns: List<NE__Order_Header__c>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba          25/07/2019      Created         NEXI-208
    ********************************************************************************/
    private static List<NE__Order_Header__c> getOrderHeadersList( Set<Id> setOfIds )
    {
        List<NE__Order_Header__c> listOfOrderHeaders =
        [
                SELECT Id,
                        NE__AccountId__c,
                        NE__AccountId__r.OB_Legal_Form__c,
                        NE__AccountId__r.OB_Legal_Form_Code__c,
                        NE__AccountId__r.OB_SAE_Code__c,
                        NE__AccountId__r.OB_ATECO__c,
                        NE__AccountId__r.OB_IsCrowdfunding__c,
                        NE__AccountId__r.OB_DescriptionVATNotPresent__c,
                        OB_Gambling__c,
                        OB_Fiduciarie__c,
                        OB_Onlus__c,
                        OB_Moneytransfer__c,
                        OB_Trust__c,
                        OB_Crowdfunding__c
                FROM NE__Order_Header__c
                WHERE Id IN :setOfIds
                LIMIT 50000
        ];
        return listOfOrderHeaders;
    }

    /*******************************************************************************
    Purpose:  Method to check special category for Log Request and/or Order Header
    Parameters: List<SpecialCategoryWrapper> objectsWrapperList
    Returns: Map<Id, List<String>>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba          25/07/2019      Created         NEXI-208
    1.1         Joanna Mielczarek       13/09/2019      Modified        NEXI-318 equals to equalsIgnoreCase
    ********************************************************************************/
    private static Map<Id, List<String>> checkObjectSpecialCategory( List<SpecialCategoryWrapper> objectsWrapperList )
    {
        System.debug( LoggingLevel.FINE, 'CheckObjectSpecialCategory INTO method : ' + objectsWrapperList );
        if ( objectsWrapperList.isEmpty( ) )
        {
            System.debug( LoggingLevel.ERROR, 'OB_Util009_SpecialCategory.checkObjectSpecialCategory - Parameter is null' );
            return new Map<Id, List<String>>( );
        }
        Map<Id, List<String>> categoriesToReturn = new Map<Id, List<String>>( );
        List<SpecialCategoryWrapper> objectsToUpdate = new List<SpecialCategoryWrapper>( );

        for ( SpecialCategoryWrapper singleWrapper : objectsWrapperList )
        {
            singleWrapper.categoriesForThisObject = new List<String>( );
            singleWrapper.isChange = false;
            if ( isGamblingAteco( singleWrapper.accountCodeATECO ) )
            {
                singleWrapper.categoriesForThisObject.add( OB_UtilityConstants.SPECIAL_CATEGORY_GAMBLING );
                singleWrapper.gambling = true;
                singleWrapper.isChange = true;
            }
            if ( isFiduciareSae( singleWrapper.accountCodeSAE ) || isFiduciareAteco( singleWrapper.accountCodeATECO ) )
            {
                singleWrapper.categoriesForThisObject.add( OB_UtilityConstants.SPECIAL_CATEGORY_FIDUCIARIE );
                singleWrapper.fiduciarie = true;
                singleWrapper.isChange = true;
            }
            if ( ( OB_UtilityConstants.DESCRIPTIONVAT_NO_PROFIT.equalsIgnoreCase( singleWrapper.accountLegalForm )
                   && OB_UtilityConstants.LEGAL_FORM_CODE_NO_PROFIT.equalsIgnoreCase( singleWrapper.accountLegalFormCode ) )
                   || OB_UtilityConstants.DESCRIPTIONVAT_NO_PROFIT.equalsIgnoreCase( singleWrapper.accountDescriptionVatNotPresent ) )
            {
                singleWrapper.categoriesForThisObject.add( OB_UtilityConstants.SPECIAL_CATEGORY_ONLUS );
                singleWrapper.onlus = true;
                singleWrapper.isChange = true;
            }

            if ( ( OB_UtilityConstants.LEGAL_FORM_MONEY.equalsIgnoreCase( singleWrapper.accountLegalForm )
                   && OB_UtilityConstants.LEGAL_FORM_CODE_MONEY.equalsIgnoreCase( singleWrapper.accountLegalFormCode ) )
                    || isMoneytransferAteco( singleWrapper.accountCodeATECO ) )
            {
                singleWrapper.categoriesForThisObject.add( OB_UtilityConstants.SPECIAL_CATEGORY_MONEYTRANSFER );
                singleWrapper.moneytransfer = true;
                singleWrapper.isChange = true;
            }
            if ( OB_UtilityConstants.LEGAL_FORM_TRUST.equalsIgnoreCase( singleWrapper.accountLegalForm )
                 && OB_UtilityConstants.LEGAL_FORM_CODE_TRUST.equalsIgnoreCase( singleWrapper.accountLegalFormCode ) )
            {
                singleWrapper.categoriesForThisObject.add( OB_UtilityConstants.SPECIAL_CATEGORY_TRUST );
                singleWrapper.trust = true;
                singleWrapper.isChange = true;
            }
            if ( singleWrapper.accountCrowdfunding )
            {
                singleWrapper.categoriesForThisObject.add( OB_UtilityConstants.SPECIAL_CATEGORY_CROWDFUNDING );
                singleWrapper.crowdfunding = true;
                singleWrapper.isChange = true;
            }
            categoriesToReturn.put( singleWrapper.objectId, singleWrapper.categoriesForThisObject );
        }
        checkMCCisGambling( objectsWrapperList ); // NEXI-288 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 29/08/2019 changed method name
        for ( SpecialCategoryWrapper singleWrapper : objectsWrapperList )
        {
            if ( singleWrapper.isChange )
            {
                objectsToUpdate.add( singleWrapper );
            }
        }
        updateAfterSpecialCategoryCheck( objectsToUpdate );
        return categoriesToReturn;
    }

    /*******************************************************************************
    Purpose:  Method to check gambling special category for Log Request and/or Order Header from MCC
    Parameters: List<SpecialCategoryWrapper>
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba          25/07/2019      Created         NEXI-208
    1.1         Joanna Mielczarek       29/08/2019      Modified        NEXI-288 changed object to get mcc code
    ********************************************************************************/
    private static void checkMCCisGambling( List<SpecialCategoryWrapper> objectsWrapperList )
    {
        Set<Id> orderHeadersIds = new Set<Id>( );
        Set<Id> logRequestsIds = new Set<Id>( );
        for ( SpecialCategoryWrapper loopWrapper : objectsWrapperList )
        {
            if ( loopWrapper.isOrderHeader )
            {
                orderHeadersIds.add( loopWrapper.objectId );
            }
            else if ( loopWrapper.isLogRequest )
            {
                logRequestsIds.add( loopWrapper.objectId );
            }
        }
        orderHeadersIds.remove( null );
        logRequestsIds.remove( null );

        if ( orderHeadersIds.isEmpty( ) && logRequestsIds.isEmpty( ) )
        {
            return;
        }

        Map<Id, Boolean> isObjectGambling = new Map<Id, Boolean>( );
        isObjectGambling.putAll( checkGamblingOrderHeader( orderHeadersIds ) );
        isObjectGambling.putAll( checkGamblingLogRequest( logRequestsIds ) );

        for ( SpecialCategoryWrapper loopWrapper : objectsWrapperList )
        {
            if ( isObjectGambling.containsKey( loopWrapper.objectId ) && isObjectGambling.get( loopWrapper.objectId ) )
            {
                loopWrapper.gambling = true;
                loopWrapper.isChange = true;
                if ( !loopWrapper.categoriesForThisObject.contains( OB_UtilityConstants.SPECIAL_CATEGORY_GAMBLING ) )
                {
                    loopWrapper.categoriesForThisObject.add( OB_UtilityConstants.SPECIAL_CATEGORY_GAMBLING );
                }
            }
        }
    }

    /*******************************************************************************
    Purpose:  Method checks if Order related to OrderHeader is gambling
    Parameters: Set<Id> objectsIds
    Returns: Map<Id, Boolean>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       30/08/2019      Created         NEXI-288
    ********************************************************************************/
    private static Map<Id, Boolean> checkGamblingOrderHeader( Set<Id> objectsIds )
    {
        Map <Id, Boolean> isOrderHeaderGambling = new Map<Id, Boolean>( );
        Boolean isGambling;
        for ( NE__Order__c loopOrder :
        [
                SELECT OB_MCC__c,
                        NE__Order_Header__c
                FROM NE__Order__c
                WHERE NE__Order_Header__c IN :objectsIds
        ] )
        {
            isGambling = isGamblingMcc( loopOrder.OB_MCC__c );
            if ( isOrderHeaderGambling.containsKey( loopOrder.NE__Order_Header__c ) )
            {
                isOrderHeaderGambling.put( loopOrder.NE__Order_Header__c, isOrderHeaderGambling.get( loopOrder.NE__Order_Header__c ) || isGambling );
            }
            else
            {
                isOrderHeaderGambling.put( loopOrder.NE__Order_Header__c, isGambling );
            }
        }
        return isOrderHeaderGambling;
    }

    /*******************************************************************************
    Purpose:  Method checks if Order related to LogRequest is gambling
    Parameters: Set<Id> objectsIds
    Returns: Map<Id, Boolean>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       30/08/2019      Created         NEXI-288
    ********************************************************************************/
    private static Map<Id, Boolean> checkGamblingLogRequest( Set<Id> objectsIds )
    {
        Map<Id, Boolean> isLogRequestGambling = new Map<Id, Boolean>( );
        Boolean isGambling;
        for ( OB_LogRequest__c loopLogRequest :
        [
                SELECT OB_OrderId__r.OB_MCC__c
                FROM OB_LogRequest__c
                WHERE Id IN :objectsIds
        ] )
        {
            isGambling = isGamblingMcc( loopLogRequest.OB_OrderId__r.OB_MCC__c );
            if ( isLogRequestGambling.containsKey( loopLogRequest.Id ) )
            {
                isLogRequestGambling.put( loopLogRequest.Id, isLogRequestGambling.get( loopLogRequest.Id ) || isGambling );
            }
            else
            {
                isLogRequestGambling.put( loopLogRequest.Id, isGambling );
            }
        }
        return isLogRequestGambling;
    }

    /*******************************************************************************
    Purpose:  Method to update special category for Log Request and/or Order Header
    Parameters: List<SpecialCategoryWrapper>
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba          25/07/2019      Created         NEXI-208
    ********************************************************************************/
    private static void updateAfterSpecialCategoryCheck( List<SpecialCategoryWrapper> objectsToUpdate )
    {
        if ( objectsToUpdate.isEmpty( ) )
        {
            System.debug( LoggingLevel.ERROR, 'OB_Util009_SpecialCategory.updateAfterSpecialCategoryCheck - None of checked objects need an update' );
            return;
        }
        List<OB_LogRequest__c> logRequestsToUpdate = new List<OB_LogRequest__c>( );
        List<NE__Order_Header__c> orderHeadersToUpdate = new List<NE__Order_Header__c>( );
        OB_LogRequest__c singleLogRequest;
        NE__Order_Header__c singleOrderHeader;

        for ( SpecialCategoryWrapper objectToUpdate : objectsToUpdate )
        {
            if ( objectToUpdate.isLogRequest )
            {
                singleLogRequest = new OB_LogRequest__c( );
                singleLogRequest.Id = objectToUpdate.objectId;
                singleLogRequest.OB_isGambling__c = objectToUpdate.gambling;
                singleLogRequest.OB_Fiduciarie__c = objectToUpdate.fiduciarie;
                singleLogRequest.OB_Onlus__c = objectToUpdate.onlus;
                singleLogRequest.OB_Moneytransfer__c = objectToUpdate.moneytransfer;
                singleLogRequest.OB_Trust__c = objectToUpdate.trust;
                singleLogRequest.OB_Crowdfunding__c = objectToUpdate.crowdfunding;
                logRequestsToUpdate.add( singleLogRequest );
            }
            else if ( objectToUpdate.isOrderHeader )
            {
                singleOrderHeader = new NE__Order_Header__c( );
                singleOrderHeader.Id = objectToUpdate.objectId ;
                singleOrderHeader.OB_Gambling__c = objectToUpdate.gambling;
                singleOrderHeader.OB_Fiduciarie__c = objectToUpdate.fiduciarie;
                singleOrderHeader.OB_Onlus__c = objectToUpdate.onlus;
                singleOrderHeader.OB_Moneytransfer__c = objectToUpdate.moneytransfer;
                singleOrderHeader.OB_Trust__c = objectToUpdate.trust;
                singleOrderHeader.OB_Crowdfunding__c = objectToUpdate.crowdfunding;
                orderHeadersToUpdate.add( singleOrderHeader );
            }
            else
            {
                System.debug( LoggingLevel.INFO, 'OB_Util009_SpecialCategory.updateAfterSpecialCategoryCheck - Incorrect sObject type in list' );
            }
        }
        update logRequestsToUpdate;
        update orderHeadersToUpdate;
    }

    /*******************************************************************************
    Purpose:  Method checks Ateco for Special Category Gambling
    Parameters: String atecoCode
    Returns: Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Zuzanna Urban          	18/07/2019      Created         NEXI-208
    2.0         Wojciech Szuba          25/07/2019      Modified        NEXI-208
    ********************************************************************************/
    private static Boolean isGamblingAteco( String atecoCode )
    {
        List<String> atecoList = OB_UtilityConstants.ATECO_GAMBLING_LIST;
        Boolean isAteco = false;
        if ( atecoList.contains( atecoCode ) )
        {
            isAteco = true;
        }
        System.debug( LoggingLevel.FINE, 'isGambling : ' + isAteco + ' fot ateco code ' + atecoCode );
        return isAteco;
    }
    /*******************************************************************************
    Purpose:  Method checks Mcc for Special Category Gambling
    Parameters: String mccCode
    Returns: Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Zuzanna Urban          	18/07/2019      Created         NEXI-208
    2.0         Wojciech Szuba          25/07/2019      Modified        NEXI-208
    ********************************************************************************/
    private static Boolean isGamblingMcc( String mccCode )
    {
        List<String> mccList = OB_UtilityConstants.MCC_GAMBLING_LIST;
        Boolean isMcc = false;
        if ( mccList.contains( mccCode ) )
        {
            isMcc = true;
        }
        System.debug( LoggingLevel.FINE, 'isGambling : ' + isMcc + ' fot mcc code ' + mccCode );
        return isMcc;
    }

    /*******************************************************************************
    Purpose:  Method checks Sae for Special Category Fiduciare
    Parameters: String saeCode
    Returns: Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Zuzanna Urban          	18/07/2019      Created         NEXI-208
    2.0         Wojciech Szuba          25/07/2019      Modified        NEXI-208
    ********************************************************************************/
    private static Boolean isFiduciareSae( String saeCode )
    {
        List<String> saeList = OB_UtilityConstants.SAE_FIDUCIARE_LIST;
        Boolean isSae = false;
        if ( saeList.contains( saeCode ) )
        {
            isSae = true;
        }
        System.debug( LoggingLevel.FINE, 'isFiduciare : ' + isSae + ' fot sae code ' + saeCode );
        return isSae;
    }

    /*******************************************************************************
    Purpose:  Method checks Ateco for Special Category Fiduciare
    Parameters: String atecoCode
    Returns: Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Zuzanna Urban          	18/07/2019      Created         NEXI-208
    2.0         Wojciech Szuba          25/07/2019      Modified        NEXI-208
    ********************************************************************************/
    private static Boolean isFiduciareAteco( String atecoCode )
    {
        List<String> atecoList = OB_UtilityConstants.ATECO_FIDUCIARE_LIST;
        Boolean isAteco = false;
        if ( atecoList.contains( atecoCode ) )
        {
            isAteco = true;
        }
        System.debug( LoggingLevel.FINE, 'isFiduciare : ' + isAteco + ' fot ateco code ' + atecoCode );
        return isAteco;
    }

    /*******************************************************************************
    Purpose:  Method checks Ateco for Special Category Moneytransfer
    Parameters: String atecoCode
    Returns: Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Zuzanna Urban          	18/07/2019      Created         NEXI-208
    2.0         Wojciech Szuba          25/07/2019      Modified        NEXI-208
    ********************************************************************************/
    private static Boolean isMoneytransferAteco( String atecoCode )
    {
        List<String> atecoList = OB_UtilityConstants.ATECO_MONEYTRANSFER_LIST;
        Boolean isAteco = false;
        if ( atecoList.contains( atecoCode ) )
        {
            isAteco = true;
        }
        System.debug( LoggingLevel.FINE, 'isMoneyTransfer : ' + isAteco + ' fot ateco code ' + atecoCode );
        return isAteco;
    }

    /*******************************************************************************
    Purpose:    Method trims String
    Parameters: String inValue
    Returns:    String

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       13/09/2019      Created         NEXI-318
    ********************************************************************************/
    private static String trimValue( String inValue )
    {
        return String.isBlank( inValue ) ? '' : inValue.trim( );
    }
}