public without sharing class ModalLookupController
{
    private static final String OB_LOV_TYPE_ATECO = 'ATECO'; // NEXI-120 Marta Stempien <marta.stempien@accenture.com> 24/07/2019
    @AuraEnabled
    public static List<NE__LOV__c> getLovsByType( String type, String subType, String subTypeField, String input, Map<String, String> mapOfSourceFieldTargetField,
            Map<String, String> mapLabelColumns, String orderBy, String ascDesc, String inputFieldForLike, String level, String lookupLov )
    {
        System.debug( 'sono nel LegalFormController, metodo getLovsByType' );
        System.debug( 'inputFieldForLike: ' + inputFieldForLike );
        System.debug( 'subtype: ' + subType );
        System.debug( 'subTypeField: ' + subTypeField );
        System.debug( 'level: ' + level );
        System.debug( 'input: ' + input );
        System.debug( 'lookupLov: ' + lookupLov );
        System.debug( 'mapOfSourceFieldTargetField: ' + mapOfSourceFieldTargetField );
        System.debug( 'type: ' + type );

        /*  START   micol.ferrari 25/09/2018 - QUERY THE VALUES FROM mapOfSourceFieldTargetField AND mapLabelColumns */
        List<String> listOfFieldsToQuery = new List<String>( );
        Set<String> setOfMapsValue = new Set<String>( );
        if ( !mapOfSourceFieldTargetField.values( ).isEmpty( ) && !mapLabelColumns.keySet( ).isEmpty( ) )
        {
            setOfMapsValue.addAll( mapOfSourceFieldTargetField.values( ) );
            setOfMapsValue.addAll( mapLabelColumns.keySet( ) );
            listOfFieldsToQuery.addAll( setOfMapsValue );
        }
        /*  END   micol.ferrari 25/09/2018 - QUERY THE VALUES FROM mapOfSourceFieldTargetField AND mapLabelColumns */

        List<NE__LOV__c> lovs = new List<NE__LOV__c>( );
        try
        {
            if ( String.isEmpty( input ) )
            {
                System.debug( 'input is empty' );
                String query = 'SELECT ';

                /*  START   micol.ferrari 25/09/2018 */
                if ( !listOfFieldsToQuery.isEmpty( ) )
                {
                    for ( String s : listOfFieldsToQuery )
                    {
                        query += s + ',';
                    }
                }
                /*  END   micol.ferrari 25/09/2018 */

                query += 'NE__Type__c from NE__Lov__c where NE__Active__c=true  AND NE__Type__c=\'' + type + '\'';
                //giovanni spinelli
                if ( level == 'L1' )
                {
                    query += 'AND NE__Value3__c = \'' + level + '\'';
                }
                else if ( level == 'L2' )
                {
                    //elena.preteni hide MCC L1
                    query += ' AND NE__Value3__c =\'L2\' AND NE__Lov__r.Name=\'ALL\' AND NE__Lov__r.NE__Value3__c=\'L1\'';
                    //elena.preteni hide MCC L1
                }
                else if ( level == 'L3' )
                {
                    //giovanni spinelli 25/02/2019 query on l3 without l2 lookup
                    if ( String.isNotEmpty( lookupLov ) )
                    {
                        query += ' AND NE__Lov__c = \'' + lookupLov + '\'  ';
                    }
                    else
                    {
                        query += ' AND NE__Value3__c = \'' + level + '\'';
                    }
                    //giovanni spinelli 25/02/2019 query on l3 without l2 lookup
                }
                //start subtype
                if ( String.isNotEmpty( subTypeField ) )
                {
                    //NEXI-120 Marta Stempien <marta.stempien@accenture.com> 19/07/2019 Start
                    if ( OB_LOV_TYPE_ATECO.equals( type ) )
                    {
                        query += ' AND NE__Value2__c = \'S\'';
                    }
                    //NEXI-120 Marta Stempien <marta.stempien@accenture.com> 19/07/2019 Stop
                    else if ( String.isNotEmpty( subType ) )
                    {
                        query += ' AND ' + subTypeField + '=\'' + subType + '\'';
                    }
                    else
                    {
                        query += ' AND ' + subTypeField + '=\'\'';
                    }

                }
                //end subtype
                //start orderBy    
                if ( String.isNotEmpty( orderBy ) )
                {
                    query += ' ORDER BY ' + orderBy + ' ' + ascDesc;
                }
                //end orderBy  
                System.debug( 'query: ' + query );
                lovs = Database.query( query );
            }
            else
            {
                System.debug( 'input is not empty' );
                String query = 'SELECT ';

                /*  START   micol.ferrari 25/09/2018 */
                if ( !listOfFieldsToQuery.isEmpty( ) )
                {
                    for ( String s : listOfFieldsToQuery )
                    {
                        query += s + ',';
                    }
                }
                /*  END   micol.ferrari 25/09/2018 */

                query += 'NE__Type__c from NE__Lov__c where  NE__Active__c=true AND NE__Type__c=\'' + type + '\'';
                //spinelli giovanni
                if ( level == 'L1' )
                {
                    query += 'AND NE__Value3__c = \'' + level + '\'';
                }
                else if ( level == 'L2' )
                {
                    //elena.preteni 9/2/19 hide MCC L1
                    query += ' AND NE__Value3__c =\'L2\' AND NE__Lov__r.Name=\'ALL\' AND NE__Lov__r.NE__Value3__c=\'L1\'';
                    //elena.preteni 9/2/19 hide MCC L1
                }
                else if ( level == 'L3' )
                {
                    //giovanni spinelli 25/02/2019 query on l3 without l2 lookup
                    if ( String.isNotEmpty( lookupLov ) )
                    {
                        query += ' AND NE__Lov__c = \'' + lookupLov + '\'  ';
                    }
                    else
                    {
                        query += ' AND NE__Value3__c = \'' + level + '\'';
                    }
                    //giovanni spinelli 25/02/2019 query on l3 without l2 lookup
                }
                String inputToQuery = '%' + input + '%';
                query += ' AND (';
                if ( String.isEmpty( inputFieldForLike ) )
                {
                    //GIOVANNI SPINELLI 28/11/2018 - REMOVE ID FROM WHERE CONDITION
                    System.debug( 'MAP FOR WHERE CONDITION : ' + mapOfSourceFieldTargetField );
                    if ( mapOfSourceFieldTargetField.containsKey( 'NE__Lov__c' ) )
                    {
                        mapOfSourceFieldTargetField.remove( 'NE__Lov__c' );
                    }

                    for ( String s : mapOfSourceFieldTargetField.values( ) )
                    {
                        query += s + ' LIKE \'' + inputToQuery + '\' OR ';
                    }
                    query = query.removeEnd( ' OR ' );
                    query += ')';
                }
                else
                {
                    query += inputFieldForLike + ' LIKE \'' + inputToQuery + '\'';
                    query += ')';
                }
                //start subtype
                //NEXI-120 Marta Stempien <marta.stempien@accenture.com> 19/07/2019 Start
                if ( OB_LOV_TYPE_ATECO.equals( type ) )
                {
                    query += ' AND NE__Value2__c = \'S\'';
                }
                //NEXI-120 Marta Stempien <marta.stempien@accenture.com> 19/07/2019 Stop
                else if ( String.isNotEmpty( subType ) )
                {
                    query += ' AND ' + subTypeField + '=\'' + subType + '\'';
                }
                //end subtype
                //start orderBy
                if ( String.isNotEmpty( orderBy ) )
                {
                    query += ' ORDER BY ' + orderBy + ' ' + ascDesc;
                }
                //end orderBy  
                System.debug( '@@@@ query: ' + query );
                lovs = Database.query( query );
                System.debug( 'lovs: ' + lovs );
            }
        } catch ( Exception ecc )
        {
            System.debug( 'Generic Error: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
        }
        return lovs;
    }

    // DG - 29/03/19 - RP_019 - START
    // Method called for building the CAB modal in Maintenance Search cmp
    @auraEnabled
    public static List<NE__Lov__c> getCabForApproverLevelServer( String ABI, String CAB, String subType, String ABIvalue, String input )
    {
        System.debug( 'Nel controller ModalLookup' );
        System.debug( 'ABI' + ABI );
        System.debug( 'CAB' + CAB );
        System.debug( 'subType' + subType );
        System.debug( 'ABIvalue' + ABIvalue );
        String query;
        List<String> cabList = new List<String>( );
        if ( !String.isBlank( CAB ) )
        {
            if ( CAB.contains( ';' ) )
            {
                cabList.addAll( CAB.split( ';' ) );
            }
            else if ( CAB.length( ) == 5 )
            {
                cabList.add( CAB );
            }
        }

        List<NE__Lov__c> lovByCABList = new List<NE__Lov__c>( );
        List<User> users = new List<User>( );
        String tipologiche = 'Tipologiche';
        String ABIString = ABI;
        // Start antonio.vatrano 30/04/2019 r1f2-49
        User currentUser =
        [
                SELECT Id,
                        Profile.UserLicense.Name,
                        Profile.Name,
                        OB_CAB__C,
                        OB_ABI__c
                FROM User
                WHERE Id = :UserInfo.getUserId( )
                LIMIT 1
        ];
        String nameToSearch = '%' + currentUser.Profile.Name + '%';
        List <OB_ConfigurationInformation__mdt> listOfConfigurationInformations =
        [
                SELECT OB_String_Value__c,
                        OB_String_Value_2__c
                FROM OB_ConfigurationInformation__mdt
                WHERE QualifiedApiName IN('OB_MultiCABFirstStep', 'OB_multiCABbyLov', 'OB_singleCABonFirstStep')
                and OB_String_Value__c LIKE :nameToSearch
        ];
        String cabL3 = '';
        if ( !listOfConfigurationInformations.isEmpty( ) )
        {
            cabL3 = listOfConfigurationInformations.get( 0 ).OB_String_Value_2__c;
        }
        // end antonio.vatrano 30/04/2019 r1f2-49

        query = 'SELECT  Id, Name, NE__Value1__c FROM NE__Lov__c WHERE NE__Active__c = true AND NE__Type__c =: ABIString AND NE__Sub_Type__c = : subType AND NE__Value1__c = : ABIvalue';
        if ( !cabList.isEmpty( ) && cabL3 != 'LOV' )
        {  // antonio.vatrano 30/04/2019 r1f2-49 add condition
            query += ' AND Name IN : cabList';
        }
        if ( !String.isBlank( input ) )
        {
            String likeInput = '%' + input + '%';
            query += ' AND Name LIKE : likeInput';
        }
        query += ' ORDER BY Name';
        System.debug( 'query is : ' + query );
        lovByCABList = Database.query( query );
        if ( !lovByCABList.isEmpty( ) )
        {
            return lovByCABList;
        }
        else
        {
            return null;
        }
    }
    // DG - 29/03/19 - RP_019 - END

    /*******************************************************************************
    Purpose:  Method retrieves NE__Lov__c list - filtered by given params
    Parameters: String level, String lookupLov
    Returns: List<NE__Lov__c>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       06/06/2019      Created         NEXI-81-MCCmodal
    ********************************************************************************/
    @AuraEnabled
    public static List<NE__Lov__c> getLovs( String level, String lookupLov )
    {
        List<NE__LOV__c> lovsToReturn = new List<NE__Lov__c>( );
        if ( 'L2'.equalsIgnoreCase( level ) )
        {
            lovsToReturn =
            [
                    SELECT Id, Name, NE__Value2__c, OB_Value4__c
                    FROM NE__Lov__c
                    WHERE NE__Active__c = true AND NE__Type__c = 'MCC' AND Id = :lookupLov
            ];
        }
        else if ( 'L3'.equalsIgnoreCase( level ) )
        {
            lovsToReturn =
            [
                    SELECT Id, Name, NE__Value2__c
                    FROM NE__Lov__c
                    WHERE NE__Active__c = true AND NE__Type__c = 'MCC' AND NE__Lov__c = :lookupLov
            ];
        }

        return lovsToReturn;
    }

}