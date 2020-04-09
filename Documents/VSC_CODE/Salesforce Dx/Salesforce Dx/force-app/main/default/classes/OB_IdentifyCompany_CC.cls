/*****************************************************************
Name:  OB_IdentifyCompany_CC

============================================================
Purpose:      return a List of Service Points using a fiscal code,
use this List in SearcMerchantByFiscalCode component                                                                                                                 
============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                             DATE           DETAIL          Description
4.0  Giovanni Spinelli, Doris Dongmo   26/06/2018       Created          CSR: 
*****************************************************************/
public without sharing class OB_IdentifyCompany_CC
{
    static final String GT = 'MONETICA';

    public class userInfoWrapper
    {
        @AuraEnabled Boolean isOperation { get; set; }
        @AuraEnabled Boolean isPartner { get; set; }
        @AuraEnabled String CABnature { get; set; }
        @AuraEnabled Boolean hasError { get; set; }
        @AuraEnabled String ABI { get; set; }
        @AuraEnabled List<String> CAB { get; set; }
        @AuraEnabled OB_Bank_Profile__c bankProfileObject { get; set; }
        @AuraEnabled Map<String, String> bankProfile { get; set; }
        //davide.franzini - WN-120 - 29/07/2019 - START
        @AuraEnabled String bankOwner {get; set;}
        @AuraEnabled String actualBank {get; set;}
        //davide.franzini - WN-120 - 29/07/2019 - END
        userInfoWrapper( )
        {
            CAB = new List<String>( );
            bankProfileObject = new OB_Bank_Profile__c( );
            bankProfile = new Map<String, String>( );
        }
    }
    /*------------------------------------------------------------
    Author:         Andrea Saracini
    Company:        Accenture Tecnology
    Description:    Filter Service Point for Url and APP Attributes
    Inputs:         String url, String app, String merchantId, arrToFilter
    Output:         List<NE__Service_Point__c>
    Test Class:
    History:
    <Date>          <Authors Name>      <Brief Description of Change>
    2019-03-20      Andrea Saracini     Creator
    ------------------------------------------------------------*/
    @AuraEnabled
    public static List<NE__Service_Point__c> filterForUrlAndApp( String url, String app, String merchantId )
    {
        List<NE__Service_Point__c> sp = new List<NE__Service_Point__c>( );
        String query;
        List<Asset> assets = new List<Asset>( );
        if ( !String.isBlank( url ) || !String.isBlank( app ) )
        {
            query = 'SELECT Id, NE__Service_Point__c' +
                    ' FROM Asset ' +
                    ' WHERE AccountId =: merchantId AND ';
            query += String.isBlank( url ) ? '' : ' Id IN (SELECT NE__Asset__c FROM NE__AssetItemAttribute__c WHERE Name = \'URL\' AND NE__Value__c LIKE ' + '\'%' + url + '%\')  AND ';
            query += String.isBlank( app ) ? '' : ' Id IN (SELECT NE__Asset__c FROM NE__AssetItemAttribute__c WHERE Name = \'APP\' AND NE__Value__c LIKE ' + '\'%' + app + '%\')  AND ';
            query = query.removeEndIgnoreCase( 'AND ' );
            System.debug( 'ASSET QUERY: ' + query );
            assets = Database.query( query );
            Map<String, String> spIdMap = new Map<String, String>( );
            if ( !assets.isEmpty( ) )
            {
                for ( Asset item : assets )
                {
                    spIdMap.put( Item.NE__Service_Point__c, Item.NE__Service_Point__c );
                }
            }
            if ( !spIdMap.isEmpty( ) )

            {
                sp =
                [
                        SELECT id, OB_MCC__c, OB_MCC_Description__c, Name, OB_Annual_Negotiated__c, OB_Annual_revenue__c,OB_Typology__c, OB_Stato_IT_Service_Point__c,
                                NE__City__c, NE__Street__c,OB_Address_Detail__c, NE__Country__c, NE__Zip_code__c,NE__Province__c, OB_Street_Number__c,OB_District__c,
                                NE__Account__c,NE__Account__r.Name, NE__Account__r.NE__Fiscal_code__c, NE__Account__r.NE__VAT__c,OB_Opening_Time__c,OB_Ending_Time__c,OB_Break_Start_Time__c,OB_Break_End_Time__c
                        FROM NE__Service_Point__c
                        WHERE Id = :spIdMap.keySet( )
                ];
                System.debug( 'ARRAY TO FILTER: ' + sp );
            }
            if ( sp != null && sp.size( ) > 0 )
                return sp;
        }
        return sp;
    }

    /*
        @History : andrea.morittu start on 2019.05.03 - ID_Stream_6_Subentro
    */  
    @AuraEnabled
    public static List<NE__Service_Point__c> listServicePoint( String insegna, String zipCode, String city, String street, String url, String app, String merchantId, String oldWrapperInformation)
    {
        System.debug('oldWrapperInformation is : ' + oldWrapperInformation);
        MerchantFromAssetWrapper customObjectInfoWrapper = new MerchantFromAssetWrapper();
        if(oldWrapperInformation != null) { 
            customObjectInfoWrapper =(MerchantFromAssetWrapper) JSON.deserialize(oldWrapperInformation, MerchantFromAssetWrapper.class);
        }

        //GIOVANNI SPINELLI - 30/10/2018 - QUERY TO SEARCH IN SFDC BEFORE GETPV
        System.debug( 'QUERY IN SFDC SERVICE POINT' );
        System.debug( 'MERCHANT ID : ' + merchantId );
        String query;
        String sub_query;
        List<NE__Service_Point__c> serviceList = new List<NE__Service_Point__c>( );
        List<String> paramsList = new List<String> {insegna, zipCode, city, street};
        try
        {
            if ( !String.isBlank( merchantId ) )
            {
                //GIOVANNI SPINELLI 27/06/2019 ADD FIELDS IN QUERY - START
                query = 'SELECT id , OB_MCC__c , OB_MCC_Description__c, Name, OB_Annual_Negotiated__c, OB_Annual_revenue__c ,OB_Typology__c, OB_Stato_IT_Service_Point__c,  \n' +
                        ' NE__City__c , NE__Street__c ,OB_Address_Detail__c, NE__Country__c , NE__Zip_code__c ,NE__Province__c, OB_Street_Number__c,OB_District__c,\n' +
                        'NE__Account__c ,NE__Account__r.Name , NE__Account__r.NE__Fiscal_code__c , NE__Account__r.NE__VAT__c,OB_Opening_Time__c,OB_Ending_Time__c,OB_Break_Start_Time__c,OB_Break_End_Time__c, \n' +
                        ' OB_Opening_Monday_Morning__c, OB_Opening_Monday_Afternoon__c, OB_Opening_Tuesday_Morning__c, OB_Opening_Tuesday_Afternoon__c, OB_Opening_Wednesday_Morning__c,OB_Opening_Wednesday_Afternoon__c, OB_Opening_Thursday_Morning__c,OB_Opening_Thursday_Afternoon__c,OB_Opening_Friday_Morning__c,OB_Opening_Friday_Afternoon__c,	OB_Opening_Saturday_Morning__c, OB_Opening_Saturday_Afternoon__c, OB_Opening_Sunday_Morning__c, OB_Opening_Sunday_Afternoon__c,OB_End_Seasonal__c,OB_Start_Seasonal__c,\n' +
                        'RecordType.Name \n' +
                        'FROM NE__Service_Point__c \n' +
                        'WHERE NE__Account__c =: merchantId  ';
                //GIOVANNI SPINELLI 27/06/2019 ADD FIELDS IN QUERY - START
                if ( !String.isBlank( insegna ) )
                {
                    String likeInsegna = '\'%' + insegna + '%\'';
                    query += ' AND name LIKE ' + likeInsegna;
                }
                if ( !String.isBlank( zipCode ) )
                {
                    query += ' AND NE__Zip_Code__c =: zipCode';
                }
                if ( !String.isBlank( city ) )
                {
                    String likeCity = '\'%' + city + '%\'';
                    query += ' AND NE__City__c LIKE ' + likeCity;
                }
                if ( !String.isBlank( street ) )
                {
                    String likeStreet = '\'%' + street + '%\'';
                    query += ' AND NE__Street__c LIKE ' + likeStreet;
                }

                // ANDREA.MORITTU START 2019.05.03 -- ID_Stream_6_Subentro
                serviceList = Database.query( query );
                System.debug('customObjectInfoWrapper.formalCheckOnServicePointType is : ' + customObjectInfoWrapper.formalCheckOnServicePointType);
                if(!String.isEmpty(customObjectInfoWrapper.formalCheckOnServicePointType)) {
                    List<NE__Service_Point__c> updatedServicePoints = new List<NE__Service_Point__c>();
                    for(Integer i = 0; i < serviceList.size() ; i ++) {
                        if((serviceList[i].OB_Typology__c) == (customObjectInfoWrapper.formalCheckOnServicePointType)) {
                            System.debug('service List is : ' + serviceList );
                            updatedServicePoints.add(serviceList[i]);
                        }
                    }
                    serviceList.clear();
                    serviceList.addAll(updatedServicePoints);
                }
                // ANDREA.MORITTU END 2019.05.03 -- ID_Stream_6_Subentro
                System.debug( 'query service point: ' + query );
                System.debug( 'serviceList size: ' + serviceList.size( ) );
                System.debug( 'serviceList : ' + serviceList );
            }

        } catch ( Exception ecc )
        {
            System.debug( 'Generic Error: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
        }
        //serviceList=[select id , OB_MCC__c , OB_MCC_Description__c, Name, OB_Annual_Negotiated__c, OB_Annual_revenue__c ,
        //             NE__City__c , NE__Street__c , NE__Country__c , NE__Postal_Code__c ,NE__Province__c, OB_Street_Number__c,OB_District__c,
        //             NE__Account__r.Name , NE__Account__r.NE__Fiscal_code__c , NE__Account__r.NE__VAT__c
        //             from NE__Service_Point__c
        //             where NE__Account__r.NE__Fiscal_code__c=:fiscalCode  and NE__Account__c =: merchantId and NE__City__c!=''
        //             ORDER BY NE__City__c asc
        //             //limit 20
        //            ];
        //if(serviceList.isEmpty()){
        //    NE__Service_Point__c pv = new NE__Service_Point__c();
        //    serviceList.add(pv);
        //    return serviceList;
        //}else{
        //    return serviceList;
        //}
        return serviceList;


    }
    @AuraEnabled
    public static List<Account> listAcc( String fiscalCode, String vatId, String bankId )
    {
        System.debug( 'params in list acc: ' );
        //giovanni spinelli - start - 02/10/2019 further check on the non-null bankId
        if(String.isBlank( bankId )){
            List<Account> bankAccountNexiList = [ SELECT id, name FROM Account WHERE OB_ABI__c = '00000' and RecordType.DeveloperName = 'bank' LIMIT 1] ;
            if(bankAccountNexiList.size() > 0){
                Account bankAccountNexi = bankAccountNexiList.get(0);
                if ( bankAccountNexi != null ){
                    bankId = bankAccountNexi.Id;
                }
            }
            
        }
        //giovanni spinelli - end - 02/10/2019 further check on the non-null bankId
        System.debug( ' FC: ' + fiscalCode + ', VAT: ' + vatId + ', BANKID: ' + bankId );
        List<RecordType> recordList = [ Select id from RecordType where SobjectType = 'Account' and DeveloperName = 'Merchant' limit 1 ];
        List<Account> accList = New List<Account>( );
        String query ;
        query = 'SELECT id, Name , NE__Fiscal_code__c ,NE__VAT__c,RecordTypeId , OB_DescriptionVATNotPresent__c ,OB_Legal_Form__c ,\n' +
                'OB_Legal_Form_Code__c,OB_No_Profit_Recipient_Other__c,OB_No_Profit_Recipient_Class__c,OB_No_Profit_Class__c, OB_Annual_Revenue__c ,\n' +
                'Phone , NE__E_mail__c , OB_Annual_Negotiated__c,OB_VAT_Not_Present__c \n' +
                'FROM account \n' +
                'WHERE OB_Bank_owner__c =: bankId and RecordType.DeveloperName =\'Merchant\' ';


        Boolean isOnlyFC = ( !String.isEmpty( fiscalCode ) && String.isEmpty( vatId ) );
        Boolean isOnlyVAT = ( String.isEmpty( fiscalCode ) && !String.isEmpty( vatId ) );
        Boolean isboth = ( !String.isEmpty( fiscalCode ) && !String.isEmpty( vatId ) );
        System.debug( 'isOnlyFC: ' + isOnlyFC + ' isOnlyVAT: ' + isOnlyVAT + ' isboth: ' + isboth );

        if ( isOnlyFC )
        {
            query += 'AND NE__Fiscal_code__c = :fiscalCode ';
        }
        if ( isOnlyVAT )
        {
            query += 'AND NE__VAT__c=:vatId  ';
        }
        if ( isboth )
        {
            query += 'AND (NE__Fiscal_code__c = :fiscalCode OR NE__VAT__c=:vatId )';
        }
        query += ' limit 1 ';
        System.debug( 'query merchant: ' + query );
        accList = Database.query( query );
        System.debug( 'ACCOUNT LIST: ' + accList );
        //if(! String.isEmpty(fiscalCode) && ! String.isEmpty(vatId)){
        //    accList=[select id, Name , NE__Fiscal_code__c ,NE__VAT__c,RecordTypeId , OB_DescriptionVATNotPresent__c , OB_Annual_Revenue__c , Phone , NE__E_mail__c , OB_Annual_Negotiated__c,OB_VAT_Not_Present__c
        //        from account
        //        where (NE__Fiscal_code__c =: fiscalCode OR NE__VAT__c=:vatId) and OB_Bank_owner__c =: bankId and RecordType.DeveloperName = 'Merchant' limit 1];
        //}

        //else if (! String.isEmpty(fiscalCode) && String.isEmpty(vatId)){
        //    accList=[select id, Name , NE__Fiscal_code__c ,NE__VAT__c,RecordTypeId , OB_DescriptionVATNotPresent__c , OB_Annual_Revenue__c , Phone , NE__E_mail__c , OB_Annual_Negotiated__c,OB_VAT_Not_Present__c
        //        from account
        //        where NE__Fiscal_code__c =: fiscalCode and OB_Bank_owner__c =: bankId and RecordType.DeveloperName = 'Merchant' limit 1];
        //}
        //else if(! String.isEmpty(vatId) && String.isEmpty(fiscalCode)) {
        //    accList=[select id, Name , NE__Fiscal_code__c ,NE__VAT__c,RecordTypeId , OB_DescriptionVATNotPresent__c , OB_Annual_Revenue__c , Phone , NE__E_mail__c , OB_Annual_Negotiated__c,OB_VAT_Not_Present__c
        //        from account
        //        where NE__VAT__c=:vatId and OB_Bank_owner__c =: bankId and RecordType.DeveloperName = 'Merchant' limit 1];
        //}

        if ( accList.isEmpty( ) )
        {
            Account acc = new Account( );
            acc.RecordTypeId = recordList[ 0 ].Id;
            acc.OB_Bank_owner__c = bankId;
            accList.add( acc );
            return accList;

        }
        else
        {
            return accList;
        }

    }


    @AuraEnabled
    public static Map<String, String> getBankIdByUser( )
    {
        Map<String, String> bankOriginByProfile = new Map<String, String>( ); //first string is BankOwner , Second string is ActualBank

        String bankId = null;
        String userId = UserInfo.getUserId( );
        System.debug( 'userId is: ' + userId );
        //I need user Id


        User currentUser =
        [
                SELECT Id,
                        contactId,
                        contact.accountId,
                        Profile.UserLicense.Name,
                        Profile.Name,
                        OB_CAB__C,
                        OB_ABI__c
                FROM User
                WHERE Id = :userId
                LIMIT 1
        ];

        OB_Bank_Profile__c bankProfile = new OB_Bank_Profile__c( );


        // START     micol.ferrari 09/07/2018 se community :
        if ( currentUser.Profile.UserLicense.Name == System.Label.OB_License_PartnerCommunity )

        {
            /*
            *@author: Andrea Morittu <andrea.morittu@accenture.com>
            *@date: 25/03/2019
            *@description: Added logic upon result of custom metadata; if stringValue2 is multiCAB, bank must me null (It must enter in the 'else' section)
            @history (1)  --> added query + if condition
            */

            List<OB_ConfigurationInformation__mdt> listOfConfigurationInformations = new List<OB_ConfigurationInformation__mdt>( );
            listOfConfigurationInformations =
            [
                    SELECT Id,
                            MasterLabel,
                            Label,
                            QualifiedApiName,
                            OB_String_Value__c,
                            OB_String_Value_2__c
                    FROM OB_ConfigurationInformation__mdt
                    WHERE QualifiedApiName IN ('OB_MultiCABFirstStep', 'OB_multiCABbyLov', 'OB_singleCABonFirstStep')
            ];
            System.debug( 'listOfConfigurationInformations: ' + listOfConfigurationInformations );
            if ( !listOfConfigurationInformations.isEmpty( ) )
            {
                List<String> profileNameList = new List<String>( );
                for ( OB_ConfigurationInformation__mdt singleConfInfo : listOfConfigurationInformations )
                {
                    profileNameList = singleConfInfo.OB_String_Value__c.split( ';' );

                    System.debug( '### currentUser.Profile.Name ' + currentUser.Profile.Name );
                    System.debug( '### singleConfInfo.OB_String_Value_2__c : ' + singleConfInfo.OB_String_Value_2__c );
                    System.debug( '### profileNameList.contains(currentUser.Profile.Name) is: ' + profileNameList.contains( currentUser.Profile.Name ) );
                    System.debug( '### profileNameList is :' + profileNameList );
                    //IF PROFILE IS L2
                    if ( profileNameList.contains( currentUser.Profile.Name ) &&
                            singleConfInfo.OB_String_Value_2__c == 'multiCAB' )
                    {

                        System.debug( '### PROFILE IS L2' );
                        bankOriginByProfile.put( singleConfInfo.OB_String_Value_2__c, currentUser.OB_CAB__c );
                        return bankOriginByProfile;
                        //IF PROFILE IS L3
                    }
                    else if ( profileNameList.contains( currentUser.Profile.Name ) &&
                            singleConfInfo.OB_String_Value_2__c == 'LOV' )
                    {

                        System.debug( '### PROFILE IS L3' );
                        bankOriginByProfile.put( singleConfInfo.OB_String_Value_2__c, null );
                        return bankOriginByProfile;
                        //IF PROFILE IS L1
                    }
                    else if ( profileNameList.contains( currentUser.Profile.Name ) && singleConfInfo.OB_String_Value_2__c == 'singleCAB' ) //R1F2_RP_015 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 09/04/2019 change condition from || to &&
                    {

                        //FIRST I NEED TO HAVE ABI AND CAB
                        bankProfile =
                        [
                                SELECT id,
                                        OB_Business_Model_Acquiring__c,
                                        OB_Bank__c,
                                        OB_GT__c,
                                        OB_Business_Model_POS__c,
                                        OB_Circuit__c,
                                        OB_Other_Acquirer__c,
                                        OB_Service_Type__c,
                                        OB_Apm_Circuit__c,
                                        OB_Vas__c,
                                        OB_SettlementType__c,
                                        OB_AccountHolder__c,
                                        OB_Applicant_RAC_Code_SIA__c,
                                        OB_Terminal_Id_Generator__c,
                                        OB_Terminal_Id_Gateway__c,  // davide.franzini - F2WAVE2-4 - 17/07/2019
                                        OB_NeedBIO__c,
                                        OB_NDG__c,
                                        OB_Show_check_in_date__c //g.v 15/07/2019 - BACKLOG - 153
                                FROM OB_Bank_Profile__c
                                WHERE OB_Bank__c = :currentUser.contact.accountId

                                LIMIT 1
                        ];
                        System.debug( 'BANK PROFILE IS: ' + bankProfile );
                        // END     micol.ferrari 09/07/2018

                        bankOriginByProfile = getMapBankId( bankProfile );
                        bankOriginByProfile.put( 'OB_ABI__c', currentUser.OB_ABI__c );
                        bankOriginByProfile.put( 'OB_CAB__c', currentUser.OB_CAB__c );
                        bankOriginByProfile.put( 'OB_Terminal_Id_Gateway__c', bankProfile.OB_Terminal_Id_Gateway__c); // davide.franzini - F2Wave2-4 - 17/07/2019

                        System.debug( 'The map with abi is: ' + bankOriginByProfile );


                    }


                }

                /*@history (1) END*/
            }


            // else {

            // }

        }

        return bankOriginByProfile;
    }
    @AuraEnabled
    public static String getUserIdByUser( )
    {
        String bankId = null;
        String userId = UserInfo.getUserId( );
        return userId;
    }

    //RETRIEVE ANNUAL REVENUE VALUES
    /* lea.emalieu START MODIFICA 14/09/2018   */
    // The method for Picklist will return a map of String, key= API name, value=value of Picklit
    //    @AuraEnabled
    //public static Map<String,String> getAnnualRevenueValues(){
    //    Map<String,String> mapOfLovs= new Map<String,String>();
    //    List<NE__Lov__c> listOfLovs = [ SELECT  Id, Name, NE__Value1__c, NE__Value2__c
    //                                    FROM    NE__Lov__c
    //                                    WHERE   NE__Sub_Type__c = 'AnnualRevenue'
    //                                    AND     NE__Type__c = 'TIPOLOGICHE'
    //                                    AND     NE__Active__c = true ];
    //    for(NE__Lov__c currentLov : listOfLovs)
    //    {
    //        mapOfLovs.put(currentLov.NE__Value1__c,currentLov.NE__Value2__c);
    //    }
    //    return mapOfLovs;
    //}

    //@AuraEnabled
    //public static Map<String,String> getAnnualRevenueValues(){
    //    Map<String,String> pickListValuesList= new Map<String,String>();
    //    Schema.DescribeFieldResult fieldResult = Account.OB_Annual_Revenue__c.getDescribe();
    //    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    //    for( Schema.PicklistEntry pickListVal : ple){
    //        pickListValuesList.put(pickListVal.getValue(),pickListVal.getLabel());
    //        //getValue() return the API NAME
    //        //getLabel() return the value
    //    }
    //    return pickListValuesList;
    //}

    //RETRIEVE ANNUAL NEGOTIATION VALUES
    //    @AuraEnabled
    //public static Map<String,String> getAnnualNegotiationValues(){
    //    Map<String,String> mapOfLovs= new Map<String,String>();
    //    List<NE__Lov__c> listOfLovs = [ SELECT  Id, Name, NE__Value1__c, NE__Value2__c
    //                                    FROM    NE__Lov__c
    //                                    WHERE   NE__Sub_Type__c = 'AnnualNegotiated'
    //                                    AND     NE__Type__c = 'TIPOLOGICHE'
    //                                    AND     NE__Active__c = true ];
    //    for(NE__Lov__c currentLov : listOfLovs)
    //    {
    //        mapOfLovs.put(currentLov.NE__Value1__c,currentLov.NE__Value2__c);
    //    }
    //    return mapOfLovs;
    //}

    //@AuraEnabled
    //public static Map<String,String> getAnnualNegotiationValues(){
    //    Map<String,String> pickListValuesList= new Map<String,String>();
    //    Schema.DescribeFieldResult fieldResult = Account.OB_Annual_Negotiated__c.getDescribe();
    //    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    //    for( Schema.PicklistEntry pickListVal : ple){
    //        pickListValuesList.put(pickListVal.getValue(),pickListVal.getLabel());
    //        system.debug('pickListValuesList negotiation ' + pickListValuesList);
    //    }


    //    return pickListValuesList;
    //}
    //RETRIEVE EMPLOYEES NUMBER VALUES
    @AuraEnabled
    public static Map<String, String> getEmployeesNumber( )
    {
        Map<String, String> pickListValuesList = new Map<String, String>( );
        Schema.DescribeFieldResult fieldResult = Account.OB_Employees_Number__c.getDescribe( );
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues( );
        for ( Schema.PicklistEntry pickListVal : ple )
        {
            pickListValuesList.put( pickListVal.getValue( ), pickListVal.getLabel( ) );
            system.debug( 'pickListValuesList employees numbers: ' + pickListValuesList );
        }


        return pickListValuesList;
    }

    //  START   micol.ferrari 13/11/2018
    //retrieve values for service point//
    //        @AuraEnabled
    //public static Map<String,String> getAnnualRevenueValues_SP(){
    //    Map<String,String> mapOfLovs= new Map<String,String>();
    //    List<NE__Lov__c> listOfLovs = [ SELECT  Id, Name, NE__Value1__c, NE__Value2__c
    //                                    FROM    NE__Lov__c
    //                                    WHERE   NE__Sub_Type__c = 'AnnualRevenue'
    //                                    AND     NE__Type__c = 'TIPOLOGICHE'
    //                                    AND     NE__Active__c = true ];
    //    for(NE__Lov__c currentLov : listOfLovs)
    //    {
    //        mapOfLovs.put(currentLov.NE__Value1__c,currentLov.NE__Value2__c);
    //    }
    //    return mapOfLovs;
    //}
    //@AuraEnabled
    //public static Map<String,String> getAnnualRevenueValues_SP(){
    //    Map<String,String> pickListValuesList= new Map<String,String>();
    //    Schema.DescribeFieldResult fieldResult = NE__Service_Point__c.OB_Annual_Revenue__c.getDescribe();
    //    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    //    for( Schema.PicklistEntry pickListVal : ple){
    //        pickListValuesList.put(pickListVal.getValue(),pickListVal.getLabel());
    //        system.debug('pickListValuesList  sp negotiation : ' + pickListValuesList);
    //    }


    //    return pickListValuesList;
    //}
    //retrieve values for service point//
    //    @AuraEnabled
    //public static Map<String,String> getAnnualNegotiationValues_SP(){
    //    Map<String,String> mapOfLovs= new Map<String,String>();
    //    List<NE__Lov__c> listOfLovs = [ SELECT  Id, Name, NE__Value1__c, NE__Value2__c
    //                                    FROM    NE__Lov__c
    //                                    WHERE   NE__Sub_Type__c = 'AnnualNegotiated'
    //                                    AND     NE__Type__c = 'TIPOLOGICHE'
    //                                    AND     NE__Active__c = true ];
    //    for(NE__Lov__c currentLov : listOfLovs)
    //    {
    //        mapOfLovs.put(currentLov.NE__Value1__c,currentLov.NE__Value2__c);
    //    }
    //    return mapOfLovs;
    //}
    //@AuraEnabled
    //public static Map<String,String> getAnnualNegotiationValues_SP(){
    //    Map<String,String> pickListValuesList= new Map<String,String>();
    //    Schema.DescribeFieldResult fieldResult = NE__Service_Point__c.OB_Annual_Negotiated__c.getDescribe();
    //    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    //    for( Schema.PicklistEntry pickListVal : ple){
    //        pickListValuesList.put(pickListVal.getValue(),pickListVal.getLabel());
    //        system.debug('pickListValuesList negotiation ' + pickListValuesList);
    //    }


    //    return pickListValuesList;
    //}
    //  END     micol.ferrari 13/11/2018

    /*lea.emalieu END Modifica 14/09/2018*/
    /*
    * Create a new service point Record and insert
    */
    @AuraEnabled
    public static Boolean checkNewServicePoint( String objectDataMapServicePoint, List<NE__Service_Point__c> servicelist, String merchantId )
    {
        System.debug( 'sono nel checkNewServicePoint' );
        //String toreturn = '';
        Boolean checked = false;
        //NomeInsegna == nomeinsegnainserito AND Street == streetinserita AND MCC == MCCinserita
        NE__Service_Point__c pv = ( NE__Service_Point__c ) JSON.deserialize( objectDataMapServicePoint, NE__Service_Point__c.class );
        pv.Id = null;
        System.debug( 'checkNewServicePoint deserialized PV: ' + pv );
        if ( servicelist.isEmpty( ) )

        {
            try
            {
                System.debug( 'sono nel try catch del checkNewServicePoint 1' );
                pv.NE__Account__c = merchantId ;
                System.debug( 'NE__Account__c --->>> ' + pv.NE__Account__c );
                insert pv;
                //toreturn = 'Service Point created';

            } catch ( DmlException e )
            {
                e.getStackTraceString( );
                //toreturn = '1 '+e.getStackTraceString();
            }

        }
        else
        {
            for ( NE__Service_Point__c sp : servicelist )
            {
                System.debug( 'sono nel for checkNewServicePoint' );
                if ( pv.NE__Street__c == sp.NE__Street__c && pv.OB_MCC_Description__c == sp.OB_MCC_Description__c && pv.OB_Service_Point_Name__c == sp.OB_Service_Point_Name__c )
                {
                    checked = true;
                    System.debug( 'sp trovato!checkNewServicePoint ' );
                    //toreturn = 'Service Point already existing';


                }
                else
                {
                    try
                    {
                        System.debug( 'sono nel try catch del checkNewServicePoint ' );
                        pv.NE__Account__c = merchantId ;
                        insert pv;
                        //toreturn = 'Service Point created new';

                    } catch ( DmlException e )
                    {
                        e.getStackTraceString( );
                        //toreturn = '2 '+ e.getStackTraceString();
                    }
                }
            }
        }
        return checked;
        //return toreturn;
    }
    @AuraEnabled
    public static Object insertData( String step,
            Map<String, Object> data,
            String targetObjectKey,
            String method,
            List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition,
            bit2flow.DynamicWizardWrapper dynamicWizardWrapper )
    {

        OB_CustomSaveData_CC customSaveData = new OB_CustomSaveData_CC( );
        bit2flow.DynamicWizardStepWrapper DynamicWizardStepWrapper = customSaveData.executeMethod( step, data, targetObjectKey, method, stepsDefinition, dynamicWizardWrapper );
        return DynamicWizardStepWrapper.data;

    }

    /* @AuraEnabled
    public static Map<String,Object> getReturnNormalisation (String url , String field){
        Map<String,Object> mapNorma ;
        AutoCompleteComponentController autoComplete = new AutoCompleteComponentController();
        mapNorma = AutoCompleteComponentController.getNormResult(url , field);
        return mapNorma;
        }*/
    //francesca.ribezzi 23/08/2018 to delete
    /* @AuraEnabled
    public static Boolean getIsUserCommunity(){
        Boolean oppCheck = false;

        try{
            User uObj = [Select id,Profile.UserLicense.Name from User where Id=: UserInfo.getUserId()];
            System.debug('##'+uObj.Profile.UserLicense.Name);

            if(uObj.Profile.UserLicense.Name == 'Partner Community') {
                oppCheck = true;
            } else {
                oppCheck = false;
            }

        }catch(Exception e){
            throw new AuraHandledException('Error doing the query, Error: '+e.getMessage());
        }

        return oppCheck;
        }*/
    //francesca.ribezzi 23/08/2018
    @AuraEnabled
    public static String searchABIbyInputValue( String value )

    {
        try
        {
            String abi = [ SELECT Name from NE__Lov__c where Name = :value LIMIT 1 ].Name;
            System.debug( 'Value is : ' + value );
            System.debug( 'ABI RETURN is ' + abi );
            return abi;
        } catch ( Exception e )
        {
            System.debug( 'searchABIbyInputValue ERROR' + e.getLineNumber( ) + ' Message is : ' + e.getMessage( ) );
            return null;
        }

    }
    //francesca.ribezzi 23/08/2018
    //davide.franzini - 29/07/2019 - WN-212 - START
    @AuraEnabled
    public static userInfoWrapper searchCABbyInputValue( String value, String abi )
    {
        userInfoWrapper toReturn = new userInfoWrapper();
        system.debug( 'searchCABbyInputValue value: ' + value + '    abi: ' + abi );
        List<NE__Lov__c> cab = new List<NE__Lov__c>( );

        String query = 'SELECT Name,Ne__value1__c FROM NE__Lov__c WHERE NE__Active__c = true AND NE__Sub_Type__c = \'TIPOLOGICHE\' AND NE__Type__c = \'CAB\' AND Name = :value';
        if( abi != null && abi != ''){
            query += ' AND Ne__value1__c = :abi';
        }
        try
        {
            cab = Database.query(query);
            String tmpAbi = cab[0].Ne__value1__c;
            toReturn.ABI = tmpAbi;
            toReturn.CAB.add(cab[0].Name);
            Account bankAccount =
                                [
                                select id, name
                                from account
                                where OB_ABI__c = :tmpAbi and RecordType.DeveloperName = 'bank'

                                limit 1
                                ] ;

            OB_Bank_Profile__c bankProfile = new OB_Bank_Profile__c();
            bankProfile=[SELECT id ,
                                OB_Business_Model_Acquiring__c,
                                OB_Bank__c ,
                                OB_GT__c ,
                                OB_Business_Model_POS__c ,
                                OB_Circuit__c,
                                OB_Other_Acquirer__c ,
                                OB_Service_Type__c,
                                OB_Apm_Circuit__c,
                                OB_Vas__c,
                                OB_SettlementType__c,
                                OB_AccountHolder__c,
                                OB_Applicant_RAC_Code_SIA__c,
                                OB_Terminal_Id_Generator__c,
                                OB_Terminal_Id_Gateway__c, //davide.franzini - F2WAVE2-4 - 17/07/2019
                                OB_NeedBIO__c ,
                                OB_NDG__c,
                                OB_Show_check_in_date__c // antonio.vatrano add field to query for exception
                        FROM OB_Bank_Profile__c
                        WHERE OB_Bank__c=: bankAccount.Id
                        LIMIT 1];
                /* ANDREA MORITTU END 01-Jul-19 - DECOMMENT Bank Profile area (hotFix)*/

                if ( bankProfile == null || bankProfile.OB_Business_Model_Acquiring__c == null )
                {
                    throw new OB_IdentifyCompany_Exception('OB_IdentifyCompany_CC Exception: Bank Profile is not valid');
                }
                
                toReturn.bankProfileObject = bankProfile;
                toReturn.bankProfile = OB_IdentifyCompany_CC.getMapBankId( toReturn.bankProfileObject );

        } catch ( Exception e )
        {
            System.debug( 'searchCABbyInputValue ERROR:' + e.getLineNumber( ) );
        }
        return toReturn;
    }
    //davide.franzini - 29/07/2019 - WN-212 - END

    //francesca.ribezzi 24/07/2018
    @AuraEnabled
    public static Map<String, String> getBankProfileByABI( String abi )//, String cab)
    {
        //giovanni spinelli - start - 28/10/2019 - check blank abi
        if(String.isBlank( abi )){
            String userId = UserInfo.getUserId( );
            System.debug( 'userId is: ' + userId );
            User currentUser =[ SELECT  Id,OB_ABI__c FROM User WHERE Id = :userId LIMIT 1 ];
            abi = currentUser.OB_ABI__c;
        }
        System.debug('ABI: ' + abi);
        //giovanni spinelli - end - 28/10/2019 - check blank abi
        Map<String, String> bankIdMap = new Map<String, String>( );
        List<OB_Bank_Profile__c> listOfBankProfile = new List<OB_Bank_Profile__c>( );
        OB_Bank_Profile__c bankProfile = new OB_Bank_Profile__c( );


        try
        {
            listOfBankProfile =
            [
                    select id,
                            OB_Business_Model_Acquiring__c,
                            OB_Bank__c,
                            OB_GT__c,
                            OB_Business_Model_POS__c,
                            OB_Circuit__c,
                            OB_Other_Acquirer__c,
                            OB_Service_Type__c,
                            OB_Apm_Circuit__c,
                            OB_Vas__c,
                            OB_SettlementType__c,
                            OB_AccountHolder__c,
                            OB_Applicant_RAC_Code_SIA__c,
                            OB_Terminal_Id_Generator__c,
                            OB_Terminal_Id_Gateway__c,  // davide.franzini - F2WAVE2-4 - 17/07/2019
                            OB_NeedBIO__c,
                            OB_NDG__c,
                            OB_Show_check_in_date__c //g.v. 15/07/2019
                    from OB_Bank_Profile__c
                    where OB_Bank__r.OB_ABI__c = :abi

                    limit 1
            ];
            System.debug( 'BANK PROFILE IS: ' + listOfBankProfile );
            if ( !listOfBankProfile.isEmpty( ) )
            {
                bankProfile = listOfBankProfile.get( 0 );
            }
            else
            {
                bankProfile = null;
            }

        } catch ( exception e )
        {
            System.debug( 'The following exception has occurred: ' + e.getMessage( ) );
        }


        bankIdMap = getMapBankId( bankProfile );
        System.debug( 'THE MAP FROM SELECTED ABI AND CAB: ' + bankIdMap );

        /*if(!bankProfileList.isEmpty()){
            OB_Bank_Profile__c bankProfile = bankProfileList[0];
            if(bankProfile.OB_Business_Model_Acquiring__c == 'Servicing' ||
                bankProfile.OB_Business_Model_Acquiring__c == 'Associate' ||
                bankProfile.OB_Business_Model_Acquiring__c == null)
            {
                bankId=bankProfile.OB_Bank__c;
            }
            else
            {
                list <Account> currentAccList = [select id , name
                                                 from account
                                                 where OB_ABI__c= '00000']  ;
                if (!currentAccList.isEmpty()){
                    Account currentAcc = currentAccList[0];
                    bankId= currentAcc.id;
                }
               // bankId = bankProfileList.get(0).OB_Bank__c;
            }

            }*/
        return bankIdMap;
    }

    @AuraEnabled
    public static Account getAccountById( String idAcc )

    {
        return
        [
                select id, Name, NE__Fiscal_code__c, NE__VAT__c
                from account
                where Id = :idAcc

                limit 1
        ];
    }

    private static Map<String, String> getMapBankId( OB_Bank_Profile__c bankProfile )
    {
        String bankId = '' ;
        Map<String, String> bankIdMap = new Map<String, String>( );
        
        //davide.franzini - 29/07/2019 - WN-212 - START
        Account currentAcc =
        [
        select id, name
        from account
        where OB_ABI__c = '00000' and RecordType.DeveloperName = 'bank'

        limit 1
        ] ;

        if(currentAcc == null){
            throw new OB_IdentifyCompany_Exception('OB_IdentifyCompany_CC Exception: Account Nexi is not defined');
        }
        if ( bankProfile != null )
        {

            if ( bankProfile.OB_Business_Model_Acquiring__c == 'Servicing' ||
                    bankProfile.OB_Business_Model_Acquiring__c == 'Associate' )
            {
                bankId = bankProfile.OB_Bank__c;
                bankIdMap.put( 'bankOwner', bankProfile.OB_Bank__c );
                bankIdMap.put( 'actualBank', bankProfile.OB_Bank__c );

            }
            else
            {
                bankId = currentAcc.id;
                bankIdMap.put( 'bankOwner', bankId );
                bankIdMap.put( 'actualBank', bankProfile.OB_Bank__c );
                // bankId = bankProfileList.get(0).OB_Bank__c;
            }
            //davide.franzini - 29/07/2019 - WN-212 - END
            bankIdMap.put( 'GT', bankProfile.OB_GT__c );
            //GIOVANNI SPINELLI 26/09/2018
            bankIdMap.put( 'OB_Business_Model_POS__c', bankProfile.OB_Business_Model_POS__c );
            bankIdMap.put( 'OB_Business_Model_Acquiring__c', bankProfile.OB_Business_Model_Acquiring__c );
            //GIOVANNI SPINELLI 15/10/2018
            bankIdMap.put( 'OB_Circuit__c', bankProfile.OB_Circuit__c );
            bankIdMap.put( 'OB_Other_Acquirer__c', bankProfile.OB_Other_Acquirer__c );
            //GIOVANNI SPINELLI 26/10/2018
            bankIdMap.put( 'OB_Service_Type__c', bankProfile.OB_Service_Type__c );
            bankIdMap.put( 'OB_Apm_Circuit__c', bankProfile.OB_Apm_Circuit__c );
            bankIdMap.put( 'OB_Vas__c', bankProfile.OB_Vas__c );
            //GIOVANNI SPINELLI 06/11/2018
            bankIdMap.put( 'OB_SettlementType__c', bankProfile.OB_SettlementType__c );
            //GIOVANNI SPINELLI 09/11/2018
            bankIdMap.put( 'OB_AccountHolder__c', String.valueOf( bankProfile.OB_AccountHolder__c ) );
            bankIdMap.put( 'OB_Applicant_RAC_Code_SIA__c', bankProfile.OB_Applicant_RAC_Code_SIA__c );
            //GIOVANNI SPINELLI 12/11/2018
            bankIdMap.put( 'OB_Terminal_Id_Generator__c', bankProfile.OB_Terminal_Id_Generator__c );
            //davide.franzini - F2WAVE2-4 - 17/07/2019
            bankIdMap.put( 'OB_Terminal_Id_Gateway__c', bankProfile.OB_Terminal_Id_Gateway__c );
            //GIOVANNI SPINELLI 07/01/2019
            bankIdMap.put( 'OB_NeedBIO__c', String.valueOf( bankProfile.OB_NeedBIO__c ) );
            //ANDREA MORITTU 11/02/2019
            bankIdMap.put( 'OB_NDG__c', String.valueOf( bankProfile.OB_NDG__c ) );
            //START gianluigi.virga 15/07/2019 - BACKLOG-153
            bankIdMap.put('OB_Show_check_in_date__c', String.valueOf(bankProfile.OB_Show_check_in_date__c));
            //END gianluigi.virga 15/07/2019 - BACKLOG-153
            
        }
        //	micol.ferrari 26/10/2019 - PostProd - START
       	 system.debug('bid '+bankIdMap);
         //	micol.ferrari 26/10/2019 - PostProd - STOP
        return bankIdMap;
    }

    /*lea.emalieu 20/09/2018 START *******************************************/
    //Method to take the description of mcc code
    @AuraEnabled
    public static String getMccDescription( String mccCode )
    {
        String mccDescription;
        System.debug( 'mccCode: ' + mccCode );


        try
        {
            mccDescription = [
                    select Name
                    from NE__Lov__c
                    where NE__Type__c = 'MCC' and NE__Active__c = true and ne__value2__c = :mccCode

                    limit 1
            ].Name;
            System.debug( 'NAME MCC: ' + mccDescription );
        } catch ( exception e )
        {
            System.debug( 'The following exception has occurred: ' + e.getMessage( ) );
        }

        return mccDescription;
    }

    /*lea.emalieu 20/09/2018 END *******************************************/
    /*ANDREA MORITTU: Grabbing picklist Values*/
    //retrieve values for service point//
    @AuraEnabled
    public static Map<String, String> getServicePointTypologyValues_SP( )
    {
        Map<String, String> pickListValuesList = new Map<String, String>( );
        Schema.DescribeFieldResult fieldResult = NE__Service_Point__c.OB_Typology__c.getDescribe( );
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues( );
        for ( Schema.PicklistEntry pickListVal : ple )
        {
            pickListValuesList.put( pickListVal.getValue( ), pickListVal.getLabel( ) );
            system.debug( 'pickListValuesList  sp negotiation : ' + pickListValuesList );
        }


        return pickListValuesList;
    }
    //***GIOVANNI SPINELLI - 10/09/2018 - GET AN ORDER HEADER OF A SPECIFIC MERCHANT
    @AuraEnabled
    public static Boolean getOrderHeaderByAccountId( String merchantId )
    {
        System.debug( 'merchantId: ' + merchantId );
        Boolean hasOrder = false;
        List<NE__Order_Header__c> orderHeaderList = new List<NE__Order_Header__c>( );

        if ( merchantId != '' || merchantId != null )
        {
            try
            {
                orderHeaderList =
                [
                        SELECT id, name, NE__OrderStatus__c, OB_NDG__c
                        FROM NE__Order_Header__c
                        WHERE NE__AccountId__c = :merchantId AND NE__OrderStatus__c = 'Pending'


                        limit 1
                ];
            } catch ( DmlException e )
            {
                System.debug( 'exception from retrieve order HEADER: ' + e.getStackTraceString( ) );
            }
        }

        System.debug( 'ORDER HEADER LIST: ' + orderHeaderList );
        if ( !orderHeaderList.isEmpty( ) )
        {
            hasOrder = true;
            return hasOrder;

        }
        else
        {
            return hasOrder;
        }
    }
    //***GIOVANNI SPINELLI - 10/09/2018 - GET AN ORDER HEADER OF A SPECIFIC MERCHANT
    @AuraEnabled
    public static List<ExternalSourceMapping__c> getSourceSystem( String merchantId )
    {
        System.debug( 'GETSOURCESYSTEM' );
        List<ExternalSourceMapping__c> exSourceList = new List<ExternalSourceMapping__c>( );
        if ( String.isEmpty( merchantId ) )
        {
            return exSourceList;
        }
        try
        {
            exSourceList =
            [
                    SELECT Id,Name,OB_Merchant_ID__c,OB_Service_Point_ID__c, OB_CustomerCodeClientCode__c,OB_Source__c,OB_ReportType__c
                    FROM ExternalSourceMapping__c
                    WHERE OB_Source__c != '' AND OB_Service_Point_ID__c = '' AND OB_Merchant_ID__c = :merchantId AND OB_ToBeChecked__c = false
            ];
            System.debug( 'exSourceList: ' + exSourceList );


        } catch ( DmlException e )
        {
            System.debug( 'exception from retrieve external source mapping ' + e.getStackTraceString( ) );
        }
        return exSourceList;

    }

    @AuraEnabled
    public static String getExternalCode( String merchantId, List<ExternalSourceMapping__c> otherCodes, String merchantCategoryCode, String postalCode, Boolean isEcommerce )
    {

        List<ExternalSourceMapping__c> exSourceList = new List<ExternalSourceMapping__c>( );
        PvReq tmpReq = new PvReq( );
        if ( String.isEmpty( merchantId ) && ( otherCodes != null && otherCodes.size( ) < 1 ) )
        {
            return '{}';
        }
        try
        {
            tmpReq.merchantCategoryCode = merchantCategoryCode;
            tmpReq.postalCode = postalCode;
            tmpReq.isEcommerce = isEcommerce;
            if ( !String.isEmpty( merchantId ) )
            {
                exSourceList =
                [
                        SELECT Id,Name,OB_Merchant_ID__c,OB_Service_Point_ID__c, OB_CustomerCodeClientCode__c,OB_Source__c, OB_ToBeChecked__c
                        FROM ExternalSourceMapping__c
                        WHERE OB_Source__c != '' AND OB_Service_Point_ID__c = '' AND OB_Merchant_ID__c = :merchantId AND OB_ToBeChecked__c != true
                ];
            }

            for ( ExternalSourceMapping__c newCodes : exSourceList )
            {
                if ( newCodes.OB_Source__c == OB_IdentifyCompany_CC.GT )
                {
                    Pos tmpPos = new Pos( );
                    tmpPos.gtCompanyCode = newCodes.OB_CustomerCodeClientCode__c;
                    tmpPos.gtCode = 'NEXI';
                    tmpReq.POSCompanies.add( tmpPos );
                }
                if ( newCodes.OB_Source__c != OB_IdentifyCompany_CC.GT )
                {
                    Acquiring tmpAcquiring = new Acquiring( );
                    tmpAcquiring.companyCode = newCodes.OB_CustomerCodeClientCode__c;
                    tmpAcquiring.processor = newCodes.OB_Source__c;
                    tmpReq.AcquiringCompanies.add( tmpAcquiring );
                }

                //exSourceList.add(newCodes);
            }

            for ( ExternalSourceMapping__c newCodes : otherCodes )
            {
                if ( newCodes.OB_Source__c == OB_IdentifyCompany_CC.GT )
                {
                    Pos tmpPos = new Pos( );
                    tmpPos.gtCompanyCode = newCodes.OB_CustomerCodeClientCode__c;
                    tmpPos.gtCode = 'NEXI';
                    tmpReq.POSCompanies.add( tmpPos );
                }
                if ( newCodes.OB_Source__c != OB_IdentifyCompany_CC.GT )
                {
                    Acquiring tmpAcquiring = new Acquiring( );
                    tmpAcquiring.companyCode = newCodes.OB_CustomerCodeClientCode__c;
                    tmpAcquiring.processor = newCodes.OB_Source__c;
                    tmpReq.AcquiringCompanies.add( tmpAcquiring );
                }

                //exSourceList.add(newCodes);
            }


        } catch ( DmlException e )
        {
            System.debug( 'exception from retrieve external source mapping ' + e.getStackTraceString( ) );
        }

        return JSON.serialize( tmpReq );

    }

    public class Acquiring
    {
        String companyCode;
        String processor;
    }

    public class Pos
    {
        String gtCompanyCode;
        String gtCode;
    }

    public class PvReq
    {
        List<Acquiring> AcquiringCompanies = new List<Acquiring>( );
        List<Pos> POSCompanies = new List<Pos>( );
        String merchantCategoryCode ;
        String postalCode ;
        Boolean isEcommerce ;
    }
    //***GIOVANNI SPINELLI - 13/09/2018 - GET AN ORDER HEADER OF A SPECIFIC SOURCE SYSTEM
    @AuraEnabled
    public static boolean getOrderHeaderFromCod( String merchantId, List<String> code )
    {
        Boolean hasOrder = false;
        System.debug( 'list of code : ' + code );
        List<NE__OrderItem__c> orderHeaderListCod = new List<NE__OrderItem__c>( );
        List<NE__OrderItem__c> processorList = new List<NE__OrderItem__c>( );
        String equens = 'EQUENS';
        String sia = 'SIA';
        String monetica = 'MONETICA';
        try
        {
            processorList =
            [
                    SELECT OB_Processor__c,id, NE__Status__c,OB_CompanyCode__c, OB_CustomerCode__c
                    FROM NE__OrderItem__c
                    WHERE NE__Account__c = :merchantId AND OB_Processor__c != '' AND ( NE__Status__c = 'Pending' or NE__Status__c = 'Waiting for approval')
            ];
            System.debug( 'processorList in getOrderHeaderFromCod: ' + processorList );
            for ( NE__OrderItem__c orderItem : processorList )
            {
                if ( orderItem.OB_Processor__c == equens || orderItem.OB_Processor__c == sia )
                {
                    System.debug( 'if equens or sia' );
                    if ( code.contains( orderItem.OB_CompanyCode__c ) )
                    {
                        hasOrder = true;
                    }

                }
                else if ( orderItem.OB_Processor__c == monetica )
                {
                    System.debug( 'if monetica' );
                    if ( code.contains( orderItem.OB_CustomerCode__c ) )
                    {
                        hasOrder = true;
                    }

                }
            }

            //if(processorList.OB_Processor__c ==  equens )
            //{
            //   orderHeaderListCod=[ SELECT
            //                     FROM NE__OrderItem__c
            //                     WHERE  AND OB_CompanyCode__c in:code )
            //                    ];
            //}
            //else if(processorList.OB_Processor__c== monetica)
            //{
            // orderHeaderListCod=[ SELECT id , NE__Status__c
            //                     FROM NE__OrderItem__c
            //                     WHERE NE__Account__c =: merchantId AND OB_CustomerCode__c  in:code AND(NE__Status__c='Pending' or NE__Status__c='Waiting for approval')
            //                    ];
            //}


        } catch ( DmlException e )
        {
            System.debug( 'exception from retrieve order from system source ' + e.getStackTraceString( ) );
        }
        System.debug( 'ORDER HEADER LIST: ' + orderHeaderListCod );
        //if(!orderHeaderListCod.isEmpty()){
        //    hasOrder = true;
        //    return hasOrder;
        //}else{
        //    return hasOrder;
        //}
        System.debug( 'hasOrder before return: ' + hasOrder );
        return hasOrder;

    }
    @AuraEnabled
    public static Map<String, Map<String, NE__OrderItem__c>> getPendingOrderFromCode( String merchantId, String operator, Map<String, Object> codeObject )
    {
        System.debug( 'into getPendingOrderFromCode:' );
        System.debug( 'merchantId getPendingOrderFromCode:' + merchantId );
        System.debug( 'operator getPendingOrderFromCode:' + operator );
        System.debug( 'codeObject getPendingOrderFromCode:' + codeObject );

        List<NE__OrderItem__c> orderItemList = new List<NE__OrderItem__c>( );
        List<Asset> assetList = new List<Asset>( );
        List<String> codeList = new List<String>( );
        List<String> nexiSystemList = new List<String>( );
        Map<String, Map<String, NE__OrderItem__c>> mapOrderItem = new Map<String, Map<String, NE__OrderItem__c>>( );
        Map<String, NE__OrderItem__c> mapOrderItemTmp = new Map<String, NE__OrderItem__c>( );
        if ( codeObject.size( ) < 1 || String.isEmpty( merchantId ) )
        {
            return mapOrderItem;
        }
        try
        {   //TO DO CONTROLLO ASSET.....
            String query = 'SELECT OB_Processor__c ,id , NE__Status__c,OB_CompanyCode__c, OB_CustomerCode__c, NE__Account__c ,OB_GT__c, NE__Account__r.NE__Fiscal_code__c,NE__Account__r.name FROM NE__OrderItem__c WHERE ';
            if ( operator == 'equal' )
            {
                query += 'NE__Account__c =: merchantId ';

            }
            else
            {
                query += 'NE__Account__c !=: merchantId ';
            }
            query += 'AND ';
            Integer systemCounter = 1;
            query += '(';
            for ( String nexiSystem : codeObject.keyset( ) )
            {
                nexiSystemList.add( nexiSystem );
                Map<String, Object> missingCodes = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( codeObject.get( nexiSystem ) ) ) ;
                Integer codeCounter = 1;
                query += '(';
                for ( String code : missingCodes.keyset( ) )
                {
                    codeList.add( code );
                    System.debug( 'nexiSystem : ' + nexiSystem );
                    //IF NEXI SYSTEM IS MONETICA USE THE GT AND THE CUSTOMER CODE
                    if ( nexiSystem == OB_IdentifyCompany_CC.GT )
                    {
                        //to do
                        query += '(OB_GT__c = \'' + OB_IdentifyCompany_CC.GT + '\' AND OB_CustomerCode__c = \'' + code + '\')';
                    }
                    //IF NEXI SYSTEM ISN'T MONETICA USE THE PROCESSOR AND THE COMPANY CODE
                    if ( nexiSystem != OB_IdentifyCompany_CC.GT )
                    {
                        //to do
                        query += '(OB_Processor__c = \'' + nexiSystem + '\' AND OB_CompanyCode__c = \'' + code + '\')';
                    }
                    if ( codeCounter < missingCodes.size( ) )
                    {
                        query += ' OR ';
                    }
                    if ( codeCounter == missingCodes.size( ) )
                    {
                        query += ' ) ';
                    }
                    codeCounter++;

                }
                if ( systemCounter < codeObject.size( ) )
                {
                    query += ' OR ';
                }
                if ( systemCounter == codeObject.size( ) )
                {
                    query += ' ) ';
                }
                systemCounter++;
            }
            query += ' AND (NE__Status__c=\'Pending\' or NE__Status__c=\'Waiting for approval\') ';
            System.debug( 'query : ' + query );
            orderItemList = Database.query( query );

            //***GIOVANNI SPINELLI - 29/10/2018 - QUERY TO CONTROL IF MERCHANT HAS AN ASSET - START***//
            String queryAsset = 'SELECT AccountId,Id,Name,OB_CompanyCode__c,OB_CustomerCode__c,OB_GT__c,OB_Processor__c FROM Asset WHERE ';
            if ( operator == 'equal' )
            {
                queryAsset += 'AccountId =: merchantId ';

            }
            else
            {
                queryAsset += 'AccountId !=: merchantId ';
            }
            queryAsset += 'AND ';
            Integer assetCounter = 1;
            queryAsset += '(';
            for ( String nexiSystem : codeObject.keyset( ) )
            {
                nexiSystemList.add( nexiSystem );
                Map<String, Object> missingCodes = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( codeObject.get( nexiSystem ) ) ) ;
                Integer codeCounter = 1;
                queryAsset += '(';
                for ( String code : missingCodes.keyset( ) )
                {
                    codeList.add( code );
                    System.debug( 'nexiSystem : ' + nexiSystem );
                    //IF NEXI SYSTEM IS MONETICA USE THE GT AND THE CUSTOMER CODE
                    if ( nexiSystem == OB_IdentifyCompany_CC.GT )
                    {
                        //to do
                        queryAsset += '(OB_GT__c = \'' + OB_IdentifyCompany_CC.GT + '\' AND OB_CustomerCode__c = \'' + code + '\')';
                    }
                    //IF NEXI SYSTEM ISN'T MONETICA USE THE PROCESSOR AND THE COMPANY CODE
                    if ( nexiSystem != OB_IdentifyCompany_CC.GT )
                    {
                        //to do
                        queryAsset += '(OB_Processor__c = \'' + nexiSystem + '\' AND OB_CompanyCode__c = \'' + code + '\')';
                    }
                    if ( codeCounter < missingCodes.size( ) )
                    {
                        queryAsset += ' OR ';
                    }
                    if ( codeCounter == missingCodes.size( ) )
                    {
                        queryAsset += ' ) ';
                    }
                    codeCounter++;

                }
                if ( assetCounter < codeObject.size( ) )
                {
                    queryAsset += ' OR ';
                }
                if ( assetCounter == codeObject.size( ) )
                {
                    queryAsset += ' ) ';
                }
                assetCounter++;
            }

            System.debug( 'queryAsset : ' + queryAsset );
            assetList = Database.query( queryAsset );
            System.debug( 'assetList : ' + assetList );

            //CREATE A FAKE ORDER ITEM WITH FIELDS FROM ASSET WHERE SAVE THE VALUE AND PASS AS AN ORDER ITEM

            for ( Asset asset : assetList )
            {
                if ( asset.OB_GT__c == OB_IdentifyCompany_CC.GT )
                {
                    if ( mapOrderItemTmp.containsKey( asset.OB_GT__c ) )
                    {
                        mapOrderItemTmp = mapOrderItem.get( OB_IdentifyCompany_CC.GT );
                        System.debug( 'mapOrderItemTmp 4: ' + mapOrderItemTmp );
                    }
                }
                else if ( mapOrderItemTmp.containsKey( asset.OB_Processor__c ) )
                {
                    mapOrderItemTmp = mapOrderItem.get( asset.OB_Processor__c );
                    System.debug( 'mapOrderItemTmp 5: ' + mapOrderItemTmp );
                }

                if ( !mapOrderItemTmp.containsKey( asset.OB_CustomerCode__c ) || !mapOrderItemTmp.containsKey( asset.OB_CompanyCode__c ) )
                {
                    System.debug( 'BIG IF' );
                    if ( asset.OB_GT__c == OB_IdentifyCompany_CC.GT )
                    {

                        NE__OrderItem__c orderExternal = new NE__OrderItem__c( OB_GT__c = asset.OB_GT__c, OB_CustomerCode__c = asset.OB_CustomerCode__c, NE__AssetItemEnterpriseId__c = asset.Id, NE__Account__c = asset.AccountId );
                        mapOrderItemTmp.put( asset.OB_CustomerCode__c, orderExternal );
                        mapOrderItem.put( OB_IdentifyCompany_CC.GT, mapOrderItemTmp );
                        System.debug( 'orderExternal 1:  ' + orderExternal );
                    }
                    else
                    {

                        NE__OrderItem__c orderExternal = new NE__OrderItem__c( OB_Processor__c = asset.OB_Processor__c, OB_CompanyCode__c = asset.OB_CompanyCode__c, NE__AssetItemEnterpriseId__c = asset.Id, NE__Account__c = asset.AccountId );
                        mapOrderItemTmp.put( asset.OB_CompanyCode__c, orderExternal );
                        mapOrderItem.put( asset.OB_Processor__c, mapOrderItemTmp );
                        System.debug( 'orderExternal 1:  ' + orderExternal );
                    }

                }
            }
            System.debug( 'mapOrderItem after asset: ' + mapOrderItem );
            //***GIOVANNI SPINELLI - 29/10/2018 - QUERY TO CONTROL IF MERCHANT HAS AN ASSET - END  ***//

            System.debug( 'orderItemList : ' + orderItemList );
            for ( NE__OrderItem__c orderItem : orderItemList )
            {


                if ( orderItem.OB_GT__c == OB_IdentifyCompany_CC.GT )
                {
                    if ( mapOrderItemTmp.containsKey( orderItem.OB_GT__c ) )
                    {
                        mapOrderItemTmp = mapOrderItem.get( OB_IdentifyCompany_CC.GT );
                        System.debug( 'mapOrderItemTmp 2: ' + mapOrderItemTmp );
                    }


                }
                else if ( mapOrderItemTmp.containsKey( orderItem.OB_Processor__c ) )
                {

                    mapOrderItemTmp = mapOrderItem.get( orderItem.OB_Processor__c );
                    System.debug( 'mapOrderItemTmp 3: ' + mapOrderItemTmp );
                }


                //Map<String , NE__OrderItem__c> mapOrderItemTmp = new Map<String , NE__OrderItem__c>();


                if ( orderItem.OB_GT__c == OB_IdentifyCompany_CC.GT )
                {
                    System.debug( 'mapOrderItemTmp: ' + mapOrderItemTmp );
                    System.debug( 'orderItem.OB_CustomerCode__c: ' + orderItem.OB_CustomerCode__c );
                    System.debug( 'orderItem: ' + orderItem );
                    mapOrderItemTmp.put( orderItem.OB_CustomerCode__c, orderItem );
                    mapOrderItem.put( OB_IdentifyCompany_CC.GT, mapOrderItemTmp );
                }
                else
                {
                    mapOrderItemTmp.put( String.valueOf( orderItem.OB_CompanyCode__c ), orderItem );
                    mapOrderItem.put( orderItem.OB_Processor__c, mapOrderItemTmp );
                }


            }

            System.debug( 'orderItemList : ' + orderItemList );

            //CODE TO FIND A CODE IN EXTENAL SOURCE MAP
            if ( operator == 'different' && codeList.size( ) > 0 && nexiSystemList.size( ) > 0 )
            {

                for ( ExternalSourceMapping__c externalRow :
                [
                        SELECT id, OB_CustomerCodeClientCode__c, OB_Source__c
                        FROM ExternalSourceMapping__c
                        WHERE OB_Merchant_ID__c != :merchantId AND OB_CustomerCodeClientCode__c in:codeList AND OB_Source__c in:nexiSystemList
                ] )
                {


                    if ( externalRow.OB_Source__c == OB_IdentifyCompany_CC.GT )
                    {
                        if ( mapOrderItemTmp.containsKey( externalRow.OB_Source__c ) )
                        {
                            mapOrderItemTmp = mapOrderItem.get( OB_IdentifyCompany_CC.GT );
                            System.debug( 'mapOrderItemTmp 2: ' + mapOrderItemTmp );
                        }


                    }
                    else if ( mapOrderItemTmp.containsKey( externalRow.OB_Source__c ) )
                    {

                        mapOrderItemTmp = mapOrderItem.get( externalRow.OB_Source__c );
                        System.debug( 'mapOrderItemTmp 3: ' + mapOrderItemTmp );
                    }


                    //Map<String , NE__OrderItem__c> mapOrderItemTmp = new Map<String , NE__OrderItem__c>();

                    if ( !mapOrderItemTmp.containsKey( externalRow.OB_CustomerCodeClientCode__c ) )
                    {
                        if ( externalRow.OB_Source__c == OB_IdentifyCompany_CC.GT )
                        {
                            NE__OrderItem__c orderExternal = new NE__OrderItem__c( OB_GT__c = externalRow.OB_Source__c, OB_CustomerCode__c = externalRow.OB_CustomerCodeClientCode__c, NE__AssetItemEnterpriseId__c = externalRow.Id );
                            //System.debug('mapOrderItemTmp: ' + mapOrderItemTmp);
                            //System.debug('orderItem.OB_CustomerCode__c: ' + orderItem.OB_CustomerCode__c);
                            //System.debug('orderItem: ' + orderItem);
                            mapOrderItemTmp.put( externalRow.OB_CustomerCodeClientCode__c, orderExternal );
                            mapOrderItem.put( OB_IdentifyCompany_CC.GT, mapOrderItemTmp );
                        }
                        else
                        {
                            NE__OrderItem__c orderExternal = new NE__OrderItem__c( OB_Processor__c = externalRow.OB_Source__c, OB_CompanyCode__c = externalRow.OB_CustomerCodeClientCode__c, NE__AssetItemEnterpriseId__c = externalRow.Id );
                            mapOrderItemTmp.put( externalRow.OB_CustomerCodeClientCode__c, orderExternal );
                            mapOrderItem.put( externalRow.OB_Source__c, mapOrderItemTmp );
                        }
                    }
                    System.debug( 'diffenteExternal: ' + mapOrderItem );
                }


            }


        } catch ( DmlException e )
        {
            System.debug( 'exception from getPendingOrderFromCode ' + e.getStackTraceString( ) );
        }
        System.debug( 'mapOrderItem : ' + mapOrderItem );
        return mapOrderItem;
    }
    @AuraEnabled
    public static List<ExternalSourceMapping__c> checkOtherMerchantByCod( List<String> code, String merchantId )
    {
        System.debug( 'checkOtherMerchantByCod method' + code );
        List<ExternalSourceMapping__c> merchantList = new List<ExternalSourceMapping__c>( );
        try
        {
            merchantList =
            [
                    SELECT OB_Merchant_ID__c, OB_Merchant_ID__r.name, OB_Merchant_ID__r.NE__Fiscal_code__c, OB_Merchant_ID__r.NE__VAT__c, OB_CustomerCodeClientCode__c, OB_ToBeChecked__c
                    FROM ExternalSourceMapping__c
                    WHERE OB_CustomerCodeClientCode__c in:code and OB_Merchant_ID__c = :merchantId
            ];


        } catch ( DmlException e )
        {
            System.debug( 'exception from checkOtherMerchantByCod: ' + e.getStackTraceString( ) );
        }
        System.debug( 'merchant list with another fc ' + merchantList );
        return merchantList;


    }
    @AuraEnabled
    public static List<ExternalSourceMapping__c> updateMerchantCodes( String merchantId, Map<String, Object> MIPAndSfdcArray, Map<String, Object> sfdcOnlyArray, Map<String, Object> MIPOnlyArray )
    {

        System.debug( 'INTO UPDATE MERCHANT' );
        System.debug( 'MIPAndSfdcArray: ' + MIPAndSfdcArray );
        System.debug( 'sfdcOnlyArray: ' + sfdcOnlyArray );
        System.debug( 'MIPOnlyArray: ' + MIPOnlyArray );
        System.debug( 'merchantId in updatemerchant:  ' + merchantId );
        List<Id> servicePointListId = new List<Id>( );
        for ( NE__Service_Point__c sp : [ SELECT id FROM NE__Service_Point__c WHERE NE__Account__c = :merchantId ] )
        {
            servicePointListId.add( sp.id );
        }


        List<ExternalSourceMapping__c> servicePointExternalList =
        [
                SELECT id, OB_CustomerCodeClientCode__c, OB_ToBeChecked__c,OB_Service_Point_ID__c
                FROM ExternalSourceMapping__c
                WHERE OB_Merchant_ID__c = '' AND OB_Service_Point_ID__c IN:servicePointListId
        ];
        System.debug( 'servicePointExternalList: ' + servicePointExternalList );
        //SAME MERCHANT
        //CREATE A MAP FOR THE CONTROL WITH SAME FISCAL CODE
        Map<String, Map<String, NE__OrderItem__c>> sfdcOnlyMap = OB_IdentifyCompany_CC.getPendingOrderFromCode( merchantId, 'equal', sfdcOnlyArray );
        System.debug( 'sfdcOnlyMap: ' + sfdcOnlyMap );
        List<Account> merchantUpdate = new List<Account>( );
        List<NE__Service_Point__c> servicePointUpdate = new List<NE__Service_Point__c>( );
        List<ExternalSourceMapping__c> codeToUpdate = new List<ExternalSourceMapping__c>( );
        List<ExternalSourceMapping__c> codeToInsert = new List<ExternalSourceMapping__c>( );
        List<ExternalSourceMapping__c> codeToDeleted = new List<ExternalSourceMapping__c>( );
        List<Id> otherMerchantId = new List<Id>( );
        List<String> otherMerchantCode = new List<String>( );
        try
        {
            //ITERATION THROUGH THE SYSTEM IN THE ARRAY WITH SFDC CODES
            for ( String nexiSystem : sfdcOnlyArray.keyset( ) )
            {

                System.debug( 'sfdcOnlyArray.keyset(): ' + sfdcOnlyArray.keyset( ) );
                System.debug( 'nexiSystem: ' + nexiSystem );
                System.debug( 'sfdcOnlyMap.get(nexiSystem): ' + sfdcOnlyMap.get( nexiSystem ) );
                System.debug( 'sfdcOnlyMap.containsKey(nexiSystem): ' + sfdcOnlyMap.containsKey( nexiSystem ) );
                //IF THE MAP CONTAINS THE SYSTEM
                if ( sfdcOnlyMap.containsKey( nexiSystem ) )
                {
                    //Map<String, Object> pendingMapSerialized = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(sfdcOnlyMap.get(nexiSystem))) ;
                    Map<String, Object> pendingMapSerialized = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( sfdcOnlyArray.get( nexiSystem ) ) ) ;
                    //se fdc only map contiene nexi system
                    System.debug( 'pendingMapSerialized: ' + pendingMapSerialized );
                    Map<String, NE__OrderItem__c > sfdcOnlyMapCodes = sfdcOnlyMap.get( nexiSystem );
                    //ITERATION THROUGH THE CODES IN THE ARRAY WITH SFDC CODES
                    for ( String codes : pendingMapSerialized.keyset( ) )
                    {
                        System.debug( 'CODE SERIALIZED: ' + codes );
                        System.debug( 'sfdcOnlyMapCodes: ' + sfdcOnlyMapCodes );
                        System.debug( 'sfdcOnlyMapCodes.containsKey(codes): ' + sfdcOnlyMapCodes.containsKey( codes ) );
                        ExternalSourceMapping__c pendingObject = ( ExternalSourceMapping__c ) JSON.deserialize( JSON.serialize( pendingMapSerialized.get( codes ) ), ExternalSourceMapping__c.class );
                        System.debug( 'pendingObject TO DELETE 2 : ' + pendingObject );
                        if ( sfdcOnlyMapCodes.containsKey( codes ) )
                        {
                            System.debug( 'TO UPDATE' );
                            System.debug( 'pendingMapSerialized: ' + pendingMapSerialized );
                            //MARK THE MERCHANT AS TO VERIFY
                            Account tmpAccount = new Account( id = merchantId, OB_ToBeChecked__c = true, OB_BypassValidation__c = true );


                            //MARK THE EXTENAL SOURCE  AS TO VERIFY AND SET AN ERROR MESSAGE

                            ExternalSourceMapping__c tmpCode = new ExternalSourceMapping__c( id = pendingObject.Id, OB_ToBeChecked__c = true, OB_Description__c = 'Attenzione - Il codice: ' + codes + ' non risulta essere più associato a: ' + merchantId );
                            //UPDATE MERCHANT AND CODES
                            merchantUpdate.add( tmpAccount );
                            if(!codeToDeleted.contains(tmpCode)){   //francesca.ribezzi - 24/09/19 - check if list already contains element
                                codeToUpdate.add( tmpCode );
                            }
                            /*
                          QUERY ON SERVICE POINT WITH MERCHANT ID AND
                          UPDATE OF EXTERNAL SOURCE LINKED TO SERVICE POINT
                          */
                            for ( ExternalSourceMapping__c tmpExternal : servicePointExternalList )
                            {
                                if ( tmpExternal.OB_CustomerCodeClientCode__c == codes )
                                {
                                    tmpExternal.OB_ToBeChecked__c = true;
                                    tmpExternal.OB_Description__c = 'Attenzione - Il codice: ' + codes + ' non risulta essere più associato a: ' + merchantId;
                                     if(!codeToUpdate.contains(tmpExternal)){//francesca.ribezzi - 24/09/19 - check if list already contains element
                                        codeToUpdate.add( tmpExternal );
                                     }
                                    //MARK THE SERVICE POINT AS TO VERIFY
                                    System.debug( 'SERVICE POINT ID. ' + tmpExternal.OB_Service_Point_ID__c );
                                    NE__Service_Point__c tmpServicePoint = new NE__Service_Point__c( id = tmpExternal.OB_Service_Point_ID__c, OB_ToBeChecked__c = true, OB_BypassValidation__c = true );
                                    servicePointUpdate.add( tmpServicePoint );
                                }
                            }


                        }
                        else
                        {
                            System.debug( 'TO DELETE' );
                            //DELETE THE CODE WITH A SPECIFIC ID
                            ExternalSourceMapping__c tmpCode = new ExternalSourceMapping__c( id = pendingObject.Id );
                            if(!codeToDeleted.contains(tmpCode)){//francesca.ribezzi - 24/09/19 - check if list already contains element
                                codeToDeleted.add( tmpCode );
                            } 
                            /*
                          QUERY ON SERVICE POINT WITH MERCHANT ID AND
                          ELIMINATION OF EXTERNAL SOURCE LINKED TO SERVICE POINT
                          */
                            for ( ExternalSourceMapping__c tmpExternal : servicePointExternalList )
                            {
                                if ( tmpExternal.OB_CustomerCodeClientCode__c == codes )
                                {
                                    if(!codeToDeleted.contains(tmpCode)){//francesca.ribezzi - 24/09/19 - check if list already contains element
                                        codeToDeleted.add( tmpExternal );
                                    }
                                }
                            }
                        }
                    }
                }
                else
                //IF THE MAP DOESN'T CONTAINS THE SYSTEM
                {
                    System.debug( 'TO DELETE 2' );
                    Map<String, Object> pendingObjectMap = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( sfdcOnlyArray.get( nexiSystem ) ) );
                    // Map<String , ExternalSourceMapping__c>  pendingObjectMap = (Map<String , ExternalSourceMapping__c>)JSON.deserialize(JSON.serialize(sfdcOnlyArray.get(nexiSystem) , (Map<String , ExternalSourceMapping__c>).class );
                    System.debug( 'TO DELETE 2 CODE: ' + pendingObjectMap.keyset( ) );
                    for ( String codes : pendingObjectMap.keyset( ) )
                    {

                        System.debug( 'pendingObjectMap.get(codes) : ' + pendingObjectMap.get( codes ) );
                        //ExternalSourceMapping__c t =pendingObjectMap.get(codes);
                        ExternalSourceMapping__c pendingObject = ( ExternalSourceMapping__c ) JSON.deserialize( JSON.serialize( pendingObjectMap.get( codes ) ), ExternalSourceMapping__c.class );
                        //DELETE THE CODE WITH A SPECIFIC ID
                        System.debug( 'pendingObject TO DELETE : ' + pendingObject );
                        ExternalSourceMapping__c tmpCode = new ExternalSourceMapping__c( id = pendingObject.Id );
                        codeToDeleted.add( tmpCode );
                        /*
                      QUERY ON SERVICE POINT WITH MERCHANT ID AND
                      ELIMINATION OF EXTERNAL SOURCE LINKED TO SERVICE POINT
                      */
                        for ( ExternalSourceMapping__c tmpExternal : servicePointExternalList )
                        {
                            if ( tmpExternal.OB_CustomerCodeClientCode__c == codes )
                            {
                                if(!codeToDeleted.contains(tmpExternal)){//francesca.ribezzi - 24/09/19 - check if list already contains element
                                    codeToDeleted.add( tmpExternal );
                                }
                            }
                        }

                    }
                }
            }

            //*****CODES FROM MIP*****//

            Map<String, Map<String, NE__OrderItem__c>> MIPOnlyMap = OB_IdentifyCompany_CC.getPendingOrderFromCode( merchantId, 'different', MIPOnlyArray );
            System.debug( 'MIPOnlyMap: ' + MIPOnlyMap );
            System.debug( 'MIPOnlyArray in code from mip: ' + MIPOnlyArray );
            List<NE__Lov__c> lovPricing = [ SELECT Id,Name,NE__Value1__c,NE__Value2__c,NE__Value3__c FROM NE__Lov__c WHERE NE__Sub_Type__c = 'TIPOLOGICHE' AND NE__Type__c = 'SUBMIT' AND Name = 'OB_InternationalSettlementMethod__c' ];
            for ( String nexiSystem : MIPOnlyArray.keyset( ) )
            {
                System.debug( 'nexiSystem MIPOnlyArray: ' + nexiSystem );
                System.debug( 'MIPOnlyMap.containsKey(nexiSystem): ' + MIPOnlyMap.containsKey( nexiSystem ) );
                if ( MIPOnlyMap.containsKey( nexiSystem ) )
                {
                    Map<String, NE__OrderItem__c> MIPonlyMapCodes = MIPOnlyMap.get( nexiSystem );
                    System.debug( 'MIPonlyMapCodes ' + MIPonlyMapCodes );
                    // Map<String, Object> pendingMapSerialized = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(MIPOnlyMap.get(nexiSystem))) ;
                    Map<String, Object> pendingMapSerialized = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( MIPOnlyArray.get( nexiSystem ) ) ) ;
                    System.debug( 'pendingMapSerialized mip ' + pendingMapSerialized );
                    for ( String codes : pendingMapSerialized.keyset( ) )
                    {
                        System.debug( 'codes mip ' + codes );
                        System.debug( 'MIPonlyMapCodes.containsKey(codes) ' + MIPonlyMapCodes.containsKey( codes ) );
                        if ( MIPonlyMapCodes.containsKey( codes ) )
                        {
                            NE__OrderItem__c tmpItem = MIPonlyMapCodes.get( codes );
                            System.debug( 'tmpItem: ' + tmpItem );
                            System.debug( 'tmpItem NE__Account__c: ' + tmpItem.NE__Account__c );
                            //TO UPDATE AN ACCOUNT IT'S NECESSARY SET OB_BypassValidation__c AT TRUE TO BYPASS THE VALIDATION RULES
                            if ( !String.isBlank( tmpItem.NE__Account__c ) )
                            {
                                Account tmpAccount = new Account( id = tmpItem.NE__Account__c, OB_ToBeChecked__c = true, OB_BypassValidation__c = true );

                                System.debug( 'tmpAccount: ' + tmpAccount );
                                //ExternalSourceMapping__c pendingObject = (ExternalSourceMapping__c)JSON.deserializeUntyped(JSON.serialize(pendingMapSerialized.get(codes)));
                                //ExternalSourceMapping__c pendingObject = (ExternalSourceMapping__c)JSON.deserialize(JSON.serialize(pendingMapSerialized.get(codes)) , ExternalSourceMapping__c.class);
                                //ExternalSourceMapping__c tmpCode        = new ExternalSourceMapping__c(id=pendingObject.Id ,OB_ToBeChecked__c = true );
                                // if(!String.isBlank(tmpAccount.id ))
                                merchantUpdate.add( tmpAccount );
                                //codeToUpdate.add(tmpCode);
                                //IDENTIFY THE CODE ASSOCIATED TO ANOTHER MERCHANT
                                otherMerchantId.add( tmpItem.NE__Account__c );
                                otherMerchantCode.add( codes );
                                System.debug( 'otherMerchantCode 1: ' + otherMerchantCode );
                            }
                            else
                            {
                                //GIOVANNI SPINELLI 24/10/2018
                                //INSERIRE UN IF
                                ExternalSourceMapping__c tmpCodeDelete = new ExternalSourceMapping__c( id = tmpItem.NE__AssetItemEnterpriseId__c );
                                //List<ExternalSourceMapping__c> tmpCodeDelete = [SELECT id,OB_CustomerCodeClientCode__c,OB_Merchant_ID__c  FROM ExternalSourceMapping__c WHERE OB_CustomerCodeClientCode__c=:codes];
                                System.debug( 'tmpCodeDelete.id ' + tmpCodeDelete );
                                //ExternalSourceMapping__c tmpCodeDelete  = new ExternalSourceMapping__c(OB_CustomerCodeClientCode__c=codes);
                                 if(!codeToDeleted.contains(tmpCodeDelete)){//francesca.ribezzi - 24/09/19 - check if list already contains element
                                    codeToDeleted.add( tmpCodeDelete );
                                 }
                                System.debug( 'delete 3' );
                                /*
                          QUERY ON SERVICE POINT WITH MERCHANT ID AND
                          ELIMINATION OF EXTERNAL SOURCE LINKED TO SERVICE POINT
                          */
                                for ( ExternalSourceMapping__c tmpExternal : servicePointExternalList )
                                {
                                    if ( tmpExternal.OB_CustomerCodeClientCode__c == codes )
                                    {
                                        System.debug( 'ELIMINATION EXT SP' );
                                        if(!codeToDeleted.contains(tmpCodeDelete)){ //francesca.ribezzi - 24/09/19 - check if list already contains element 
                                            codeToDeleted.add( tmpCodeDelete );
                                        }
                                    }
                                }
                            }
                        }
                        //else
                        //{
                        System.debug( 'MIP INSERT 1' );
                        String source = nexiSystem;
                        //CONTROL THE GT FROM MIP

                        if ( nexiSystem == OB_IdentifyCompany_CC.GT )
                        {
                            source = 'MONETICA';
                        }
                        //CODE TO INSERT IN SFDC
                        //MAPPING OF REPORT TYPE--->CONTROL VALUE OF NE__Value2__c
                        //????
                        Map<String, Object> pendingObjectMap_inner = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( pendingMapSerialized.get( codes ) ) );
                        Map<String, Object> pendingObjectMap_inner2 = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( pendingObjectMap_inner.get( codes ) ) );
                        String reportType = ( String ) pendingObjectMap_inner2.get( 'OB_ReportType__c' );
                        String pricing = ( String ) pendingObjectMap_inner2.get( 'OB_Pricing__c' );
                        String reportTypeForPicklist;

                        for ( NE__Lov__c lov : lovPricing )
                        {
                            System.debug( 'reportType in for: ' + reportType );
                            System.debug( 'NE__Value2__c : ' + lov.NE__Value2__c );
                            if ( lov.NE__Value2__c == reportType )
                            {
                                reportTypeForPicklist = lov.NE__Value1__c;

                            }
                            else
                            {
                                reportTypeForPicklist = reportType;
                            }
                            System.debug( 'reportTypeForPicklist: ' + reportTypeForPicklist );
                        }
                        String tmpDate = ( String ) ( pendingObjectMap_inner2.get( 'OB_Start_Date__c' ) );
                        Date startDate = Date.valueOf( tmpDate );
                        ExternalSourceMapping__c tmpCodeInsert = new ExternalSourceMapping__c( OB_CustomerCodeClientCode__c = codes, OB_Source__c = source, OB_Pricing__c = pricing, OB_ReportType__c = reportTypeForPicklist, OB_Start_Date__c = startDate );
                        System.debug( 'tmpCodeInsert 1: ' + tmpCodeInsert );
                        codeToInsert.add( tmpCodeInsert );
                        //}
                        /*
                          QUERY ON SERVICE POINT WITH MERCHANT ID AND
                          ELIMINATION OF EXTERNAL SOURCE LINKED TO SERVICE POINT
                          */
                        for ( ExternalSourceMapping__c tmpExternal : servicePointExternalList )
                        {
                            if ( tmpExternal.OB_CustomerCodeClientCode__c == codes )
                            {
                                System.debug( 'ELIMINATION EXT SP' );
                                if(!codeToDeleted.contains(tmpExternal)){  //francesca.ribezzi - 24/09/19 - check if list already contains element
                                    codeToDeleted.add( tmpExternal );
                                }
                            }
                        }


                    }
                }
                else
                {
                    System.debug( 'MIP INSERT 2' );
                    Map<String, Object> pendingObjectMap = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( MIPOnlyArray.get( nexiSystem ) ) );
                    System.debug( 'pendingObjectMap in MIP INSERT 2: ' + pendingObjectMap );
                    //MAPPING OF REPORT TYPE--->CONTROL VALUE OF NE__Value2__c
                    //????

                    for ( String codes : pendingObjectMap.keyset( ) )
                    {
                        System.debug( 'codes in MIP INSERT 2: ' + codes );
                        String source = nexiSystem;
                        System.debug( 'nexiSystem in mip insert 2; ' + nexiSystem );
                        //String startDate;OB_Start_Date__c=startDate,


                        if ( nexiSystem == OB_IdentifyCompany_CC.GT )
                        {
                            source = 'MONETICA';
                        }

                        Map<String, Object> pendingObjectMap_inner = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( pendingObjectMap.get( codes ) ) );
                        System.debug( 'code in mip insert 2: ' + codes );
                        System.debug( 'pendingObjectMap: ' + pendingObjectMap );
                        System.debug( 'pendingObjectMap.get(codes): ' + pendingObjectMap.get( codes ) );
                        System.debug( 'pendingObjectMap_inner: ' + pendingObjectMap_inner );
                        System.debug( 'pendingObjectMap_inner.get(codes): ' + pendingObjectMap_inner.get( codes ) );
                        Map<String, Object> pendingObjectMap_inner2 = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( pendingObjectMap_inner.get( codes ) ) );
                        String reportType = ( String ) pendingObjectMap_inner2.get( 'OB_ReportType__c' );
                        String pricing = ( String ) pendingObjectMap_inner2.get( 'OB_Pricing__c' );
                        String reportTypeForPicklist;
                        Date startDate;

                        for ( NE__Lov__c lov : lovPricing )
                        {
                            System.debug( 'reportType in for: ' + reportType );
                            System.debug( 'NE__Value2__c : ' + lov.NE__Value2__c );
                            if ( lov.NE__Value2__c == reportType )
                            {
                                reportTypeForPicklist = lov.NE__Value1__c;
                                break;

                            }
                            else
                            {
                                reportTypeForPicklist = reportType;
                            }
                            System.debug( 'reportTypeForPicklist: ' + reportTypeForPicklist );
                        }
                        if ( pendingObjectMap_inner2.get( 'OB_Start_Date__c' ) != null )
                        {
                            String tmpDate = ( String ) ( pendingObjectMap_inner2.get( 'OB_Start_Date__c' ) );
                            startDate = Date.valueOf( tmpDate );
                        }

                        //System.debug('pendingObjectMap_inner: ' + pendingObjectMap_inner2.get('OB_ReportType__c'));
                        ExternalSourceMapping__c tmpCodeInsert = new ExternalSourceMapping__c( OB_Merchant_ID__c = merchantId, OB_CustomerCodeClientCode__c = codes, OB_Source__c = source, OB_Pricing__c = pricing, OB_ReportType__c = reportTypeForPicklist, OB_Start_Date__c = startDate );
                        System.debug( 'tmpCodeInsert 2: ' + tmpCodeInsert );
                         if(!codeToInsert.contains(tmpCodeInsert)){  //francesca.ribezzi - 24/09/19 - check if list already contains element
                            codeToInsert.add( tmpCodeInsert );
                        }
                    }
                }

            }
            System.debug( 'otherMerchantId: ' + otherMerchantId );
            //DIFFERENT MERCHANT
            //IF THERE ARE OTHER MERCHANT WITH SAME CODES
            if ( otherMerchantId.size( ) > 0 )
            {
                System.debug( 'INTO OTHER MERCHANT: ' + otherMerchantId );
                List<Id> otherMerchantServicePointListId = new List<Id>( );
                for ( NE__Service_Point__c sp : [ SELECT id FROM NE__Service_Point__c WHERE NE__Account__c IN:otherMerchantId ] )
                {
                    otherMerchantServicePointListId.add( sp.id );
                }
                System.debug( 'otherMerchantServicePointListId: ' + otherMerchantServicePointListId );

                List<ExternalSourceMapping__c> otherMerchantServicePointExternalList =
                [
                        SELECT id, OB_CustomerCodeClientCode__c, OB_ToBeChecked__c,OB_Service_Point_ID__c
                        FROM ExternalSourceMapping__c
                        WHERE OB_Merchant_ID__c = '' AND OB_Service_Point_ID__c IN:otherMerchantServicePointListId
                ];

                System.debug( 'otherMerchantServicePointExternalList: ' + otherMerchantServicePointExternalList );
                //ITERATION THROUGH THE EXTENAL SOURCE MAPPING

                for ( ExternalSourceMapping__c code :
                [
                        SELECT id, OB_CustomerCodeClientCode__c, OB_ToBeChecked__c
                        FROM ExternalSourceMapping__c
                        WHERE OB_Merchant_ID__c IN:otherMerchantId AND OB_CustomerCodeClientCode__c IN:otherMerchantCode
                ] )
                {
                    System.debug( 'INTO OTHER MERCHANT code : ' + code );

                    // SET AN ERROR MESSAGE AND A CHECK
                    code.OB_ToBeChecked__c = true;
                    code.OB_Description__c = 'Attenzione - Il codice: ' + code.OB_CustomerCodeClientCode__c + '  risulta essere associato a: ' + merchantId ;
                    codeToUpdate.add( code );
                    /*
                      QUERY ON SERVICE POINT WITH MERCHANT ID AND
                      UODATE EXTERNAL SOURCE LINKED TO SERVICE POINT
                      */
                    System.debug( 'code.OB_CustomerCodeClientCode__c: ' + code.OB_CustomerCodeClientCode__c );
                    for ( ExternalSourceMapping__c tmpExternal2 : otherMerchantServicePointExternalList )
                    {
                        System.debug( 'tmpExternal2.: ' + tmpExternal2 );
                        if ( tmpExternal2.OB_CustomerCodeClientCode__c == code.OB_CustomerCodeClientCode__c )
                        {
                            System.debug( 'if differen merchant' );
                            tmpExternal2.OB_ToBeChecked__c = true;
                            tmpExternal2.OB_Description__c = 'Attenzione - Il codice: ' + code.OB_CustomerCodeClientCode__c + ' risulta essere associato a: ' + merchantId;
                           
                            codeToUpdate.add( tmpExternal2 );
                            //MARK THE SERVICE POINT AS TO VERIFY
                            NE__Service_Point__c tmpServicePoint = new NE__Service_Point__c( id = tmpExternal2.OB_Service_Point_ID__c, OB_ToBeChecked__c = true, OB_BypassValidation__c = true );
                            System.debug( 'tmpServicePoint: ' + tmpServicePoint );
                            servicePointUpdate.add( tmpServicePoint );
                        }
                    }
                }
            }

        } catch ( Exception ecc )
        {
            System.debug( 'Generic Error: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
        }


        try
        {
            if ( codeToUpdate.size( ) > 0 )
            {
                update codeToUpdate;
            }
            //if(codeToInsert.size() > 0){
            //  insert   codeToInsert;
            //}
            if ( merchantUpdate.size( ) > 0 )
            {
                update merchantUpdate;
            }
            if ( servicePointUpdate.size( ) > 0 )
            {
                update servicePointUpdate;
            }
            if ( codeToDeleted.size( ) > 0 )
            {
                delete codeToDeleted;
            }
        } catch ( DmlException e )
        {
            System.debug( 'The following exception has occurred: ' + e.getMessage( ) );
        }

        System.debug( 'codeToUpdate: ' + codeToUpdate );
        System.debug( 'codeToInsert: ' + codeToInsert );
        System.debug( 'servicePointUpdate: ' + servicePointUpdate );
        System.debug( 'merchantUpdate: ' + merchantUpdate + ' merchant size ' + merchantUpdate.size( ) );
        System.debug( 'codeToDeleted: ' + codeToDeleted );
        return codeToInsert;
    }
    //QUERY ALL LEGAL FROM FROM LOV TO TRANSLATE VALUE FROM MIP
    @AuraEnabled
    public static Map<String, String> getLegalFromValue( )
    {
        Map<String, String> legalFormMap = new Map<String, String>( );

        List<NE__Lov__c> legalFromLov =
        [
                SELECT CreatedById,CreatedDate,Id,Name,NE__Sub_Type__c,NE__Type__c,NE__Value1__c,NE__Value2__c,NE__Value3__c
                FROM NE__Lov__c

                WHERE NE__Sub_Type__c = 'TIPOLOGICHE' AND NE__Active__c = true AND NE__Type__c = 'LegalForm'
        ];
        for ( NE__Lov__c loveValue : legalFromLov )
        {
            legalFormMap.put( loveValue.NE__Value1__c, loveValue.Name );
        }
        System.debug( 'legalFormMap: ' + legalFormMap );
        return legalFormMap;

    }
    //QUERY ALL COUNTRY FROM FROM LOV TO TRANSLATE VALUE FROM MIP
    @AuraEnabled
    public static Map<String, String> getCountryValue( )
    {
        Map<String, String> countryMap = new Map<String, String>( );

        List<NE__Lov__c> countryFromLov =
        [
                SELECT CreatedById,CreatedDate,Id,Name,NE__Sub_Type__c,NE__Type__c,NE__Value1__c,NE__Value2__c,NE__Value3__c
                FROM NE__Lov__c
                WHERE NE__Sub_Type__c = 'TIPOLOGICHE' AND NE__Active__c = true and Name = 'country'
        ];
        for ( NE__Lov__c countryValue : countryFromLov )
        {
            countryMap.put( countryValue.NE__Value2__c, countryValue.NE__Value1__c );
        }
        System.debug( 'countryMap: ' + countryMap );
        return countryMap;

    }
    @AuraEnabled
    public static List<ExternalSourceMapping__c> getShopSign( String servicePointId )
    {
        System.debug( 'INTO RETRIEVE SHOP SIGN ' );
        System.debug( 'servicePointId: ' + servicePointId );
        //  R1F2-86 Micol Ferrari <micol.ferrari@accenture.com>, 03/05/2019 - START
        List<ExternalSourceMapping__c> toReturn = new List<ExternalSourceMapping__c>( );
        //  R1F2-86 Micol Ferrari <micol.ferrari@accenture.com>, 03/05/2019 - END
        try
        {
            //  R1F2-86 Micol Ferrari <micol.ferrari@accenture.com>, 03/05/2019 - ADDED LIST
            List<ExternalSourceMapping__c> externServicePointList = [ SELECT Id,Name,OB_Service_Point_ID__c,OB_ShopSign__c FROM ExternalSourceMapping__c WHERE OB_Service_Point_ID__c = :servicePointId ];

            //  R1F2-86 Micol Ferrari <micol.ferrari@accenture.com>, 03/05/2019 - START
            Set<String> setOfShopSign = new Set<String>();
            if (!externServicePointList.isEmpty())
            {
                for (ExternalSourceMapping__c esm : externServicePointList)
                {
                    setOfShopSign.add(esm.OB_ShopSign__c);
                }
                for (String shopsign : setOfShopSign)
                {
                    for (ExternalSourceMapping__c esm : externServicePointList)
                    {
                        if (esm.OB_ShopSign__c.equalsIgnoreCase(shopsign))
                        {
                            toReturn.add(esm);
                            break;
                        }
                    }
                }
            }
            //  R1F2-86 Micol Ferrari <micol.ferrari@accenture.com>, 03/05/2019 - END

            System.debug( 'externServicePointList: ' + externServicePointList );
        } catch ( Exception ecc )
        {
            System.debug( 'Generic Error: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
        }
         //  R1F2-86 Micol Ferrari <micol.ferrari@accenture.com>, 03/05/2019 - START
        return toReturn;
         //  R1F2-86 Micol Ferrari <micol.ferrari@accenture.com>, 03/05/2019 - END
    }

    @AuraEnabled
    public static NE__lov__c getMccLov( String MCCCodePv )
    {
        NE__lov__c lovMCC = new NE__lov__c( );

        try
        {
            lovMCC = [ SELECT Id,Name,NE__Sub_Type__c,NE__Type__c,NE__Value1__c,NE__Value2__c,NE__Value3__c FROM NE__Lov__c WHERE NE__type__c = 'mcc' AND NE__Value2__c = :MCCCodePv limit 1 ];
        } catch ( Exception ecc )
        {
            System.debug( 'Generic Error: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
        }
        return lovMCC;
    }
    @AuraEnabled
    public static Integer getTimeOut( )
    {
        String environment = null;
        OB_Integration_Configuration__c intConfig = new OB_Integration_Configuration__c( );

        try
        {
            //  START   micol.ferrari 17/01/2019 - GET CURRENT ORG NAME
            // environment = !Test.isRunningTest() ? system.Label.OB_Environment : 'DEV1';
            environment = !Test.isRunningTest( ) ? OB_UtilityCallingServices.returnCurrentOrg( ) : 'DEV1';
            //  END     micol.ferrari 17/01/2019 - GET CURRENT ORG NAME
            intConfig = OB_Integration_Configuration__c.getValues( environment );


        } catch ( Exception ecc )
        {
            System.debug( 'Generic Error: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
        }

        return Integer.valueOf( intConfig.OB_Timeout_Continuation__c );
    }


/********************************** START Antonio Vatrano  17-12-18 **********************/
    @AuraEnabled
    public static Object getretrieveMerchant( String fiscalCode, String vatCode )
    {
        Object res;
        try
        {
            res = OB_RetrieveAnagraficaMerchantController.retrieveMerchantNew( fiscalCode, vatCode );

        } catch ( Exception ecc )
        {
            System.debug( 'Generic Error: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
        }
        System.debug( '*****RES: ' + res );
        return res;
    }

/********************************** END Antonio Vatrano  17-12-18 **********************/


    @AuraEnabled
    public static userInfoWrapper getUserInformation( )
    {
        String partnerCommunity = System.Label.OB_License_PartnerCommunity;
        // String operationProfile = System.Label.OB_Operation;

        userInfoWrapper userInformationWrapper = new userInfoWrapper( );
        String userId = UserInfo.getUserId( );
        User currentUsr =
        [
                SELECT Id,
                        contactId,
                        contact.accountId,
                        Profile.UserLicense.Name,
                        Profile.Name,
                        OB_CAB__C,
                        OB_ABI__c
                FROM User
                WHERE Id = :userId
                LIMIT 1
        ];
        System.debug( '## current user is: ' + currentUsr );

        /*
    ----------- LOGIC ON WRAPPER --> IF IT'S NOT PARTNER COMMUNITY IT'S OPERATION!
    */
        try
        {
            //davide.franzini - 29/07/2019 - WN-212 - START
            userInformationWrapper.isPartner = false;
            userInformationWrapper.isOperation = true;
            //davide.franzini - 29/07/2019 - WN-212 - END

            if ( currentUsr.Profile.UserLicense.Name == partnerCommunity )
            {
                userInformationWrapper.isPartner = true;
                userInformationWrapper.isOperation = false;

                /*
            --- QUERY ON CUSTOM METADATA. I NEED IT FOR SET THE PROFILE NAME DYNAMICALLY
            */
                List<OB_ConfigurationInformation__mdt> listOfConfigurationInformations = new List<OB_ConfigurationInformation__mdt>( );
                listOfConfigurationInformations =
                [
                        SELECT Id,
                                MasterLabel,
                                Label,
                                QualifiedApiName,
                                OB_String_Value__c,
                                OB_String_Value_2__c
                        FROM OB_ConfigurationInformation__mdt
                        WHERE QualifiedApiName IN ('OB_MultiCABFirstStep', 'OB_multiCABbyLov', 'OB_singleCABonFirstStep')
                ];


                /*
    ----------- THROUGH THE String_Value_2 I check if I have multi cab, single cab or cab By ListOfValues (L1 profile, L2 Profile, L3 Profile)
    */
                Set<String> profileNames = new Set<String>( );
                System.debug( '## currentUsr.Profile.Name is:  ' + currentUsr.Profile.Name );
                for ( OB_ConfigurationInformation__mdt singleConfMdt : listOfConfigurationInformations )
                {
                    profileNames.addAll( ( singleConfMdt.OB_String_Value__c.split( ';' ) ) );
                    if ( singleConfMdt.OB_String_Value_2__c == 'LOV' && currentUsr.Profile.Name.contains( singleConfMdt.OB_String_Value__c ) )
                    {
                        userInformationWrapper.CABnature = singleConfMdt.OB_String_Value_2__c;
                    }
                    else if ( singleConfMdt.OB_String_Value_2__c == 'multiCAB' && currentUsr.Profile.Name.contains( singleConfMdt.OB_String_Value__c ) )
                    {
                        userInformationWrapper.CABnature = singleConfMdt.OB_String_Value_2__c;
                    }
                    else if ( singleConfMdt.OB_String_Value_2__c == 'singleCAB' && currentUsr.Profile.Name.contains( singleConfMdt.OB_String_Value__c ) )
                    {
                        userInformationWrapper.CABnature = singleConfMdt.OB_String_Value_2__c;
                    }
                }

                if ( !String.isBlank( currentUsr.OB_ABI__c ) )
                {
                    userInformationWrapper.ABI = currentUsr.OB_ABI__c;
                }
                else
                {
                    userInformationWrapper.hasError = true;
                }

                if ( !String.isBlank( currentUsr.OB_CAB__C ) )
                {                    
                    if ( ( currentUsr.OB_CAB__C ).contains( ';' ) )
                    {
                        userInformationWrapper.CAB.addAll( ( currentUsr.OB_CAB__C ).split( ';' ) );
                    }
                    else if ( ( currentUsr.OB_CAB__C ).length( ) == 5 )
                    {
                        userInformationWrapper.CAB.add( currentUsr.OB_CAB__C );
                    }
                }

                /* IT MUST BE FIRED ONLY WHEN ABI ANd CAB ARE PRESENT */
                /* ANDREA MORITTU START 01-Jul-19 - DECOMMENT Bank Profile area (hotFix)*/
                OB_Bank_Profile__c bankProfile = new OB_Bank_Profile__c();
                bankProfile=[SELECT id ,
                                                OB_Business_Model_Acquiring__c,
                                                OB_Bank__c ,
                                                OB_GT__c ,
                                                OB_Business_Model_POS__c ,
                                                OB_Circuit__c,
                                                OB_Other_Acquirer__c ,
                                                OB_Service_Type__c,
                                                OB_Apm_Circuit__c,
                                                OB_Vas__c,
                                                OB_SettlementType__c,
                                                OB_AccountHolder__c,
                                                OB_Applicant_RAC_Code_SIA__c,
                                                OB_Terminal_Id_Generator__c,
                                                OB_Terminal_Id_Gateway__c, //davide.franzini - F2WAVE2-4 - 17/07/2019
                                                OB_Show_check_in_date__c, //davide.franzini - WN-215 - 30/07/2019
                                                OB_NeedBIO__c ,
                                                OB_NDG__c
                                                FROM OB_Bank_Profile__c
                                                WHERE OB_Bank__c=: currentUsr.contact.accountId
                                                LIMIT 1];
                /* ANDREA MORITTU END 01-Jul-19 - DECOMMENT Bank Profile area (hotFix)*/
                //davide.franzini - 29/07/2019 - WN-212 - START
                if ( bankProfile == null || bankProfile.OB_Business_Model_Acquiring__c == null )
                {
                    throw new OB_IdentifyCompany_Exception('OB_IdentifyCompany_CC Exception: Bank Profile is not valid');
                }
                
                userInformationWrapper.bankProfileObject = bankProfile;
                userInformationWrapper.bankProfile = OB_IdentifyCompany_CC.getMapBankId( userInformationWrapper.bankProfileObject );
                //davide.franzini - 29/07/2019 - WN-212 - END
            }
        } catch ( Exception ecc )
        {
            System.debug( 'The following exception has occurred: ' + 'at line: ' + ecc.getLineNumber( ) + 'message : ' + ecc.getMessage( ) );
        }
        System.debug('XXX userInformationWrapper ' + userInformationWrapper);
        return userInformationWrapper;
    }

    //11/03//2019 - GIOVANNI SPINELLI - QUERY WITH L3 LOOKUP TO FIND PARENT L2
    @AuraEnabled
    public static NE__lov__c getMccLovL2( String lookupID )
    {
        List<NE__lov__c> mcclist = new List<NE__lov__c>( );
        System.debug( 'INTO CALL MCC L2' );
        System.debug( 'lookupID: ' + lookupID );
        try
        {
            mcclist = [ SELECT Id,Name,NE__Sub_Type__c,NE__Type__c,NE__Value1__c,NE__Value2__c,NE__Value3__c,OB_Value4__c FROM NE__Lov__c WHERE NE__Type__c = 'mcc' AND Id = :lookupID ];
        } catch ( Exception ecc )
        {
            System.debug( 'Generic Error: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
        }
        System.debug( '*****RES: ' + mcclist.get( 0 ) );
        return mcclist.get( 0 );
    }
    /*
    * Author : Giovanni Spinelli
    * Date : 27/09/2019
    * Description : get service point whe flow is fired from maintenance
    */
    @AuraEnabled
    public static List<NE__Service_Point__c> retrieveAutomaticSp( String servicePointId )
    {
        return [SELECT id , OB_MCC__c , OB_MCC_Description__c, Name, OB_Annual_Negotiated__c, 
                        OB_Annual_revenue__c ,OB_Typology__c, OB_Stato_IT_Service_Point__c, 
                        NE__City__c , NE__Street__c ,OB_Address_Detail__c, NE__Country__c ,
                        NE__Zip_code__c ,NE__Province__c, OB_Street_Number__c,OB_District__c,
                        NE__Account__c ,
                        NE__Account__r.Name , 
                        NE__Account__r.NE__Fiscal_code__c ,
                        NE__Account__r.NE__VAT__c,OB_Opening_Time__c,OB_Ending_Time__c,
                        OB_Break_Start_Time__c,OB_Break_End_Time__c, 
                        OB_Opening_Monday_Morning__c, OB_Opening_Monday_Afternoon__c,
                        OB_Opening_Tuesday_Morning__c, OB_Opening_Tuesday_Afternoon__c, 
                        OB_Opening_Wednesday_Morning__c,OB_Opening_Wednesday_Afternoon__c, 
                        OB_Opening_Thursday_Morning__c,OB_Opening_Thursday_Afternoon__c,
                        OB_Opening_Friday_Morning__c,OB_Opening_Friday_Afternoon__c,
                        OB_Opening_Saturday_Morning__c, OB_Opening_Saturday_Afternoon__c,
                        OB_Opening_Sunday_Morning__c, OB_Opening_Sunday_Afternoon__c,
                        OB_End_Seasonal__c,OB_Start_Seasonal__c
                FROM NE__Service_Point__c 
                WHERE id=:servicePointId
                LIMIT 1];
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

    // andrea.morittu start 2019.05.02 --> WrapperClass for checking merchant takeover
    public class MerchantFromAssetWrapper {
        @AuraEnabled Asset draggedAsset                             {get; set;}
        @AuraEnabled String relatedServicePoint                     {get; set;}
        @AuraEnabled String formalCheckOnServicePointType           {get; set;}
        @AuraEnabled String merchantId                              {get; set;}
        @AuraEnabled String merchantFiscalCode                      {get; set;}
        @AuraEnabled String merchantVAT                             {get; set;}
        @AuraEnabled Boolean merchantTakeover                       {get; set;}
        @AuraEnabled String maintenanceChoosenCAB                   {get; set;}
        @AuraEnabled List<String> objectIds                         {get; set;}
        
        public  MerchantFromAssetWrapper() {
            draggedAsset = new Asset();
            objectIds      = new List<String>();
        }
    }
    /*  -------------------------------------------
        @Author:         Andrea Morittu (andrea.morittuaccenture.com)
        @Description:    formal check if, on merchant takeover, the user chose the same merchant. 
        @Task:           Id_Stream_Subentro_6
        @Date            02/05/2019
        @ History:      Added custom metadata for retrieve the profile name( pre-set the old selected cab in maintenance)
        -------------------------------------------    
    */
    @AuraEnabled
    @TestVisible
    public static MerchantFromAssetWrapper formalCheckOnSameMerchant(String orderAssetId){
        MerchantFromAssetWrapper merchantTakeOverObj = new MerchantFromAssetWrapper();

        String partnerCommunity = System.Label.OB_License_PartnerCommunity;

        List<Asset> assetList  = new List<Asset>();
        if(!String.isBlank(orderAssetId)) {
            merchantTakeOverObj.merchantTakeover= true;

            assetList = [SELECT  Id, 
                                 Name,
                                 Account.Name,
                                 AccountId,
                                 Account.NE__Fiscal_code__c,
                                 Account.NE__VAT__c,
                                 NE__Service_Point__c,
                                 NE__Service_Point__r.RecordType.Name,
                                 OB_Takeover_CAB__c,
                                 OB_MerchantTakeover__c
                         FROM Asset 
                         WHERE Id =: orderAssetId 
                         LIMIT 1];


            if(!assetList.isEmpty()) {
                /* 
                    @Author: ANDREA MORITTU
                    @History: Added a method that update to true the Asset field named
                        OB_MerchantTakeOverProcess.
                */
                OB_IdentifyCompany_CC.updateAssetMerchantTakeOver(assetList.get(0));
                 /* 
                    @History 
                    END
                */
                merchantTakeOverObj.draggedAsset        =   assetList.get(0);
                merchantTakeOverObj.merchantId          =   assetList.get(0).AccountId;
                merchantTakeOverObj.merchantFiscalCode  =   assetList.get(0).Account.NE__Fiscal_code__c;
                merchantTakeOverObj.merchantVAT         =   assetList.get(0).Account.NE__VAT__c;
                merchantTakeOverObj.relatedServicePoint =   assetList.get(0).NE__Service_Point__c;
                merchantTakeOverObj.formalCheckOnServicePointType = assetList.get(0).NE__Service_Point__r.RecordType.Name;
                (merchantTakeOverObj.objectIds).add(assetList.get(0).AccountId);
                (merchantTakeOverObj.objectIds).add(assetList.get(0).NE__Service_Point__c);
                // ANDREA . MORITTU START 2019.05.09
                String userId = UserInfo.getUserId( );
                User currentUsr = [ SELECT  Id,
                                            Profile.UserLicense.Name,
                                            Profile.Name
                                    FROM User
                                    WHERE Id = :userId
                                    LIMIT 1 ];
                OB_ConfigurationInformation__mdt takeoverMDT = new OB_ConfigurationInformation__mdt( );
                                    takeoverMDT = [ SELECT  Id,
                                                            MasterLabel,
                                                            Label,
                                                            QualifiedApiName,
                                                            OB_String_Value__c,
                                                            OB_String_Value_2__c
                                                    FROM OB_ConfigurationInformation__mdt
                                                    WHERE QualifiedApiName = 'OB_L2orL3ProfileInMerchantTakeOver' ];
                List<String> profilesBYcustomMDT = (takeoverMDT.OB_String_Value__c).split(';');
                if (currentUsr.Profile.UserLicense.Name == partnerCommunity ) { 
                    for(String singleProfileByMDT : profilesBYcustomMDT) {    
                        if(currentUsr.Profile.Name.equalsIgnoreCase(singleProfileByMDT) ) {
                            merchantTakeOverObj.maintenanceChoosenCAB  =   assetList.get(0).OB_Takeover_CAB__c;
                        }                     
                    }
                }
                // ANDREA . MORITTU END 2019.05.09
            }

           
        }
        System.debug('merchantTakeOverObj is : ' +  merchantTakeOverObj);
        return merchantTakeOverObj;
    }

    /*
    -------------------------------------------
        @Author:         Andrea Morittu (andrea.morittuaccenture.com)
        @Description:    formal check if, on merchant takeover process, 
                            the user chose the same merchant or an incoerent Service Point. 
        @Task:           Id_Stream_Subentro_6
        @Date            02/05/2019
    --------------------------------------------
    */
    @AuraEnabled
    @TestVisible
    public static Map<String,Boolean> formalCheckOnOldData (String fiscalCode, String VAT, String oldObjectsInfoStringified, String servicePointType){

        Map<String,Boolean> toReturn = new Map<String,Boolean>();
        System.debug('oldObjectsInfoStringified is : '+ oldObjectsInfoStringified);   
        if(oldObjectsInfoStringified != null) {
            MerchantFromAssetWrapper customObjectInfoWrapper =(MerchantFromAssetWrapper) JSON.deserialize(oldObjectsInfoStringified, MerchantFromAssetWrapper.class);
            if(!String.isEmpty(fiscalCode)) {
                if(customObjectInfoWrapper.merchantFiscalCode == fiscalCode) {
                    toReturn.put('errorOnMerchantFISCALCODE', true);
                }
            }
            else if(!String.isEmpty(VAT)) {
                if(customObjectInfoWrapper.merchantVAT == VAT) {
                    toReturn.put('errorOnMerchantVAT', true);
                }
            }
                
            if( !String.isEmpty(servicePointType) && 
                customObjectInfoWrapper.formalCheckOnServicePointType != servicePointType) {
                toReturn.put('errorOnServicePointType', true);
            }
        }
        return toReturn;
    }

    /*
    -------------------------------------------
        @Author:         Andrea Morittu (andrea.morittu@accenture.com)
        @Task:           Id_Stream_Subentro_6
        @Date            14/05/2019
    --------------------------------------------
    */
    @AuraEnabled
    @TestVisible
    public static void updateAssetMerchantTakeOver(Asset assetToUpdate){
        List<Asset> listToUpdate = new List<Asset>();
        if(assetToUpdate != null) {
            assetToUpdate.OB_MerchantTakeover__c = true;
            listToUpdate.add(assetToUpdate);
            update listToUpdate;
        }
    }
     /*
    -------------------------------------------
        @Author:         Andrea Morittu (andrea.morittu@accenture.com)
                                END
    --------------------------------------------
    */

    public class OB_IdentifyCompany_Exception extends Exception {}  //davide.franzini - 29/07/2019 - WN-212

}