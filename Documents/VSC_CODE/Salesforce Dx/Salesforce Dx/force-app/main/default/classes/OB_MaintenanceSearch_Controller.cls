public with sharing class OB_MaintenanceSearch_Controller
{

    /*
    * Author : Claudio Quaranta
    * Date : 19/11/2018
    * Description : Method used to verify is the current user is a partner community user
    *   Input : N/A
    *   Output : Boolean : false : the user a partner community user , true : is a internal user
    *   Changelog : 28/11/2018  moved OB_Maintenance_Helper helper 
    */
    @AuraEnabled
    public static boolean isInternalUSer( )
    {
        /* boolean toReturn = false;

         string ProfileId = UserInfo.getProfileId();
         try{
         Profile  p =  [select id,UserLicense.name    from Profile where id = : ProfileId  limit 1];
         system.debug(Logginglevel.info,'isInternalUSer - profile name  retrived is ' +p.UserLicense.name ) ;
         toReturn = Label.OB_License_PartnerCommunity.equalsignorecase(p.UserLicense.name ) ? false : true ;

         }
         catch(Exception e){
             system.debug('Exception in OB_MaintenanceSearch_Controller : '+e.getmessage()+' at line : '+e.getlinenumber() );
         }
         system.debug(logginglevel.info,'OB_MaintenanceSearch_Controller - isInternalUSer toReturn is '+toReturn);*/
        return OB_Maintenance_Helper.isInternalUSer( );

    }

    public class searchWrapper
    {
        @AuraEnabled
        public string AccountName { get; set; }
        @AuraEnabled
        public string VatNumber { get; set; }
        @AuraEnabled
        public string ServicePoint { get; set; }
        @AuraEnabled
        public string SIACode { get; set; }
        @AuraEnabled
        public string SiaEstablishment { get; set; }
        @AuraEnabled
        public string TerminalId { get; set; }
        @AuraEnabled
        public string MoneticaCustomerCode { get; set; }
        @AuraEnabled
        public string MoneticaEstablishmentCode { get; set; }
        //START Andrea Saracini 18/03/2019 Card No Present: add url and app attribute
        @AuraEnabled
        public string url { get; set; }
        @AuraEnabled
        public string app { get; set; }
        //STOP Andrea Saracini 18/03/2019 Card No Present: add url and app attribute
        //START Elena Preteni 1/4/19    view custom asset
        @AuraEnabled
        public string abi { get; set; }
        //END Elena Preteni 1/4/19    view custom asset
        //START MORITTU ANDREA 26-Aug-2019 - UX.194 - Adding new searchable input
        @AuraEnabled
        public String businessAccountName {get;set;}
        public String selectedMerchantId  {get;set;}
        //END MORITTU ANDREA 26-Aug-2019 - UX.194 - Adding new searchable input
    }

    public class SearchResultWrapper
    {
        @AuraEnabled
        public string outcome { get; set; }
        @AuraEnabled
        public string errorMessage { get; set; }
        @AuraEnabled
        public Account acc { get; set; }
        @AuraEnabled
        public Contact executor { get; set; }
        @AuraEnabled
        public Contact legalOffice { get; set; }
        @AuraEnabled
        public list<NE__Service_Point__c> listOfServicePoint { get; set; }
        @AuraEnabled
        public string selectedServicePoint { get; set; }
        @AuraEnabled
        public string selectedServicePointExt { get; set; }
        @AuraEnabled
        public boolean executorModifiedAllowed { get; set; }
        @AuraEnabled
        public string selectedMerchantExt { get; set; }
        @AuraEnabled
        public string selectedMerchantAsset { get; set; }
        @AuraEnabled
        public string selectedServicePointAsset { get; set; }
        @AuraEnabled
        public Asset selectedAsset { get; set; }
        @AuraEnabled
        public List<String> selectServicePointListId { get; set; }
        @AuraEnabled
        public List<NE__Lov__c> lovList {get;set;}
        //START MORITTU ANDREA 26-Aug-2019 - UX.194 - Adding new searchable input
        @AuraEnabled
        public Set<String> accountIds {get;set;}
        //START MORITTU ANDREA 26-Aug-2019 - UX.194 - Adding new searchable input
        @AuraEnabled
        public List<Account> accountList {get;set;}
        //END MORITTU ANDREA 26-Aug-2019 - UX.194 - Adding new searchable input

        public SearchResultWrapper() {
            accountIds = new Set<String>();
            accountList = new List<Account>();
        }
        //END MORITTU ANDREA 26-Aug-2019 - UX.194 - Adding new searchable input
    }

    // DG - 28/03/2019 - MAIN_RP_019 - START
    public class UserWrapper
    {
        @AuraEnabled
        public Id Id { get; set; }
        @AuraEnabled
        public String userABI { get; set; }
        @AuraEnabled
        public String userCAB { get; set; }
        @AuraEnabled
        public String userProfile { get; set; }
        @AuraEnabled
        public String userLicense { get; set; }
    }
    // DG - 28/03/2019 - MAIN_RP_019 - END


/*
    * Author : Claudio Quaranta
    * Date : 19/11/2018
    * Description : Method used to search account and childs object, invoked by the searchcomponent
    *   Input : string jsonWrap - string in JSON format that contains the search parameters. Stringified on  searchWrapper object
    *   Output : string : A JSON that contains the response 
    */
    @AuraEnabled
    public static String search( string jsonWrap )
    {
        //START MORITTU ANDREA 26-Aug-2019 - UX.194 - Adding new searchable input
        Set<String> totalAccountsFound = new Set<String>();
        //END MORITTU ANDREA 26-Aug-2019 - UX.194 - Adding new searchable input
        System.debug( 'SEARCH METHOD' );
        system.debug( 'JSON FROM JAVASCRIPT: ' + jsonWrap );
        searchWrapper wrapper = ( searchWrapper ) JSON.deserialize( jsonWrap, searchWrapper.class );
        SearchResultWrapper result = new SearchResultWrapper( );

        system.debug( 'wrapper ' + wrapper );
        system.debug( 'result ' + result );

        //**GIOVANNI SPINELLI - 12/12/2018**//
        //IF THE VALUE OF SP CODE ISN'T BLANK-->SEARCH ON EXTERNAL SOURCE MAPPING
        if ( !string.isBlank( wrapper.ServicePoint ) )
        {
            searchOnExternalSourceMapping( wrapper, result );
        }

        System.debug( 'SIA CODE: ' + Wrapper.SIACode );
        //IF EXIST TERMINAL ID OR SIA CODE(ADD STABILIMENTO SIA) 
        //START MORITTU ANDREA 26-Aug-2019 - UX.194 - Added new input value
        if( !String.isblank(Wrapper.SIACode ) ||!String.isblank(Wrapper.SiaEstablishment )  || !String.isblank(Wrapper.TerminalId )  || !String.isblank(Wrapper.MoneticaCustomerCode )   || !String.isblank(Wrapper.MoneticaEstablishmentCode) || !String.isblank(Wrapper.url) || !String.isblank(Wrapper.app) || !String.isBlank(Wrapper.businessAccountName)){
            searchOnAsset(wrapper,result);
        } 
        //ACCOUNT QUERY(fiscal code or vat and to match accountId from asset and external)
        String merchantId=null;
        //START MORITTU ANDREA 26-Aug-2019 - UX.194 - Adding new searchable input
        System.debug('## ACCOUNT result are ' + result.accountIds);
        if(totalAccountsFound.size() > 1 && String.isBlank(wrapper.selectedMerchantId)) {
            return JSON.serialize(totalAccountsFound);
        } else if(totalAccountsFound.size() > 1 && !String.isBlank(wrapper.selectedMerchantId)) {
            //totalAccountsFound.clear();
            merchantId = wrapper.selectedMerchantId;
        }
        //END MORITTU ANDREA 26-Aug-2019 - UX.194 - Adding new searchable input

        if(string.isBlank(result.selectedMerchantExt) && !string.isBlank(result.selectedMerchantAsset)){
            merchantId = result.selectedMerchantAsset;
        }
        else if ( !string.isBlank( result.selectedMerchantExt ) && string.isBlank( result.selectedMerchantAsset ) )
        {
            merchantId = result.selectedMerchantExt;
        }
        else if ( !string.isBlank( result.selectedMerchantExt ) && !string.isBlank( result.selectedMerchantAsset ) )
        {
            if ( result.selectedMerchantExt == result.selectedMerchantAsset )
            {
                merchantId = result.selectedMerchantExt;
            }
            else
            {
                //ERROR
                result = new SearchResultWrapper ( );
                result.outcome = LAbel.OB_MAINTENANCE_ERROR;
                result.errorMessage = LAbel.OB_MAINTENANCE_NOSEARCHTERMS; //<---change in 'i dati non hanno prodotto risultati'
            }
        }
        System.debug('## result is ' + result);
        //SERVICE POINT QUERY
        String servicePointId = null;

        //CONTROL IF THE ASSET LIST CONTAINS THE SAME ID OF EXTERNAL
        System.debug( 'result.selectedServicePointExt SEARCH: ' + result.selectedServicePointExt );
        System.debug( 'result.selectServicePointListIdSEARCH: ' + result.selectServicePointListId );
        if ( result.selectServicePointListId != null && !string.isBlank( result.selectedServicePointExt ) && result.selectServicePointListId.size( ) > 0 )
        {
            if ( result.selectServicePointListId.contains( result.selectedServicePointExt ) )
            {
                servicePointId = result.selectedServicePointExt;
            }
            else
            {
                //ERROR
                result = new SearchResultWrapper ( );
                result.outcome = LAbel.OB_MAINTENANCE_ERROR;
                result.errorMessage = LAbel.OB_MAINTENANCE_NOSEARCHTERMS;
            }
        }
        else
        {
            if ( string.isBlank( result.selectedServicePointExt ) && !string.isBlank( result.selectedServicePointAsset ) )
            {
                servicePointId = result.selectedServicePointAsset;
            }
            else if ( !string.isBlank( result.selectedServicePointExt ) && string.isBlank( result.selectedServicePointAsset ) )
            {
                servicePointId = result.selectedServicePointExt;
            }
            else if ( !string.isBlank( result.selectedServicePointExt ) && !string.isBlank( result.selectedServicePointAsset ) )
            {
                if ( result.selectedServicePointExt == result.selectedServicePointAsset )
                {
                    servicePointId = result.selectedServicePointExt;
                }
                else
                {
                    //ERROR
                    result = new SearchResultWrapper ( );
                    result.outcome = LAbel.OB_MAINTENANCE_ERROR;
                    result.errorMessage = LAbel.OB_MAINTENANCE_NOSEARCHTERMS;
                }
            }
        }
        System.debug( 'servicePointId: ' + servicePointId );
        //IF THERE ISN'T ERROR--->QUERY ON ACCOUNT
        if(result.outcome      != LAbel.OB_MAINTENANCE_ERROR){
            //START MORITTU ANDREA 26-Aug-2019 - UX.194 - Adding new searchable input
            System.debug('INSIDE IF != ERROR + totalAccountsFound are: ' + totalAccountsFound);
            if(result.accountIds.size() > 1) {
                System.debug('INSIDE LIST MAJOR THAN 1');
                retrieveMultipleAccountFromSearch(wrapper , result , result.accountIds , servicePointId, wrapper.abi);
            } else {
            //END MORITTU ANDREA 26-Aug-2019 - UX.194 - Adding new searchable input
                searchfromAccount (wrapper , result , merchantId , servicePointId,wrapper.abi);
            }
        }
        //ERROR MESSAGE
        if (String.isblank(result.outcome) ){
            System.debug('INSIDE STRING IS BLANK RESULT.OUTCOME');
            result              = new SearchResultWrapper ();
            result.outcome      =  LAbel.OB_MAINTENANCE_ERROR;
            result.errorMessage = LAbel.OB_MAINTENANCE_NOSEARCHTERMS;

        }
        string returnJSON = JSON.serialize( result );
        system.debug( logginglevel.info, 'OB_MaintenanceSearch_Controller - search- returnJSON is ' + returnJSON );
        return returnJSON;
    }
/*
    * Author : Claudio Quaranta
    * Date : 19/11/2018
    * Description : Method used to search account using key not present on account himself
    *   Input : string jsonWrap - string in JSON format that contains the search parameters. Stringified on  searchWrapper object
    *   Output : string :  A JSON that contains the response
    */
    @TestVisible
    private static SearchResultWrapper searchByOtherKeys( searchWrapper Wrapper )
    {
        SearchResultWrapper result = new SearchResultWrapper( );
        //OB_ServicePointCode__c su NE__OrderItem__c
        if ( !string.isBlank( wrapper.ServicePoint ) )
        {
            searchOnExternalSourceMapping( wrapper, result );
        }
        // ASSET SEARCH  : //START Andrea Saracini 18/03/2019 Card No Present: add url and app Attributes
        if ( !String.isblank( Wrapper.SIACode ) || !String.isblank( Wrapper.SiaEstablishment ) || !String.isblank( Wrapper.TerminalId ) || !String.isblank( Wrapper.MoneticaCustomerCode ) || !String.isblank( Wrapper.MoneticaEstablishmentCode ) || !String.isblank( Wrapper.url ) || !String.isblank( Wrapper.app ) )
        {
           searchOnAsset( wrapper, result );
        }
        return result ;
    }

    /*
      * Author : Claudio Quaranta
      * Date : 21/11/2018
      * Description : Method that compose a dynamic query on asset object, based on data received in input.
      *   Input : searchWrapper Wrapper = data inserted into te UI  , used as key into te filter.
      *   Output : boid :  the number of different accountid
      */
    @TestVisible
    private static void searchOnExternalSourceMapping( searchWrapper Wrapper, SearchResultWrapper result )
    {
        try
        {
            OB_maintenance_Helper.bankOwnerWrapper bankOwner = OB_maintenance_Helper.retriveBankOwner( null );
            System.debug( 'bankOwner: ' + bankOwner );
            if ( !bankOwner.errorOccurred )
            {
                System.debug( 'wrapper.ServicePoint:' + wrapper.ServicePoint );
                System.debug( 'bankOwner.proposerABI: ' + bankOwner.proposerABI );
                //GIOVANNI SPINELLI - 11/01/2019 - CHANGE OBJECT TO QUERY: FROM EXTERNAL TO ASSET  (TO FILTER WITH CORRECT ABI)
                List<Asset> assetRelatedToExts =
                [
                        SELECT id,NE__Service_Point__c, AccountId
                        FROM asset
                        WHERE OB_ServicePointCode__c = :wrapper.ServicePoint AND OB_ProposerABI__c = :bankOwner.proposerABI
                ];
                System.debug( 'assetRelatedToExts: ' + assetRelatedToExts );
                if ( !assetRelatedToExts.isEmpty( ) )
                {
                    System.debug( 'IF LIST ASSET NOT EMPTY' );

                    if ( countAccountid( assetRelatedToExts ) > 1 )
                    {
                        System.debug( 'IF LIST ASSET > 1 ' );
                        // too manu account found, refine the query
                        result.errorMessage = LAbel.OB_MAINTENANCE_TOOMANYACCOUNTFOUND;
                        result.outcome = LAbel.OB_MAINTENANCE_ERROR;
                    }
                    //if there is only one service point
                    else
                    {
                        System.debug( 'IF LIST ASSET = 1 ' );
                        // C.Q selecting the fist record retrived
                        result.selectedServicePointExt = assetRelatedToExts.get( 0 ).NE__Service_Point__c;
                        //STORE MERCHANT ID FROM EXTERNAL
                        result.selectedMerchantExt = assetRelatedToExts.get( 0 ).AccountId;
                        //    // retrive the account information , all the account is the same
                    }
                }
                else
                {
                    // nothing found
                    result.errorMessage = LAbel.OB_MAINTENANCE_NOACCOUNTFOUND;
                    result.outcome = LAbel.OB_MAINTENANCE_ERROR;
                }
            }
            else
            {
                result.errorMessage = bankOwner.errorMessage;
                result.outcome = Label.OB_MAINTENANCE_ERROR;
            }
        } catch ( Exception e )
        {
            system.debug( logginglevel.error, ' Exception in OB_MaintenanceSearch_Controller - searchOnExternalSourceMapping ' + e.getMessage( ) + 'at line ' + e.getLineNumber( ) );
            result.errorMessage = e.getStackTraceString( );
            result.outcome = LAbel.OB_MAINTENANCE_ERROR;

        }
    }

    @TestVisible
    public static string retriveContactABI( )
    {//spinelli giovanni 17/04/2019 make this method public
        string abi;
        try
        {

            List<User> listOfUsers = [ SELECT Id, Profile.Userlicense.Name,OB_CAB__c, contact.account.OB_ABI__c FROM User WHERE Id = :userinfo.getuserid( ) LIMIT 1 ];
            abi = !listOfUsers.isEmpty( ) && listOfUsers.get( 0 ).Profile.Userlicense.Name == Label.OB_License_PartnerCommunity ? listOfUsers.get( 0 ).contact.account.OB_ABI__c : null;

        } catch ( Exception e )
        {
            system.debug( logginglevel.error, 'Exception in OB_MaintenanceSearch_Controller - retriveContactABI : ' + e.getStackTraceString( ) );
        }
        return abi;
    }

    /*
    * Author : Claudio Quaranta
    * Date : 21/11/2018
    * Description : Method that compose a dynamic query on asset object, based on data received in input.
    *   Input : searchWrapper Wrapper = data inserted into te UI  , used as key into te filter.
    *   Output : boid :  the number of different accountid
    */
    //Start antonio.vatrano rif2-103 23/05/2019
    @TestVisible
    private static void searchOnAsset( searchWrapper Wrapper, SearchResultWrapper result )
    {

        OB_Utility.searchOnAsset( Wrapper, result );//giovanni spinelli 17/04/2019 move previou method in OB_Utility class
        
        /* ANDREA MORITTU 24-Jul-19 WN-182 - REMOVED ENTIRE METHOD CODE (MERGE ERROR) */
    }
    //END antonio.vatrano rif2-103 23/05/2019
    /*------------------------------------------------------------
    Author:         Andrea Saracini
    Company:        Accenture Tecnology
    Description:    Count Configifuration for each asset 
    Inputs:
    Test Class:     
    History:
    <Date>          <Authors Name>      <Brief Description of Change>
    2019-03-20      Andrea Saracini     Creator
    ------------------------------------------------------------*/
    @TestVisible
    public static integer countBundleId( List<Asset> listOfAsset )
    { //antonio.vatrano rif2-103 21/05/2019
        Set<id> listOfBundleId = new Set<id>( );
        for ( Asset item : listOfAsset )
        {
            listOfBundleId.add( item.NE__Bundle__c );
        }
        return listOfBundleId.size( );
    }
/*
    * Author : Claudio Quaranta
    * Date : 21/11/2018
    * Description : Method that count how many account are referenced by the asset
    *   Input : list of asset to analyze
    *   Output : integer :  the number of different accountid
    */
    @TestVisible
    private static integer countAccountid( list<ExternalSourceMapping__c> listOfExternalSource )
    {
        set<id> listOfAccountid = new set<id>( );
        for ( ExternalSourceMapping__c a : listOfExternalSource )
        {
            listOfAccountid.add( a.OB_Merchant_ID__c );
        }
        return listOfAccountid.size( );
    }

/*
    * Author : Claudio Quaranta
    * Date : 20/11/2018
    * Description : Method that count how many account are referenced by the asset
    *   Input : list of asset to analyze
    *   Output : integer :  the number of different accountid
    */
    @TestVisible
    public static integer countAccountid( list<Asset> listOfAsset )
    {//giovanni spinelli 17/04/2019 make this method public
        set<id> listOfAccountid = new set<id>( );
        for ( asset a : listOfAsset )
        {
            listOfAccountid.add( a.AccountId );
        }
        return listOfAccountid.size( );
    }

/*
    * Author : Claudio Quaranta
    * Date : 20/11/2018
    * Description : Method that count how many account are referenced by the asset
    *   Input : list of asset to analyze
    *   Output : integer :  the number of different accountid
    */

    @TestVisible
    private static void retriveAccountInformation( SearchResultWrapper result, id accountid, string terminalId )
    {
        System.debug( 'RETRIEVE ACCOUNT INFORMATION' );
        Id rtMerchant = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.MERCHANTRT ).getRecordTypeId( );
        result.acc =
        [
                select id,
                        Name,
                        NE__Fiscal_code__c,
                        NE__VAT__c,
                        OB_Legal_Address_City__c,
                        OB_Legal_Address_State__c,
                        OB_Legal_Address_Street__c,
                        OB_ATECO__c,
                        OB_CCIAA__c,
                        OB_SAE_Code__c,
                        OB_Legal_Form__c,
                        OB_Legal_Form_Code__c,
                        OB_CCIAA_Province__c,
                        OB_CCIAA_Province_Code__c,
                        OB_Legal_Address_Street_Number__c,
                        OB_Legal_Address_ZIP__c,
                        OB_Legal_Address_Name__c,
                        OB_Legal_Address_Country__c,
                        OB_Legal_Address_Country_Code__c,
                        OB_Legal_Address_State_Code__c,
                        OB_Administrative_Office_State__c,
                        OB_Administrative_Office_Country__c,
                        OB_Administrative_Office_ZIP__c,
                        OB_Administrative_Office_Street_Number__c,
                        OB_Administrative_Office_Street__c,
                        OB_Administrative_Office_Address_Details__c,
                        OB_Administrative_Office_City__c,
                        OB_Administrative_Office_Country_Code__c,
                        OB_Administrative_Office_State_Code__c,
                        OB_Employees_Number__c // ANDREA MORITTU 25-Jul-2019 - field for maintannce anagrafica

                from Account
                WHERE
                id = :accountid
                and recordtypeid = :rtMerchant
        ];
        retrieveAllDataFromAccount( result, terminalId );
    }
/*
    * Author : Claudio Quaranta
    * Date : 19/11/2018
    * Description : Method search data from account 
    *   Input : list of asset to analyze
    *   Output : integer :  the number of different accountidù
    * Changelog : C.Q 26/11 added filter for Acocunt with RT merchant
    */
    @TestVisible
    private static SearchResultWrapper searchfromAccount( searchWrapper Wrapper, SearchResultWrapper result, String merchantId, String servicePointId, String abi )
    {
//SearchResultWrapper result = new SearchResultWrapper();
//elena.preteni 1/4/19
        System.debug( 'Wrapper' + Wrapper );
        System.debug( 'result' + result );
        System.debug( 'merchantId' + merchantId );
        System.debug( 'servicePointId' + servicePointId );
//elena.preteni 1/4/19
        try
        {
            System.debug( 'SEARCH FROM ACCOUNT' );
// C.q searching for account whit RT "merchant"
            result.selectedServicePoint = servicePointId;
            Id rtMerchant = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.MERCHANTRT ).getRecordTypeId( );
//elena.preteni 1/4/2019
            OB_maintenance_Helper.bankOwnerWrapper bankOwner = OB_maintenance_Helper.retriveBankOwner( abi );
//elena.preteni 1/4/2019
            System.debug( 'Bank Error: ' + bankOwner.errorOccurred );
            if ( !bankOwner.errorOccurred )
            {
                string soql = 'SELECT id,Name,OB_Legal_Address_Name__c , NE__Fiscal_code__c, NE__VAT__c  ,\n' +
                        'OB_Legal_Address_City__c, OB_Legal_Address_State__c,OB_Legal_Address_Street__c, OB_FATECO__c,OB_ATECO__c,\n' +
                        'OB_CCIAA__c,OB_SAE_Code__c,OB_Legal_Form__c,OB_CCIAA_Province_Code__c,OB_Legal_Address_Street_Number__c,\n' +
                        'OB_Legal_Address_ZIP__c,OB_Legal_Address_Country__c,OB_Administrative_Office_State__c,\n' +
                        'OB_Administrative_Office_Country__c,OB_Administrative_Office_ZIP__c,OB_Administrative_Office_Street_Number__c,\n' +
                        'OB_Administrative_Office_Street__c,OB_Administrative_Office_Address_Details__c,OB_Administrative_Office_City__c, \n' +
                        'OB_CCIAA_Province__c, OB_Legal_Form_Code__c, OB_Legal_Address_Country_Code__c, OB_Legal_Address_State_Code__c, \n' +
                        'OB_Administrative_Office_Country_Code__c, OB_Administrative_Office_State_Code__c , OB_BypassValidation__c, OB_SAE_Description__c, OB_ATECO_Description__c, OB_Employees_Number__c \n' +
                        'FROM Account\n ' +
                        'WHERE  OB_Status__c=\'' + 'Active' + '\' AND RecordTypeid = \'' + rtMerchant + '\' AND  OB_Bank_owner__c =\'' + bankOwner.bankOwnerid + '\'  ';
                // NEXI-144 Marta Stempien <marta.stempien@accenture.com> 02/07/2019 - Added SAE/ATECO related fields to soql
                if ( !String.isBlank( wrapper.AccountName ) )
                {
                    soql += ' AND NE__Fiscal_code__c = \'' + wrapper.AccountName + '\'';
                }

                soql += string.isBlank( wrapper.VatNumber ) ? '' : !String.isBlank( wrapper.AccountName ) ? 'AND NE__VAT__c=\'' + wrapper.VatNumber + '\'' : ' AND NE__VAT__c= \'' + wrapper.VatNumber + '\'';
                if ( !String.isBlank( merchantId ) )
                {
                    soql += ' AND Id = \'' + merchantId + '\'';
                }
                system.debug ( logginglevel.info, 'OB_MaintenanceSearch_Controller - searchfromAccount -  soql ' + soql );
                list<Account> AccountToFind = Database.query( soql );
                system.debug ( logginglevel.info, 'OB_MaintenanceSearch_Controller - searchfromAccount -  AccountToFind ' + AccountToFind );
                if ( AccountToFind != null && !AccountToFind.isEmpty( ) )
                {
                    result.outcome = LAbel.OB_MAINTENANCE_NOERROR;
                    result.acc = AccountToFind.get( 0 );
                    retrieveAllDataFromAccount( result, Wrapper.terminalId );
                }
                else
                {
                    result.errorMessage = LAbel.OB_MAINTENANCE_NOACCOUNTFOUND;
                    result.outcome = LAbel.OB_MAINTENANCE_ERROR;
                }
            }
            else
            {
                result.errorMessage = bankOwner.errorMessage;
                result.outcome = LAbel.OB_MAINTENANCE_ERROR;
            }

        } catch ( Exception e )
        {
            system.debug( logginglevel.error, ' Exception in OB_MaintenanceSearch_Controller - searchfromAccount ' + e.getMessage( ) + 'at line ' + e.getLineNumber( ) );
            result.errorMessage = e.getStackTraceString( );
            result.outcome = LAbel.OB_MAINTENANCE_ERROR;
        }
        return result;
    }

    @TestVisible
    private static void retrieveAllDataFromAccount( SearchResultWrapper result, string terminalId )
    {
        // manca assett attivi.
        System.debug( 'INTO RETRIEVE ALL DATA FROM ACCOUNT' );
        System.debug( 'result : ' + result.acc.id );
        Id rtLegalEntity = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.DATI_SOCIETA_LEGALE ).getRecordTypeId( );
        Id rtExecutor = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.ESECUTORE ).getRecordTypeId( );
        try
        {

            //GIOVANNI SPINELLI - 09/01/2019  -START
            OB_maintenance_Helper hlpClass = new OB_maintenance_Helper( );
            List<User> getUserList = new List<User>( );
            getUserList = hlpClass.getCurrentUser( );
            String contactQuery = null;
            contactQuery = 'select id, Phone,Email,OB_PEC__c,FirstName,LastName,OB_Company_Link_Type__c,OB_Fiscal_code__c,OB_Sex__c,OB_Country_Birth__c,OB_Country_Birth_Code__c,'
                    + 'OB_Birth_State_Code__c,OB_Birth_Date__c,OB_Birth_City__c,OB_Birth_State__c,OB_Address_Country__c,OB_Citizenship__c,mobilephone,fax,OB_Document_Release_Country__c,'
                    + 'OB_Document_Release_Country_Code__c, OB_Document_Release_State_Code__c,OB_Document_Release_State__c,OB_Document_Type__c,OB_Document_Number__c,OB_Document_Release_Authority__c,'
                    + 'OB_Document_Release_Date__c,OB_Document_Expiration_Date__c,OB_Document_Release_City__c,OB_PEP__c,OB_Address_Street__c,OB_Address_Street_Number__c,OB_Address_City__c,'
                    + 'OB_Address_State__c,OB_Address_PostalCode__c,OB_Address_Hamlet__c,OB_Address_State_Code__c,OB_Address_Country_Code__c,OB_Contact_State__c,accountid,recordtypeid'
                    + ' from contact where accountid =  \'' + result.acc.id + '\' AND (recordtypeid =  \'' + rtLegalEntity + '\' OR recordtypeid =  \'' + rtExecutor + '\' ) ';
            System.debug( 'IF CONDITION PROFILE IS TRUE? ' + getUserList.get( 0 ).Profile.UserLicense.Name.equalsIgnoreCase( 'Partner Community' ) );
            if ( getUserList.get( 0 ).Profile.UserLicense.Name.equalsIgnoreCase( 'Partner Community' ) )
            {

                contactQuery += 'AND OB_Bank__r.OB_ABI__c=\'' + getUserList.get( 0 ).OB_ABI__c + '\'';
            }
            else
            {
                //query for operation
            }
            System.debug( 'contactQuery: ' + contactQuery );
            list<Contact> listOfContact = new List<Contact>( );
            listOfContact = Database.query( contactQuery );
            System.debug( 'contactQuery: ' + JSON.serialize( contactQuery ) );
            //GIOVANNI SPINELLI - 09/01/2019  -END


            System.debug( 'LIST OF CONTACTS: ' + JSON.serialize( listOfContact ) );
            for ( contact c : listOfContact )
            {
                //giovanni spinelli - 03/01/2019 - get the only contact with status 'active'
                if ( rtExecutor == c.recordtypeid && c.OB_Contact_State__c.equalsIgnoreCase( 'active' ) )
                {
                    result.executor = c;
                    System.debug( 'EXECUTOR IN IF: ' + result.executor );
                }
                if ( rtLegalEntity == c.recordtypeid )
                    result.legalOffice = c;
            }
            result.outcome = LAbel.OB_MAINTENANCE_NOERROR;
            System.debug( 'result EXECUTOR: ' + result.executor );
            String SPquery = 'select Id,Name,NE__City__c,NE__Province__c,NE__Street__c,NE__Zip_Code__c,OB_MCC__c,OB_MCC_Description__c,OB_Typology__c,OB_CIG__c,OB_AddressFormula__c,(select Id,OB_MCCL2__c from ExternalSourceMapping__r)' +
                    ' from NE__Service_Point__c' +
                    ' where  OB_Status__c=\'' + 'Active' + '\' AND NE__Account__c = \'' + String.escapeSingleQuotes( result.acc.id ) + '\'';//Andrea Saracni Fix R1F2-21 12-04-2019
            /*Doris D ...... 22/02/2019  ................START*/
            /*FILTER SERVICE POINT  IF THERE IS A SPECIFIC ONE */
            if ( !string.isblank( result.selectedServicePoint ) )
            {
                SPquery += ' AND Id =\'' + result.selectedServicePoint + '\'';
            }
            SPquery += ' ORDER BY name asc';//Andrea Saracni Fix R1F2-21 12-04-2019
            /*Doris D ...... 22/02/2019  ................END*/

            result.listOfServicePoint = Database.query( SPquery );

            //19-12-2018 -- Salvatore P. -- GET LOVS FOR MCC L2 DESCIPTION -- START
            List<NE__Lov__c> listOfLovs = new List<NE__Lov__c>( );
            listOfLovs =
            [
                    SELECT Id,Name,NE__Active__c,NE__Lov__c,NE__Source_Lov_Id__c,
                            NE__Sub_Type__c,NE__Type__c,NE__Value1__c,NE__Value2__c,
                            NE__Value3__c,OB_Value4__c,OB_Value5__c
                    FROM NE__Lov__c
                    WHERE NE__Active__c = true
                    AND NE__Type__c = 'MCC'
                    AND NE__Value3__c = 'L2'
                    ORDER BY Name
            ];

            result.lovList = listOfLovs;

        } catch ( Exception e )
        {
            result.errorMessage = LAbel.OB_MAINTENANCE_NOCONFIGURATIONFOUND;
            result.outcome = LAbel.OB_MAINTENANCE_ERROR;
        }
    }
    // START Elena Preteni MAIN_62_R1F1
    @auraEnabled
    public static String getAbi( )
    {
        String valueAbi;
        List<User> listOfUsers = [ SELECT Id, Profile.Userlicense.Name,OB_CAB__c, contact.account.OB_ABI__c FROM User WHERE Id = :userinfo.getuserid( ) LIMIT 1 ];
        if ( !listOfUsers.isEmpty( ) )
        {
            valueAbi = listOfUsers.get( 0 ).Profile.Userlicense.Name == Label.OB_License_PartnerCommunity ? listOfUsers.get( 0 ).contact.account.OB_ABI__c : '';
        }
        return valueAbi;
    }
    // start elena.preteni 26/3/2019
    @auraEnabled
    public static List<String> getInputToShow( )
    {
        List<String> listInputToShow = null;
        List<User> users = new List<User>( );
        users = getLoggedUser( );
        system.debug( 'name' + users.get( 0 ).Profile.UserLicense.Name );
        // Boolean isRightProfile = users.get(0).Profile.UserLicense.Name.equalsIgnoreCase('Nexi Partner Approver L2');
        OB_ConfigurationInformation__mdt configurationInformation = new OB_ConfigurationInformation__mdt( );
        OB_ConfigurationInformation__mdt[] listOfConfigurationInformations =
        [
                SELECT Id,
                        MasterLabel,
                        Label,
                        QualifiedApiName,
                        OB_String_Value__c,
                        OB_String_Value_2__c
                FROM OB_ConfigurationInformation__mdt
                WHERE QualifiedApiName = 'OB_MultiCABFirstStep' OR QualifiedApiName = 'OB_multiCABbyLov'
        ];
        for ( OB_ConfigurationInformation__mdt mtd : listOfConfigurationInformations )
        {
            if ( users.get( 0 ).Profile.Name.equalsIgnoreCase( mtd.OB_String_Value__c ) )
            {

                if ( mtd.OB_String_Value_2__c.equalsIgnoreCase( 'multiCAB' ) || mtd.OB_String_Value_2__c.equalsIgnoreCase( 'LOV' ) )
                {
                    listInputToShow = new List<String>( );
                    listInputToShow.add( mtd.OB_String_Value_2__c );
                }
            }
        }

        return listInputToShow;
    }

    @auraEnabled
    public static List<String> getCabValues( )
    {
        List<String> cabList = new List<String>( );
        List<NE__Lov__c> lovList = new List<NE__Lov__c>( );
        List<User> users = new List<User>( );
        users = getLoggedUser( );
        if ( !String.isBlank( users[ 0 ].OB_CAB__c ) )
        {
            cabList = users.get( 0 ).OB_CAB__c.split( ';' );
        }
        else
        {
            lovList =
            [
                    SELECT Id,
                            Name,
                            NE__Value1__c
                    FROM NE__Lov__c
                    WHERE NE__Active__c = true AND NE__Type__c = 'CAB' AND NE__Sub_Type__c = 'Tipologiche' and NE__Value1__c = :users[ 0 ].OB_ABI__c
                    ORDER BY Name
            ];
            if ( lovList.size( ) > 0 )
            {
                for ( NE__Lov__c singleLov : lovList )
                {
                    cabList.add( singleLov.Name );
                }
            }
        }
        return cabList;
    }

    //end elena.preteni 26/3/2019

    // DG - 28/03/19 - MAIN_RP_019 - START
    @auraEnabled
    public static List<User> getLoggedUser( )
    {
        List<User> users = new List<User>( );
        try
        {
            users =
            [
                    SELECT Id,
                            Name,
                            Profile.Name,
                            Profile.Userlicense.Name,
                            OB_CAB__c,
                            OB_ABI__c
                    FROM User
                    WHERE Id = :userinfo.getuserid( )
                    LIMIT 1
            ];
            if ( !users.isEmpty( ) )
            {
                return users;
            }
            else
            {
                return null;
            }
        } catch ( Exception e )
        {
            System.debug( 'Exception type caught: ' + e.getTypeName( ) );
            System.debug( 'Message: ' + e.getMessage( ) );
            System.debug( 'Cause: ' + e.getCause( ) );
            System.debug( 'Line number: ' + e.getLineNumber( ) );
            System.debug( 'Stack trace: ' + e.getStackTraceString( ) );
            return null;
        }
    }

    @auraEnabled
    public static String getUserWrapper( )
    {
        UserWrapper user = new UserWrapper( );
        String userWrapper = '';
        List<User> users = getLoggedUser( );
        if ( !users.isEmpty( ) )
        {
            user.Id = users[ 0 ].Id;
            if ( !String.isBlank( users[ 0 ].OB_ABI__c ) )
            {
                user.userABI = users[ 0 ].OB_ABI__c;
            }
            if ( !String.isBlank( users[ 0 ].OB_CAB__c ) )
            {
                user.userCAB = users[ 0 ].OB_CAB__c;
            }
            user.userProfile = users[ 0 ].Profile.Name;
            user.userLicense = users[ 0 ].Profile.Userlicense.Name;
        }
        userWrapper = JSON.serialize( user );
        System.debug( 'UserLogged values: ' + userWrapper );
        return userWrapper;
    }

    @auraEnabled
    public static List<NE__Lov__c> getCABbyLov( )
    {
        String query;
        List<NE__Lov__c> lovByCABList = new List<NE__Lov__c>( );
        List<User> users = new List<User>( );
        String CAB = 'CAB';
        String tipologiche = 'Tipologiche';
        List<String> cabList = new List<String>( );
        users = getLoggedUser( );
        String userABI = users[ 0 ].OB_ABI__c;
        if ( !String.isBlank( users[ 0 ].OB_CAB__c ) )
        {
            if ( users.get( 0 ).OB_CAB__c.contains( ';' ) )
            {
                cabList = users[ 0 ].OB_CAB__c.split( ';' );
            }
            else
            {
                cabList.add( users[ 0 ].OB_CAB__c );
            }
        }
        query = 'SELECT  Id, Name, NE__Value1__c FROM NE__Lov__c WHERE NE__Active__c = true AND NE__Type__c = : CAB AND NE__Sub_Type__c = : tipologiche AND NE__Value1__c = : userABI';
        if ( !cabList.isEmpty( ) )
        {
            query += ' AND Name IN : cabList';
        }
        query += ' ORDER BY Name';
        lovByCABList = Database.query( query );
        System.debug( '@@@ Lov query: ' + query );
        System.debug( 'CAB' + CAB );
        System.debug( 'tipologiche' + tipologiche );
        System.debug( 'userABI' + userABI );
        System.debug( 'cabList' + cabList );
        System.debug( '@@@ Lov query result: ' + JSON.serialize( lovByCABList ) );
        if ( !lovByCABList.isEmpty( ) )
        {
            return lovByCABList;
        }
        else
        {
            return null;
        }
    }
    // DG - 28/03/19 - MAIN_RP_019 - END

    /* 
        *   Author      : Morittu Andrea
        *   Date        : 27/Aug/2019
        *   Description : Method retrieve multiple account from search() method 
    */
    @TestVisible
    private static SearchResultWrapper  retrieveMultipleAccountFromSearch(searchWrapper Wrapper  ,SearchResultWrapper result ,Set<String> accountIds , String servicePointId ,String abi){

            System.debug('Wrapper'+Wrapper);
            System.debug('result'+result);
            System.debug('accountIds : '+ accountIds);
            List<String> accountIdsList = new List<String>();
            for(String singleId : accountIds) {
                System.debug('singleId is ' + singleId);
            }

            System.debug('servicePointId'+servicePointId);
            try{
                result.selectedServicePoint = servicePointId;
                Id rtMerchant = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(OB_UtilityConstants.MERCHANTRT ).getRecordTypeId();
                OB_maintenance_Helper.bankOwnerWrapper  bankOwner = OB_maintenance_Helper.retriveBankOwner(abi);
                System.debug('Bank Error: '+bankOwner.errorOccurred);

                if(!bankOwner.errorOccurred ){
                    string soql =   'SELECT id,Name,OB_Legal_Address_Name__c , NE__Fiscal_code__c, NE__VAT__c  ,\n' +
                                    'OB_Legal_Address_City__c, OB_Legal_Address_State__c,OB_Legal_Address_Street__c,OB_ATECO__c,\n' +
                                    'OB_CCIAA__c,OB_SAE_Code__c,OB_Legal_Form__c,OB_CCIAA_Province_Code__c,OB_Legal_Address_Street_Number__c,\n' +
                                    'OB_Legal_Address_ZIP__c,OB_Legal_Address_Country__c,OB_Administrative_Office_State__c,\n' +
                                    'OB_Administrative_Office_Country__c,OB_Administrative_Office_ZIP__c,OB_Administrative_Office_Street_Number__c,\n' +
                                    'OB_Administrative_Office_Street__c,OB_Administrative_Office_Address_Details__c,OB_Administrative_Office_City__c, \n' +
                                    'OB_CCIAA_Province__c, OB_Legal_Form_Code__c, OB_Legal_Address_Country_Code__c, OB_Legal_Address_State_Code__c, \n' +
                                    'OB_Administrative_Office_Country_Code__c, OB_Administrative_Office_State_Code__c \n' +
                                    'FROM Account\n ' +
                                    'WHERE  OB_Status__c=\''+'Active' + '\' AND  OB_Bank_owner__c =\''+bankOwner.bankOwnerid +'\' AND RecordTypeid = \''+ rtMerchant +'\'';
                    // BUSINESS NAME
                    System.debug('businessAccountName is : ' +  wrapper.businessAccountName );
                    soql += ' AND Name LIKE \'%'+ wrapper.businessAccountName+'%\'';
                    // FISCAL CODE
                    soql += !String.isBlank(wrapper.AccountName) ? 'AND NE__Fiscal_Code__c = \''+ wrapper.AccountName+'\'' : '';

                    soql += string.isBlank(wrapper.VatNumber)?'' : !String.isBlank(wrapper.AccountName) ? 'AND NE__VAT__c=\''+ wrapper.VatNumber+'\'' : ' AND NE__VAT__c= \''+ wrapper.VatNumber+'\'';
                    if( accountIds.size() > 1 && String.isBlank(wrapper.selectedMerchantId)) {
                         soql += ' AND Id IN : accountIds' ;
                    } else if(accountIds.size() > 1 && !String.isBlank(wrapper.selectedMerchantId)) {
                        soql += ' AND Id = \'' + wrapper.selectedMerchantId;
                    }
                    System.debug('retrieveMultipleAccountFromSearch soql : ' + soql);
                    System.debug('wrapper.selectedMerchantId is: ' + wrapper);
                    system.debug ( logginglevel.info,'OB_MaintenanceSearch_Controller - retrieveMultipleAccountFromSearch -  soql '+soql );
                    list<Account> AccountToFind = Database.query(soql);
                    system.debug ( logginglevel.info,'OB_MaintenanceSearch_Controller - retrieveMultipleAccountFromSearch -  AccountToFind '+AccountToFind );
                     System.debug('result is : ' + result );
                    if (AccountToFind != null &&  ! AccountToFind.isEmpty()) {
                        System.debug('inside   if (AccountToFind != null &&  ! AccountToFind.isEmpty()) {');
                        switch on ( AccountToFind.size() ) {
                            when 0 {
                                System.debug('WHEN 0');
                                result.errorMessage = LAbel.OB_MAINTENANCE_NOACCOUNTFOUND;
                                result.outcome = LAbel.OB_MAINTENANCE_ERROR;
                            }
                            when 1 {
                                System.debug('WHEN 1');
                                    result.acc = AccountToFind.get(0);
                                    System.debug('result is : ' + result);
                                System.debug('result.acc.id is ' + result.acc.id);
                               // FOUND ONLY ONE ACCOUNT 
                               retrieveAllDataFromAccount(result, Wrapper.terminalId);
                            }
                            when else {
                                System.debug('WHEN ELSE');
                                result.outcome = LAbel.OB_MAINTENANCE_NOERROR;
                                result.accountList = AccountToFind;
                            }
                        }
                        
                    } 
                    else {
                            result.errorMessage = LAbel.OB_MAINTENANCE_NOACCOUNTFOUND;
                            result.outcome = LAbel.OB_MAINTENANCE_ERROR;
                    }
                }
                else{
                    result.errorMessage = bankOwner.errorMessage;
                    result.outcome = LAbel.OB_MAINTENANCE_ERROR;
                }

            }
            catch(Exception e){
                system.debug(logginglevel.error,' Exception in OB_MaintenanceSearch_Controller - searchfromAccount '+e.getMessage() +'at line '+e.getLineNumber());
                result.errorMessage = e.getStackTraceString();
                result.outcome = LAbel.OB_MAINTENANCE_ERROR;
            }
            return result;
    }
    
    /* 
        *   Author      : Morittu Andrea
        *   Date        : 27/Aug/2019
        *   Description : Wrapper Class to build dynamically the lightning data table 
    */
    public class dataTableAccountWrapper {
        @AuraEnabled
        public String label                                                                 {get;set;}
        @AuraEnabled
        public String fieldName                                                          {get;set;}
        @AuraEnabled
        public String type                                                                  {get;set;}
    }

    /* 
        *   Author      : Morittu Andrea
        *   Date        : 27/Aug/2019
        *   Description : Method to build dynamically the lightning data table 
    */
    @AuraEnabled
    public static List<dataTableAccountWrapper> retrieveObjectFieldsDetails(String objectType){

        List<dataTableAccountWrapper> dataTableScaffolding = new List<dataTableAccountWrapper>();

        try {
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType schema = schemaMap.get(objectType);
            Map<String, Schema.SObjectField> fieldMap = schema.getDescribe().fields.getMap();


                for (String fieldName: fieldMap.keySet()) {
                    if(fieldName.equalsIgnoreCase('NE__Fiscal_Code__c') || fieldName.equalsIgnoreCase('NE__VAT__c') || fieldName.equalsIgnoreCase('Name')) {
                        dataTableAccountWrapper singleWrap = new dataTableAccountWrapper();
                        singleWrap.label            = fieldMap.get(fieldName).getDescribe().getLabel();
                        singleWrap.fieldName     = fieldName;
                        singleWrap.type             = 'text';
                        //String.valueOf(fieldMap.get(fieldName).getDescribe().getType());
                        dataTableScaffolding.add(singleWrap);
                    }
                }
        } catch(Exception exc) {
            System.debug('An error has occured : ' + exc.getMessage());
        }
        return dataTableScaffolding;
    }
    /*
    * Author : Giovanni Spinelli
    * Date : 23/09/2019
    * Description : get current url
    */
    @AuraEnabled
	public static string getBaseURl(){
		String StringaUrl = OB_ContinuationController.getVFBaseURL();
		return StringaUrl;
    }
}