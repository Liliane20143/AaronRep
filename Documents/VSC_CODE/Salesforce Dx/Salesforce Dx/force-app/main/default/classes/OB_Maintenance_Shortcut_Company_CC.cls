public without sharing class OB_Maintenance_Shortcut_Company_CC
{
    /*
        *@author antonio.vatrano antonio.vatrano@accenture.com
        *@date 18/04/2019
        *@wrapper object to build FlowData for OB_Maintenance_EditAccount 
    */
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
        public List<NE__Lov__c> lovList { get; set; }
    }
    /*
        *@author antonio.vatrano antonio.vatrano@accenture.com
        *@date 18/04/2019
        *@wrapper object for search 
    */
    public class searchWrapper
    {
        @AuraEnabled
        public string AccountName { get; set; }
        @AuraEnabled
        public string VatNumber { get; set; }
    }

    /*
      * Author : Antonio Vatrano
      * Date : 01/04/2019
      * Description : Method that retrieve fiscalCode and VatCode from recordId(ACCOUNT)
      *   Input : accountId
      *   Output : map<string,string> {'fiscalcode' : 'XXXXXXXXXXXXXXXX', 'vatCode':'XXXXXXXXXXXXXXXXXX'}
      */
    @AuraEnabled
    public static map<String, String> retrieveInfos( String accountId )
    {
        Map<String, String> toReturn = new Map<String, String>( );
        List<Account> listAcc = [ SELECT NE__Fiscal_code__c,NE__VAT__c, recordType.developername FROM Account WHERE Id = :accountId LIMIT 1 ];
        List<User> listUser =
        [
                SELECT Id, Profile.UserLicense.Name, Profile.Name
                FROM User
                WHERE Id = :UserInfo.getUserId( )
                LIMIT 1
        ];
        if ( !listAcc.isEmpty( ) )
        {
            Account acc = listAcc.get( 0 );
            toReturn.put( 'fiscalCode', acc.NE__Fiscal_code__c );
            toReturn.put( 'VatCode', acc.NE__VAT__c );
            toReturn.put( 'Developername', acc.recordType.developername );
            toReturn.put( 'User', listUser.get( 0 ).Profile.Name );
            return toReturn;
        }
        return null;
    }
    /*
        *@author antonio.vatrano antonio.vatrano@accenture.com
        *@date 18/04/2019
        *@method for search 
    */
    @AuraEnabled
    public static String searchAcc( string jsonWrap )
    {
        System.debug( 'SEARCH METHOD' );
        system.debug( 'JSON FROM JAVASCRIPT: ' + jsonWrap );
        searchWrapper wrapper = ( searchWrapper ) JSON.deserialize( jsonWrap, searchWrapper.class );
        SearchResultWrapper result = new SearchResultWrapper( );
        system.debug( 'wrapper ' + wrapper );
        system.debug( 'result ' + result );
        if ( !String.isBlank( wrapper.AccountName ) || !String.isBlank( wrapper.VatNumber ) )
        {
            System.debug( 'WRAPPER IN SEARCH ACCOUNT: ' + wrapper );
            result = searchfromAccount ( wrapper, result );
        }
        string returnJSON = JSON.serialize( result );
        system.debug( logginglevel.info, 'OB_MaintenanceSearch_Controller - search- returnJSON is ' + returnJSON );
        return returnJSON;
    }
    /*
        *@author antonio.vatrano antonio.vatrano@accenture.com
        *@date 18/04/2019
        *@method to retrieve all data of account and put it in wrapper obj for OB_Maintenance_EditAccount
    */
    public static SearchResultWrapper searchfromAccount( searchWrapper Wrapper, SearchResultWrapper result )
    {
        System.debug( 'Wrapper' + Wrapper );
        try
        {
            System.debug( 'SEARCH FROM ACCOUNT' );
            Id rtMerchant = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.MERCHANTRT ).getRecordTypeId( );
            string soql = 'SELECT id,Name,OB_Legal_Address_Name__c , NE__Fiscal_code__c, NE__VAT__c  ,\n' +
                    'OB_Legal_Address_City__c, OB_Legal_Address_State__c,OB_Legal_Address_Street__c,OB_FATECO__c, OB_ATECO__c,\n' +
                    'OB_CCIAA__c,OB_SAE_Code__c,OB_Legal_Form__c,OB_CCIAA_Province_Code__c,OB_Legal_Address_Street_Number__c,\n' +
                    'OB_Legal_Address_ZIP__c,OB_Legal_Address_Country__c,OB_Administrative_Office_State__c,\n' +
                    'OB_Administrative_Office_Country__c,OB_Administrative_Office_ZIP__c,OB_Administrative_Office_Street_Number__c,\n' +
                    'OB_Administrative_Office_Street__c,OB_Administrative_Office_Address_Details__c,OB_Administrative_Office_City__c, \n' +
                    'OB_CCIAA_Province__c, OB_Legal_Form_Code__c, OB_Legal_Address_Country_Code__c, OB_Legal_Address_State_Code__c, \n' +
                    'OB_Administrative_Office_Country_Code__c, OB_Administrative_Office_State_Code__c, OB_BypassValidation__c, OB_SAE_Description__c, OB_ATECO_Description__c \n' +
                    'FROM Account\n ' +
                    'WHERE  '; // NEXI-144 Marta Stempien <marta.stempien@accenture.com> 02/07/2019 - Added SAE/ATECO related fields to soql
            if ( !String.isBlank( wrapper.AccountName ) )
            {
                soql += ' NE__Fiscal_code__c = \'' + wrapper.AccountName + '\'';
            }
            soql += string.isBlank( wrapper.VatNumber ) ? '' : !String.isBlank( wrapper.AccountName ) ? 'AND NE__VAT__c=\'' + wrapper.VatNumber + '\'' : ' NE__VAT__c= \'' + wrapper.VatNumber + '\'';
            system.debug ( logginglevel.info, 'OB_MaintenanceSearch_Controller - searchfromAccount -  soql ' + soql );
            list<Account> AccountToFind = Database.query( soql );
            system.debug ( logginglevel.info, 'OB_MaintenanceSearch_Controller - searchfromAccount -  AccountToFind ' + AccountToFind );
            if ( AccountToFind != null && !AccountToFind.isEmpty( ) )
            {
                result.acc = AccountToFind.get( 0 );
            }
        } catch ( Exception e )
        {
            system.debug( logginglevel.error, ' Exception in OB_MaintenanceSearch_Controller - searchfromAccount ' + e.getMessage( ) + 'at line ' + e.getLineNumber( ) );
        }
        return result;
    }
}