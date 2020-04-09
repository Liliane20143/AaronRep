/**
 * Created by adrian.dlugolecki on 07.05.2019.
 */

public without sharing class OB_LCC004_Maintenance_VarCoBa //antonio.vatrano wn-91 12/07/2019
{
    public static Id terminalRTid = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.POS_RT ).getRecordTypeId( );
    public final static String ASSET_STATUS_ACTIVE = 'Active';

    /*******************************************************************************
    Purpose:  Class that is output wrapper for searchForRacSia method
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       08/07/2019      Created         NEXI-188
    ********************************************************************************/
    public class RacSiaOutputWrapper
    {
        @AuraEnabled
        public List<String> racSiaCodes = new List<String>( );
        @AuraEnabled
        public String logRequestName;
        @AuraEnabled
        public Boolean isError;
        @AuraEnabled
        public String errorMessage;

        public RacSiaOutputWrapper( List<String> inRacSiaCodes )
        {
            racSiaCodes = inRacSiaCodes;
            isError = false;
        }

        public RacSiaOutputWrapper( String inLogRequestName )
        {
            logRequestName = inLogRequestName;
            isError = false;
        }

        public RacSiaOutputWrapper( String inErrorMessage, Boolean inIsError )
        {
            errorMessage = inErrorMessage;
            isError = inIsError;
        }
    }

    /*******************************************************************************
    Purpose:  Method search for related to service point log requests
    Parameters: inServicePointId
    Returns: String log request name or empty

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       08/07/2019      Created         NEXI-188
    ********************************************************************************/
    private static String checkForExistingLogRequest( String inServicePointId )
    {
        List<OB_LogRequest__c> logRequestsToCheck =
        [
                SELECT Name
                FROM OB_LogRequest__c
                WHERE OB_ServicePointId__c = :inServicePointId
                AND OB_Status__c != :OB_UtilityConstants.CONFERMATO
                LIMIT 1
        ];
        return logRequestsToCheck.isEmpty( ) ? '' : logRequestsToCheck.get( 0 ).Name;
    }

    /*******************************************************************************
    Purpose:  Method search for all Rac Sia codes for given service point
    Parameters: String inServicePointId
    Returns: RacSiaOutputWrapper

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       13/05/2019      Created         NEXI-33
    1.1         Joanna Mielczarek       02/07/2019      Modified        NEXI-157 changed variables names to *assets*
    1.2         Adrian Dlugolecki       04/07/2019      Modified        NEXI-163 dynamic query
    1.3         Adrian Dlugolecki       08/07/2019      Modified        NEXI-188 add check for existing log request related to sp. Change output to wrapper
    ********************************************************************************/
    @AuraEnabled
    public static RacSiaOutputWrapper searchForRacSia( String inServicePointId )
    {
        System.debug( LoggingLevel.INFO, 'OB_LCC004_Maintenance_VarCoBa.searchForRacSia start ' + inServicePointId );
        String logRequestNameIfExist = checkForExistingLogRequest( inServicePointId );
        if ( !String.isEmpty( logRequestNameIfExist ) )
        {
            return new RacSiaOutputWrapper( logRequestNameIfExist );
        }
        Set<String> result = new Set<String>( );
        String userAbi = getAbi( );
        //enrico.purificato WN-207 START
        String assetQuery =
				'SELECT OB_RAC_SIA__c ' +
                        'FROM Asset ' +
                        'WHERE NE__Service_Point__c = \'' + String.escapeSingleQuotes( inServicePointId ) +
                        '\' AND (NE__ProdId__r.RecordType.DeveloperName   = \'' + OB_UtilityConstants.POS_RT +
						'\' OR NE__ProdId__r.RecordType.DeveloperName   = \'' + OB_UtilityConstants.PRODUCT_RECORDTYPE_MOTO +
						'\' OR NE__ProdId__r.RecordType.DeveloperName   = \'' + OB_UtilityConstants.PRODUCT_RECORDTYPE_ECOMMERCE +
						'\' OR (NE__ProdId__r.RecordType.DeveloperName   = \'' + OB_UtilityConstants.PRODUCT_RECORDTYPE_VAS +
						'\' AND NE__ProdId__r.OB_Codice_sfdc__c   = \'' + OB_EnrichOrder.ONECLICK +
						
						'\' ) OR (NE__ProdId__r.RecordType.DeveloperName   = \'' + OB_UtilityConstants.PRODUCT_RECORDTYPE_VAS +
						'\' AND NE__ProdId__r.OB_Codice_sfdc__c  = \'' + OB_EnrichOrder.RECURRING +
                        '\' )) AND NE__Status__c =\'' + ASSET_STATUS_ACTIVE + '\'';
        //enrico.purificato WN-207 END
        if ( !String.isBlank( userAbi ) )
        {
            assetQuery += ' AND OB_ABI__c =\'' + userAbi + '\'';
        }
        System.debug( LoggingLevel.INFO, 'OB_LCC004_Maintenance_VarCoBa.searchForRacSia Query ' + assetQuery );
        try
        {
            for ( Asset loopAsset : Database.query( assetQuery ) )
            {
                if ( !String.isBlank( loopAsset.OB_RAC_SIA__c ) )
                {
                    result.add( loopAsset.OB_RAC_SIA__c );
                }
            }
        } catch ( Exception ex )
        {
            String exceptionMessage = '[EXC] Exception ' + ex.getMessage( ) + ' stacktrace ' + ex.getStackTraceString( );
            System.debug( LoggingLevel.ERROR, exceptionMessage );
            return new RacSiaOutputWrapper( exceptionMessage, true );
        }
        System.debug( LoggingLevel.INFO, 'OB_LCC004_Maintenance_VarCoBa.searchForRacSia stop ' + result );
        return new RacSiaOutputWrapper( new List<String>( result ) );
    }

    /*******************************************************************************
    Purpose:  Method select order items for given Rac Sia Code
    Parameters: String inServicePointId, String inRacSiaCode
    Returns: List<NE__OrderItem__c>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       13/05/2019      Created         NEXI-33
    1.1         Joanna Mielczarek       02/07/2019      Modified        NEXI-157 changed method name to *assets*
    1.2         Adrian Dlugolecki       04/07/2019      Modified        NEXI-163 dynamic query
    ********************************************************************************/
    @AuraEnabled
    public static List<Asset> getRelatedAssetsForRacSia( String inServicePointId, String inRacSiaCode )
    {
        String userAbi = getAbi( );
        String assetQuery =
                'SELECT Id,' +
                        'NE__ProdId__r.Name,' +
                        'OB_TermId__c,' +
                        'NE__BillingProf__r.OB_IBAN__c,' +
                        'NE__BillingProf__r.OB_ABICode__c,' +
                        'NE__BillingProf__r.OB_CABCode__c,' +
                        'NE__BillingProf__r.OB_CountryCode__c,' +
                        'NE__BillingProf__r.NE__Account__c,' +
                        'NE__BillingProf__r.OB_Bank_Account_Owner__c,' +
                        'OB_DebitProfId__r.OB_IBAN__c,' +
                        'OB_DebitProfId__r.OB_ABICode__c,' +
                        'OB_DebitProfId__r.OB_CABCode__c,' +
                        'OB_DebitProfId__r.OB_CountryCode__c,' +
                        'OB_DebitProfId__r.NE__Account__c,' +
                        'OB_DebitProfId__r.OB_Bank_Account_Owner__c,' +
                        'Account.Name,' +
                        'NE__StartDate__c,' +
                        'NE__Status__c,' +
                        'NE__Service_Point__c,' +
                        'OB_RAC_SIA__c,' +
                        'NE__Order_Config__r.OB_CAB__c ' +
                        'FROM Asset ' +
                        'WHERE NE__Service_Point__c = \'' + String.escapeSingleQuotes( inServicePointId ) +
                        //NEXI-264 Grzegorz Banach <grzegorz.banach@accenture.com> 07/08/2019 START
                        '\' AND ( NE__ProdId__r.RecordType.DeveloperName   = \'' + OB_UtilityConstants.POS_RT +
                        '\' OR NE__ProdId__r.RecordType.DeveloperName =\'' + OB_UtilityConstants.PRODUCT_RECORDTYPE_ECOMMERCE  +
                        '\') AND OB_RAC_SIA__c = \'' + String.escapeSingleQuotes( inRacSiaCode ) +
                        //NEXI-264 Grzegorz Banach <grzegorz.banach@accenture.com> 07/08/2019 STOP
                        '\' AND NE__Status__c =\'' + ASSET_STATUS_ACTIVE + '\'';
        if ( !String.isBlank( userAbi ) )
        {
            assetQuery += ' AND OB_ABI__c =\'' + userAbi + '\'';
        }
        System.debug( LoggingLevel.INFO, 'OB_LCC004_Maintenance_VarCoBa.searchForRacSia Query ' + assetQuery );
        try
        {
            List<Asset> result = Database.query( assetQuery );
            OB_UtilityCallingServices.shareAsset(result);//elena.preteni WN-145 19/07/2019
            return result;
        } catch ( Exception ex )
        {
            System.debug( LoggingLevel.ERROR, '[EXC] Exception ' + ex.getMessage( ) + ' stacktrace ' + ex.getStackTraceString( ) );
            return new List<Asset>( );
        }
    }

    /*******************************************************************************
    Purpose:  Method select Abi from User
    Parameters: -
    Returns: String

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       12/06/2019      Created         NEXI-33
    ********************************************************************************/
    public static String getAbi( )
    {
        User mainUser = [ SELECT OB_ABI__c FROM User WHERE id = :UserInfo.getUserId( ) ];
        return mainUser.OB_ABI__c;
    }
}