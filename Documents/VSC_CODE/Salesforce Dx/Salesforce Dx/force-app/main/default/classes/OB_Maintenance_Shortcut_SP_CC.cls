public without sharing class OB_Maintenance_Shortcut_SP_CC
{

    /*
        *@author antonio.vatrano antonio.vatrano@accenture.com
        *@date 18/04/2019
        *@wrapper object to build FlowData for OB_Maintenance_EditServicePoint 
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
        *@method to retrieve all data of current servicePoint and current User
    */
    @AuraEnabled
    public static Map<String, String> retrieveSP( String servicePointId )
    {
        SearchResultWrapper result = new SearchResultWrapper( );
        Map<String, String> toReturn = new Map<String, String>( );
        //NEXI-356 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 04/10/2019 Start Format and add NE__Postal_Code__c,OB_Province_Code__c and OB_Street_Number__c
        String servicePointSecureId = String.isBlank( servicePointId ) ? '' : String.escapeSingleQuotes( servicePointId );
        String servicePointQuery = 'SELECT Id,' +
                'Name,' +
                'NE__City__c,' +
                'NE__Province__c,' +
                'NE__Street__c,' +
                'NE__Zip_Code__c,' +
                'OB_MCC__c,' +
                'OB_MCC_Description__c,' +
                'OB_Typology__c,' +
                'OB_CIG__c,' +
                'OB_AddressFormula__c,' +
                'NE__Postal_Code__c,' +
                'OB_Province_Code__c,' +
                'OB_Street_Number__c,' +
                '(SELECT Id,OB_MCCL2__c FROM ExternalSourceMapping__r)' +
                ' FROM NE__Service_Point__c' +
                ' WHERE  id = \'' + servicePointSecureId + '\' ';
        result.listOfServicePoint = Database.query( servicePointQuery );
        //NEXI-356 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 04/10/2019 STOP
        String returnJSON = JSON.serialize( result );
        String nameProfile = '';
        List<User> listUsers = [ SELECT Id,Profile.Name FROM User WHERE Id = :userinfo.getuserid( ) LIMIT 1 ];
        if ( !listUsers.isEmpty( ) )
        {
            User us = listUsers.get( 0 );
            nameProfile = us.Profile.Name;
        }
        toReturn.put( 'result', returnJSON );
        toReturn.put( 'profile', nameProfile );

        system.debug( logginglevel.info, 'OB_MaintenanceSearch_Controller - search- returnJSON is ' + returnJSON );
        return toReturn;

    }

}