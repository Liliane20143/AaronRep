/*
 * Created by damian.krzyzaniak on 15.07.2019
*/
public with sharing class OB_LCC007_ModifyServicePoint
{
    public class SearchResultWrapper
    {
        @AuraEnabled
        public String outcome { get; set; }
        @AuraEnabled
        public String errorMessage { get; set; }
        @AuraEnabled
        public Account acc { get; set; }
        @AuraEnabled
        public Contact executor { get; set; }
        @AuraEnabled
        public Contact legalOffice { get; set; }
        @AuraEnabled
        public list<NE__Service_Point__c> listOfServicePoint { get; set; }
        @AuraEnabled
        public String selectedServicePoint { get; set; }
        @AuraEnabled
        public String selectedServicePointExt { get; set; }
        @AuraEnabled
        public boolean executorModifiedAllowed { get; set; }
        @AuraEnabled
        public String selectedMerchantExt { get; set; }
        @AuraEnabled
        public String selectedMerchantAsset { get; set; }
        @AuraEnabled
        public String selectedServicePointAsset { get; set; }
        @AuraEnabled
        public Asset selectedAsset { get; set; }
        @AuraEnabled
        public List<String> selectServicePointListId { get; set; }
        @AuraEnabled
        public List<NE__Lov__c> lovList { get; set; }
    }

    /*******************************************************************************
    Purpose:  Method to retrieve service point by id
    Parameters: String inServicePointId
    Returns: Map<String, String>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Damian Krzyzaniak       15/07/2019      Created         NEXI-184
    ********************************************************************************/
    @AuraEnabled
    public static Map<String, String> retrieveDataForServicePoint( String inServicePointId )
    {
        Map<String, String> toReturn = new Map<String, String> ( );
        SearchResultWrapper result = new SearchResultWrapper( );

        if ( String.isBlank( inServicePointId ) )
        {
            System.debug( LoggingLevel.ERROR, 'OB_LCC007_ModifyServicePoint.retrieveServicePoint: Empty or null inServicePointId ' );
            result.errorMessage = 'OB_LCC007_ModifyServicePoint.retrieveServicePoint: Empty or null inServicePointId' ;
            String resultJSON = JSON.serialize( result );
            toReturn.put( 'result', resultJSON );
            return toReturn;
        }


        result.listOfServicePoint =
        [
                SELECT Id,
                        Name,
                        NE__City__c,
                        NE__Province__c,
                        NE__Street__c,
                        NE__Zip_Code__c,
                        OB_MCC__c,
                        OB_MCC_Description__c,
                        OB_Typology__c,
                        OB_CIG__c,
                        OB_AddressFormula__c, ( SELECT Id, OB_MCCL2__c from ExternalSourceMapping__r )
                FROM NE__Service_Point__c
                WHERE Id = :inServicePointId
        ];
        if ( result.listOfServicePoint.isEmpty( ) )
        {
            System.debug( LoggingLevel.ERROR, 'OB_LCC007_ModifyServicePoint.retrieveServicePoint: Empty or null inServicePointId ' );
            result.errorMessage = 'OB_LCC007_ModifyServicePoint.retrieveServicePoint: Query returned nothing' ;
        }

        String resultJSON = JSON.serialize( result );
        toReturn.put( 'result', resultJSON );

        return toReturn;
    }
}