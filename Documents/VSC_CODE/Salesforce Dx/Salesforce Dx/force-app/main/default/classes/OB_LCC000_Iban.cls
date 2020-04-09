/*******************************************************************************
Purpose:  Controller for OB_LCP000_Iban lightning component
Parameters: -
Returns: -

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         Adrian Dlugolecki       13/05/2019      Created         NEXI-33
********************************************************************************/

public with sharing class OB_LCC000_Iban
{
    private static final String POS = 'POS';
    //START - elena.preteni 21/06/2019 coba logic for Log request changed value
    private static final String VARIAZIONE_COBA = 'Cambio Coba';
    //END - elena.preteni 21/06/2019 coba logic for Log request changed value
    /*******************************************************************************
    Purpose:  Wrapper that is send to component
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       13/05/2019      Created         NEXI-33
    1.1         Joanna Mielczarek       02/07/2019      Modified        NEXI-157 changed variable name from order items to assets
    ********************************************************************************/
    public class OB_CoBaOutputWrapper
    {
        @AuraEnabled
        public Boolean result;
        @AuraEnabled
        public String errorMessage;
        @AuraEnabled
        public NE__Billing_Profile__c outputBillingProfile;
        @AuraEnabled
        public List<Asset> outputAssets;
        @AuraEnabled
        public OB_LogRequest__c redirectToObject;
    }

    /*******************************************************************************
    Purpose:  Method save new billing profile and update order items with new billing profiles.
                Also integration is executed and proper log objects are created
    Parameters: NE__Billing_Profile__c inBillingProfile, List<Asset> inAssetsToUpdate
    Returns: OB_CoBaOutputWrapper

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       13/05/2019      Created         NEXI-33
    1.1         Joanna Mielczarek       02/07/2019      Modified        NEXI-157 changed variables names from order items to assets
    ********************************************************************************/
    @AuraEnabled
    public static OB_CoBaOutputWrapper saveCoBaAndIntegrate( NE__Billing_Profile__c inBillingProfile, List<Asset> inAssetsToUpdate )
    {
        System.debug( LoggingLevel.INFO, 'OB_LCC000_Iban.saveCoBaAndIntegrate start inBillingProfile ' + inBillingProfile + ' inAssetsToUpdate ' + inAssetsToUpdate );
        OB_CoBaOutputWrapper outputWrapper = new OB_CoBaOutputWrapper( );
        Savepoint sPoint;
        if ( !Test.isRunningTest( ) )
        {
            sPoint = Database.setSavepoint( );
        }
        String salesPointId;
        String racSiaCode;
        try
        {
            Boolean areIbanDifferente = false;
            inBillingProfile.id = null;
            insert inBillingProfile;
            outputWrapper.result = true;
            outputWrapper.outputBillingProfile = inBillingProfile;
            for ( Asset loopAsset : inAssetsToUpdate )
            {
                String temporaryIban = loopAsset.NE__BillingProf__r.OB_IBAN__c != null ? loopAsset.NE__BillingProf__r.OB_IBAN__c : loopAsset.OB_DebitProfId__r.OB_IBAN__c;
                areIbanDifferente = !temporaryIban.equalsIgnoreCase( inBillingProfile.OB_IBAN__c ) || areIbanDifferente;
                racSiaCode = loopAsset.OB_RAC_SIA__c;
                loopAsset.NE__BillingProf__c = inBillingProfile.id;
                loopAsset.OB_DebitProfId__c = inBillingProfile.id;
            }
            if ( !areIbanDifferente )
            {
                if ( !Test.isRunningTest( ) )
                {
                    Database.rollback( sPoint );
                }
                outputWrapper.result = false;
                outputWrapper.errorMessage = Label.OB_SameIbans;
                return outputWrapper;
            }
            if ( !inAssetsToUpdate.isEmpty( ) )
            {
                update inAssetsToUpdate;
                salesPointId = inAssetsToUpdate[ 0 ].NE__Service_Point__c;
            }
        } catch ( Exception ex )
        {
            if ( !Test.isRunningTest( ) )
            {
                Database.rollback( sPoint );
            }
            outputWrapper.result = false;
            String errrorToDisplay = '[EXC] Exceptioion in OB_LCC000_Iban.saveCoBaAndIntegrate ' + ex.getMessage( ) + ' stacktrace ' + ex.getStackTraceString( );
            System.debug( LoggingLevel.ERROR, errrorToDisplay );
            outputWrapper.errorMessage = Label.OB_ServerLogicFailed;
            return outputWrapper;
        }
        //START---Simone Misani 11/07/2019  var-coba
        outputWrapper.redirectToObject = logIntegration( inAssetsToUpdate, inBillingProfile.OB_IBAN__c, racSiaCode );
        integrate( salesPointId, inBillingProfile, inAssetsToUpdate, outputWrapper.redirectToObject.id );
        outputWrapper.outputAssets = refreshAssets( ( new Map<Id, Asset>( inAssetsToUpdate ) ).keySet( ) );
        System.debug( LoggingLevel.INFO, 'OB_LCC000_Iban.saveCoBaAndIntegrate end ' + outputWrapper );
        //END---Simone Misani 11/07/2019  var-coba
        return outputWrapper;
    }

    /*******************************************************************************
    Purpose:  Method invoke integration. Integration is in future method so we are not waiting for answer
    Parameters: String inSalesPointId, NE__Billing_Profile__c inBillingProfile, List<Asset> inAssets
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       13/05/2019      Created         NEXI-33
    1.1         Joanna Mielczarek       02/07/2019      Modified        NEXI-157 changed variables names from order items to assets
    ********************************************************************************/
    private static void integrate( String inSalesPointId, NE__Billing_Profile__c inBillingProfile, List<Asset> inAssets, String logId )
    {
        //START---Simone Misani 11/07/2019  var-coba
        System.debug('inAssets: '+inAssets);
        String accountId = inAssets.get(0).AccountId;
        List<Account> listfiscalCode=[SELECT id, NE__Fiscal_code__c  FROM Account where id=:accountId];
        String ibanOwner = getIbanOwner( );
        
        OB_Maintenance_Serialize_Anagrafica.SerializeWrapperCoba integrationInput = new OB_Maintenance_Serialize_Anagrafica.SerializeWrapperCoba( );
        integrationInput.requestId= logId;
        //END---Simone Misani 11/07/2019  var-coba
        for ( Asset loopAsset : inAssets )
        {
            OB_Maintenance_Serialize_Anagrafica.CobaCodes cobaCode = new OB_Maintenance_Serialize_Anagrafica.CobaCodes( );
            cobaCode.source = 'MONETICA';
            cobaCode.code = loopAsset.OB_TermId__c;
            //START---Simone Misani 11/07/2019  var-coba
            String userOP = getProfileName();
            if(userOP == OB_UtilityConstants.OPERATION){
                cobaCode.proposerABI = inBillingProfile.OB_IBAN__c.substring( 5, 10 );
            }else{
            cobaCode.proposerABI = OB_LCC004_Maintenance_VarCoBa.getAbi( );
            }
            //END---Simone Misani 11/07/2019  var-coba
            integrationInput.cobaCodes.add( cobaCode );
            OB_Maintenance_Serialize_Anagrafica.BankAccountDetails bankAccountDetail = new OB_Maintenance_Serialize_Anagrafica.BankAccountDetails( );
            bankAccountDetail.accountType = POS;
            bankAccountDetail.accountHolder = null;
            //START---Simone Misani 11/07/2019  var-coba
            if(!listfiscalCode.isEmpty()){
            bankAccountDetail.fiscalCode = listfiscalCode.get(0).NE__Fiscal_code__c;
            }else{
                 bankAccountDetail.fiscalCode = null;
            }
            //END---Simone Misani 11/07/2019  var-coba
            bankAccountDetail.subscriber = ibanOwner;
            bankAccountDetail.payee = bankAccountDetail.subscriber;
            bankAccountDetail.iban = inBillingProfile.OB_IBAN__c;
            bankAccountDetail.countryCode = inBillingProfile.OB_IBAN__c.substring( 0, 2 );
            bankAccountDetail.checkNumber = inBillingProfile.OB_IBAN__c.substring( 2, 4 );
            bankAccountDetail.CIN = inBillingProfile.OB_IBAN__c.substring( 4, 5 );
            bankAccountDetail.ABI = inBillingProfile.OB_IBAN__c.substring( 5, 10 );
            bankAccountDetail.CAB = inBillingProfile.OB_IBAN__c.substring( 10, 15 );
            bankAccountDetail.bankAccountNumber = inBillingProfile.OB_IBAN__c.substring( 15 );
            integrationInput.bankAccountDetails.add( bankAccountDetail );
        }
        System.debug( LoggingLevel.INFO, 'OB_LCC000_Iban.integrate end Input ' + integrationInput );
        //START---Simone Misani 11/07/2019  var-coba
        futureIntegration( JSON.serialize( integrationInput ), accountId, inSalesPointId, inBillingProfile.Id );
        //END---Simone Misani 11/07/2019  var-coba
    }

    /*******************************************************************************
    Purpose:  Method invoke integration. Integration is in future
    Parameters: String inIntegrationInput, String bankOwner, String inSalesPointId, String inBillingProfileId
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       04/06/2019      Created         NEXI-88
    ********************************************************************************/
    //elena.preteni not needed the method callSubmit is in future
    // @future( callout=true )
    //elena.preteni not needed the method callSubmit is in future
    private static void futureIntegration( String inIntegrationInput, String bankOwner, String inSalesPointId, String inBillingProfileId )
    {
        System.debug( LoggingLevel.INFO, 'OB_LCC000_Iban.futureIntegration start inIntegrationInput ' + inIntegrationInput
                + ' bankOwner ' + bankOwner + ' inSalesPointId ' + inSalesPointId + ' inBillingProfileId ' + inBillingProfileId );
        OB_Maintenance_Serialize_Anagrafica.SerializeWrapperCoba integrationInput =
                ( OB_Maintenance_Serialize_Anagrafica.SerializeWrapperCoba )
                        JSON.deserialize( inIntegrationInput, OB_Maintenance_Serialize_Anagrafica.SerializeWrapperCoba.class );
        OB_Maintenance_Coba.callSubmit( integrationInput, bankOwner, inSalesPointId, inBillingProfileId );
    }

    /*******************************************************************************
    Purpose:  Method select name of current user ( so owner of new billing profile )
    Parameters: -
    Returns: String

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       13/05/2019      Created         NEXI-33
    ********************************************************************************/
    public static String getIbanOwner( )
    {
        List<User> users = [ SELECT Name FROM User WHERE id = :UserInfo.getUserId( ) ];
        return ( users.size( ) == 1 ) ? users.get( 0 ).Name : null;
    }

    /*******************************************************************************
    Purpose:  Object used to store date for serialization. This data will be saved in log request object
    Parameters: -
    Returns:  -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       13/05/2019      Created         NEXI-33
    ********************************************************************************/
    public class CoBaLogWrapper
    {
        String terminalId;
        String iban;
        String racSia;
    }

    /*******************************************************************************
    Purpose:  Method insert Request Log to archive information about integration
    Parameters: List<Asset> inAssets, String inNewIban, String inRacSiaCode
    Returns: OB_LogRequest__c

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       13/05/2019      Created         NEXI-33
    1.1         Joanna Mielczarek       02/07/2019      Modified        NEXI-157 changed variables names from order items to assets
    ********************************************************************************/
    private static OB_LogRequest__c logIntegration( List<Asset> inAssets, String inNewIban, String inRacSiaCode )
    {       
        OB_LogRequest__c logRequest = new OB_LogRequest__c( );
        logRequest.OB_MaintenanceType__c = VARIAZIONE_COBA;
        //START - elena.preteni 21/06/2019 coba logic for Log request changed OB_Status__c
        logRequest.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT;//Simone Misani F2WAve2-119 10/07/2019
        //END - elena.preteni 21/06/2019 coba logic for Log request changed OB_Status__c
        logRequest.OB_RequestDate__c = Date.today( );
        //START - elena.preteni 21/06/2019 coba logic for Log request added OB_ABI__c,OB_CAB__c,OB_AccountId__c,OB_ServicePointId__c
        logRequest.OB_ABI__c = OB_LCC004_Maintenance_VarCoBa.getAbi( );
        logRequest.OB_CAB__c = inAssets.get( 0 ).NE__Order_Config__r.OB_CAB__c;
        logRequest.OB_AccountId__c = inAssets.get( 0 ).AccountId;
        logRequest.OB_ServicePointId__c = inAssets.get( 0 ).NE__Service_Point__c;
       
        //END - elena.preteni 21/06/2019 coba logic for Log request added OB_ABI__c,OB_CAB__c,OB_AccountId__c,OB_ServicePointId__c
        List<CoBaLogWrapper> newCobas = new List<OB_LCC000_Iban.CoBaLogWrapper>( );
        List<CoBaLogWrapper> oldCobas = new List<OB_LCC000_Iban.CoBaLogWrapper>( );
        for ( Asset loopAsset : inAssets )
        {
            CoBaLogWrapper newLogWrapper = new CoBaLogWrapper( );
            newLogWrapper.terminalId = loopAsset.OB_TermId__c;
            newLogWrapper.iban = inNewIban;
            newLogWrapper.racSia = inRacSiaCode;
            CoBaLogWrapper oldLogWrapper = new CoBaLogWrapper( );
            oldLogWrapper.terminalId = loopAsset.OB_TermId__c;
            String temporaryIban = loopAsset.NE__BillingProf__r.OB_IBAN__c != null ? loopAsset.NE__BillingProf__r.OB_IBAN__c : loopAsset.OB_DebitProfId__r.OB_IBAN__c;
            oldLogWrapper.iban = temporaryIban;
            oldLogWrapper.racSia = inRacSiaCode;
            newCobas.add( newLogWrapper );
            oldCobas.add( oldLogWrapper );
        }
        logRequest.OB_ReducedOldData__c = JSON.serialize( oldCobas );
        logRequest.OB_ReducedNewData__c = JSON.serialize( newCobas );
        logRequest.RecordTypeId = Schema.SObjectType.OB_LogRequest__c.getRecordTypeInfosByDeveloperName( ).get( 'OB_CambioCoBa' ).getRecordTypeId( );
        // START--Simone Misani  set  required field  23/08/2019
        Boolean isPartnerCommunityLogged = OB_Utility.isPartnerCommunity( UserInfo.getUserId( ) );
        if ( isPartnerCommunityLogged )
        {
            logRequest.OB_Requestor__c = OB_UtilityConstants.Banca;
        }        // END--Simone Misani  set  required field  23/08/2019
        insert logRequest;       
        System.debug( LoggingLevel.INFO, 'OB_LCC000_Iban.logIntegration end  ' + logRequest );
        return logRequest;
    }

    /*******************************************************************************
    Purpose:  Method executed on init component. Check profile of user and enable cab editing for L2 and L3 approver
    Parameters: -
    Returns: Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       13/05/2019      Created         NEXI-33
    ********************************************************************************/
    @AuraEnabled
    public static Boolean componentInit( )
    {
        Id currentUserProfileId = UserInfo.getProfileId( );
        String currentUserProfileName = [ SELECT Name FROM Profile Where id = :UserInfo.getProfileId( ) ].get( 0 ).Name;
        return !( OB_UtilityConstants.NEXI_PARTNER_APPROVER_L2_PROFILE_NAME.equalsIgnoreCase( currentUserProfileName )
                || OB_UtilityConstants.NEXI_PARTNER_APPROVER_L3_PROFILE_NAME.equalsIgnoreCase( currentUserProfileName ) );
    }

    /*******************************************************************************
    Purpose:  Method select order items with related fields for set of order item ids
    Parameters: Set<Id> inAssetsIds
    Returns: List<Asset>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       13/05/2019      Created         NEXI-33
    1.1         Joanna Mielczarek       02/07/2019      Modified        NEXI-157 changed variables names from order items to assets, added param
    ********************************************************************************/
    @TestVisible
    private static List<Asset> refreshAssets( Set<Id> inAssetsIds )
    {
        return
        [
                //START - elena.preteni 21/06/2019 coba logic for Log request changed object
                SELECT Id,
                        NE__ProdId__r.Name,
                        OB_TermId__c,
                        NE__BillingProf__r.OB_IBAN__c,
                        NE__BillingProf__r.OB_ABICode__c,
                        NE__BillingProf__r.OB_CABCode__c,
                        NE__BillingProf__r.OB_CountryCode__c,
                        NE__BillingProf__r.NE__Account__c,
                        NE__BillingProf__r.OB_Bank_Account_Owner__c,
                        OB_DebitProfId__r.OB_IBAN__c,
                        OB_DebitProfId__r.OB_ABICode__c,
                        OB_DebitProfId__r.OB_CABCode__c,
                        OB_DebitProfId__r.OB_CountryCode__c,
                        OB_DebitProfId__r.NE__Account__c,
                        OB_DebitProfId__r.OB_Bank_Account_Owner__c,
                        Account.Name,
                        NE__StartDate__c,
                        NE__Status__c,
                        NE__Service_Point__c,
                        OB_RAC_SIA__c // NEXI-157 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 02/07/2019
                FROM Asset
                WHERE Id IN :inAssetsIds
                //END - elena.preteni 21/06/2019 coba logic for Log request changed object
        ];
    }
    //START---Simone Misani 11/07/2019  var-coba
     public static String getProfileName (){
        list<User> listUs=[SELECT id, profile.name FROM User WHERE id=:UserInfo.getUserId()];
        return listUs.get(0).profile.name;
    }
}
//END---Simone Misani 11/07/2019  var-coba