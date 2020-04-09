public without sharing class OB_Maintenance_Helper
{

    // NEXI-187 Marlena Lukomska-Rogala <m.lukomska-rogala@accenture.com>, 25/07/2019 START
    public static final String MODALITA_DI_LIQUIDAZIONE = 'Modalita di liquidazione';
    public static final String TIPOLOGIA_DI_RENDICONTAZIONE = 'Tipologia di rendicontazione';
    // NEXI-187 Marlena Lukomska-Rogala <m.lukomska-rogala@accenture.com>, 25/07/2019 STOP

    public class bankOwnerWrapper
    {
        public boolean errorOccurred { get; set; }
        public string errorMessage { get; set; }
        public id bankOwnerid { get; set; }
        //giovanni spinelli add proposerABI
        public id proposerABI { get; set; }
        public bankOwnerWrapper( )
        {
            this.errorOccurred = false;
            this.errorMessage = '' ;
        }
    }

    /*
    * Author : Claudio Quaranta
    * Date : 30/11/2018 
    *   Description : method that retrive the bank owner
    *   input : abi : mandatory, if filled we search for the abi inserted in input, otherwise we search for the abi connected to the current user.
    *   output : a map that contasin the object as akey, and a map of field api name- field getdescribed
    */
    public static bankOwnerWrapper retriveBankOwner( string inputAbi )
    {

        bankOwnerWrapper toReturn = new bankOwnerWrapper( );

        List<User> listOfUsers = [ SELECT Id, Profile.Userlicense.Name,OB_CAB__c, contact.account.OB_ABI__c FROM User WHERE Id = :userinfo.getuserid( ) LIMIT 1 ];

        string abiToSearch = '';
        if ( !listOfUsers.isEmpty( ) )
        {
            abiToSearch = listOfUsers.get( 0 ).Profile.Userlicense.Name == Label.OB_License_PartnerCommunity ? listOfUsers.get( 0 ).contact.account.OB_ABI__c : '';
            abiToSearch = abiToSearch == '' && inputAbi != null && inputAbi != '' ? inputAbi : abiToSearch;
        }

        System.debug( 'ABI to search: ' + abiToSearch );

        list<OB_Bank_Profile__c> listOfBankProfile =
        [
                //davide.franzini - F2WAVE2-4 17/07/2019 - terminal_id_gateway added in query
                select id, OB_Business_Model_Acquiring__c, OB_Bank__c, OB_GT__c, OB_Business_Model_POS__c,OB_Circuit__c,OB_Other_Acquirer__c, OB_Service_Type__c, OB_Apm_Circuit__c, OB_Vas__c, OB_SettlementType__c,OB_AccountHolder__c, OB_Applicant_RAC_Code_SIA__c,OB_Terminal_Id_Generator__c, OB_Terminal_Id_Gateway__c
                from OB_Bank_Profile__c
                where OB_Bank__r.OB_ABI__c = :abiToSearch
        ];
        if ( listOfBankProfile != null && !listOfBankProfile.isEmpty( ) )
        {
            OB_Bank_Profile__c bankProfile = new OB_Bank_Profile__c( );
            bankProfile = listOfBankProfile.get( 0 );
            toReturn.proposerABI = listOfBankProfile.get( 0 ).OB_Bank__c;
            if ( bankProfile.OB_Business_Model_Acquiring__c == 'Servicing' ||
                    bankProfile.OB_Business_Model_Acquiring__c == 'Associate' ||
                    bankProfile.OB_Business_Model_Acquiring__c == null )
            {
                //  RECUPERO IL MERCHANT IL CUI OB_Bank_owner__c = bankProfile.OB_Bank__c
                toReturn.bankOwnerid = bankProfile.OB_Bank__c;
            }
            else
            {
                Account nexibank =
                [
                        select id, name
                        from account
                        where OB_ABI__c = '00000' and RecordType.DeveloperName = 'Bank'
                        limit 1
                ] ;
                if ( nexibank != null )
                {

                    //RECUPERO IL MERCHANT IL CUI OB_Bank_owner__c =  nexibank.Id
                    toReturn.bankOwnerid = nexibank.id;
                }
            }
        }
        else
        {
            toReturn.errorOccurred = true;
            toReturn.errormessage = Label.OB_MAINTENANCE_NOBANKPROFILEFOUND;
        }
        return toReturn;
    }


    /*
    * Author : Claudio Quaranta
    * Date : 22/11/2018 
    *   Description : method that extract the DB schema for the list of object in input
    *   input : the list of SObject for schema estraction (E.G 'Account', 'Contact' ecc)
    *   output : a map that contasin the object as akey, and a map of field api name- field getdescribed
    */
    public String legalForm = 'OB_Legal_Form__c';

    public static Map<String, Map<String, Schema.DescribeFieldResult>> fieldObjType2APINameSchema( String objectTypeList )
    {
        return fieldObjType2APINameSchema( new list<string> {objectTypeList} );
    }

    public static Map<String, Map<String, Schema.DescribeFieldResult>> fieldObjType2APINameSchema( List<String> objectTypeList )
    {
        System.debug( logginglevel.FINE, 'UtilitySchemaAccess.fieldListFromSchema - [objectTypeList]: ' + objectTypeList );
        Map<String, Map<String, Schema.DescribeFieldResult>> sObjectToApiFieldListMap = new Map<String, Map<String, Schema.DescribeFieldResult>>( );
        Map<String, List<Schema.DescribeFieldResult>> objTypeToFieldList = fieldAPINameListFromSchema( objectTypeList );
        for ( String objectType : objTypeToFieldList.keySet( ) )
        {
            sObjectToApiFieldListMap.put( objectType, new Map<String, Schema.DescribeFieldResult>( ) );
            List<Schema.DescribeFieldResult> fieldList = objTypeToFieldList.get( objectType );
            for ( Schema.DescribeFieldResult field : fieldList )
            {
                sObjectToApiFieldListMap.get( objectType ).put( field.getName( ), field );
            }
        }
        System.debug( logginglevel.FINE, 'UtilitySchemaAccess.fieldListFromSchema - [sObjectToApiFieldListMap]: ' + sObjectToApiFieldListMap );
        return sObjectToApiFieldListMap;
    }

    /* Author : Claudio Quaranta
    * Date : 22/11/2018 
    * @description extract from an SObject type List the Map of type => field API Name list
    * @param objectTypeList => object type list for extraction
    * @return  Map<String,List<String>> containig object type to all fields API Name 
    */
    public static Map<String, List<Schema.DescribeFieldResult>> fieldAPINameListFromSchema( List<String> objectTypeList )
    {
        System.debug( logginglevel.FINE, 'UtilitySchemaAccess.fieldListFromSchema - [objectTypeList]: ' + objectTypeList );
        List<Schema.DescribeSObjectResult> descResult = Schema.describeSObjects( objectTypeList );
        Map<String, List<DescribeFieldResult>> sObjectToApiFieldListMap = new Map<String, List<Schema.DescribeFieldResult>>( );
        for ( Schema.DescribeSObjectResult currentObject : descResult )
        {
            sObjectToApiFieldListMap.putAll( fillObjectToFieldsMap( currentObject ) );
        }
        System.debug( logginglevel.FINE, 'UtilitySchemaAccess.fieldListFromSchema - [descResult]: ' + descResult );
        return sObjectToApiFieldListMap;
    }
    /* Author : Claudio Quaranta
    * Date : 22/11/2018 
    * @description extract from an SObject the fields list and bind it to the object type
    * @param currentObject => sObject info extracted from schema
    * @return  Map<String,List<String>> containig object type to all fields API Name 
    */
    public static Map<String, List<Schema.DescribeFieldResult>> fillObjectToFieldsMap( Schema.DescribeSObjectResult currentObject )
    {
        Set<Schema.DescribeFieldResult> fieldSet = new Set<Schema.DescribeFieldResult>( );
        String objectName = currentObject.getName( );
        for ( Schema.SObjectField currentField : currentObject.fields.getMap( ).values( ) )
        {
            Schema.DescribeFieldResult currentFieldAPIName = currentField.getDescribe( );
            System.debug( logginglevel.FINEST, 'UtilitySchemaAccess.fieldListFromSchema - [currentFieldAPIName]: ' + currentFieldAPIName );
            fieldSet.add( currentFieldAPIName );
        }
        return new Map<String, List<Schema.DescribeFieldResult>> {objectName => new List<Schema.DescribeFieldResult>( fieldSet )};
    }


    public class serializeObject
    {
        public list<SObject> obj;
        public serializeObject( )
        {
            this.obj = new list<SObject>( );
        }
    }

    public class CheckboxesWrapper
    {
        public Boolean changeCompanyData;
        public Boolean changeLegalForm ;
        public Boolean changeLegalRepresentative;
        public Boolean newLegalRepresentative;
        public Boolean changeMerchantName;
        public Boolean changeServicePointData;
        public Boolean changeReportType; // NEXI-179 Marta Stempiem <marta.stempien@accenture.com> 15/07/2019 Added Boolean changeRecordType
        public Boolean documentRequired;
        public Boolean isSuccess;
        public Boolean changeSPnotIntegration; //antonio.vatrano f2wave2-112 10/07/2019
        public Boolean isSettlementProcedure; // NEXI-180 Wojciech Szuba <wojciech.szuba@accenture.com> 12/07/2019, Added checkbox needed for log request
        public Boolean isNotIntegrated; // NEXI-179 Marta Stempien <marta.stempien@accenture.com> 29/07/2019 Added checkbox

        public CheckboxesWrapper( )
        {
            this.changeCompanyData = false;
            this.changeLegalForm = false;
            this.changeLegalRepresentative = false;
            this.newLegalRepresentative = false;
            this.changeMerchantName = false;
            this.changeServicePointData = false;
            this.changeReportType = false; // NEXI-179 Marta Stempiem <marta.stempien@accenture.com> 15/07/2019
            this.documentRequired = false;
            this.isSuccess = false;
            this.changeSPnotIntegration = false; //antonio.vatrano f2wave2-112 10/07/2019
            this.isSettlementProcedure = false; // NEXI-180 Wojciech Szuba <wojciech.szuba@accenture.com> 12/07/2019, Added checkbox needed for log request
            this.isNotIntegrated = false; // NEXI-179 Marta Stempien <marta.stempien@accenture.com> 29/07/2019
        }
    }


    public static final list<string> COMPANYDATAFIELDS = new list<String>
    {
            'NE__Fiscal_code__c',
            'NE__VAT__c',
            'OB_SAE_Code__c',
            'OB_ATECO__c',
            'OB_CCIAA__c',
            'OB_CCIAA_Province__c',
            'OB_Employees_Number__c', // NEXI-261 Marta Stempien <marta.stempien@accenture.com> 14/08/2019 Added field for log request
            'OB_Legal_Address_State__c',
            'OB_Legal_Address_City__c',
            'OB_Legal_Address_Detail__c',
            'OB_Legal_Address_Street__c',
            'OB_Legal_Address_Street_Number__c',
            'OB_Legal_Address_ZIP__c',
            'OB_Administrative_Office_State__c',
            'OB_Administrative_Office_City__c',
            'OB_Administrative_Office_Address_Details__c',
            'OB_Administrative_Office_Street__c',
            'OB_Administrative_Office_Street_Number__c',
            'OB_Administrative_Office_ZIP__c',
            'Phone',
            // NEXI-193 Joanna Mielczarek <joanna.mielczarek@accenture.com> START added fields
            'OB_Administrative_Office_Hamlet__c',
            'OB_Administrative_Office_Country__c',
            'OB_Administrative_Office_Country_Code__c',
            'OB_Administrative_Office_State_Code__c',
            // NEXI-193 Joanna Mielczarek <joanna.mielczarek@accenture.com> STOP
            //elena.preteni log request 10/09/2019
            'OB_ReportType__c'
            //elena.preteni log request 10/09/2019
    }; // List of API NAME fields to check to set changeCompanyData
    public static final list<string> LEGALFORMFIELDS = new list<String> {'OB_Legal_Form__c'}; // List of API NAME fields to check to set changeLegalForm
    public static final list<string> LEGALREPRESENTATIVEFIELDS = new list<String> {''}; // List of API NAME fields to check to set changeLegalRepresentative
    public static final list<string> MERCHANTNAMEFIELDS = new list<String> {'Name'}; // List of API NAME fields to check to set changeMerchantName
    // start antonio.vatrano f2wave2-112 10/07/2019
    public static final list<string> SERVICEPOINTDATAFIELDS = new list<String>
    {
            'Name',
            'NE__City__c',
            'NE__Province__c',
            'NE__Street__c',
            'OB_Break_End_Time__c',
            'OB_Break_Start_Time__c',
            'OB_Email__c',
            'OB_Ending_Time__c',
            'OB_Mobile_Phone_Number__c',
            'OB_Opening_Friday_Afternoon__c',
            'OB_Opening_Friday_Morning__c',
            'OB_Opening_Monday_Afternoon__c',
            'OB_Opening_Monday_Morning__c',
            'OB_Opening_Saturday_Afternoon__c',
            'OB_Opening_Saturday_Morning__c',
            'OB_Opening_Sunday_Afternoon__c',
            'OB_Opening_Sunday_Morning__c',
            'OB_Opening_Thursday_Afternoon__c',
            'OB_Opening_Thursday_Morning__c',
            'OB_Opening_Time__c',
            'OB_Opening_Tuesday_Afternoon__c',
            'OB_Opening_Tuesday_Morning__c',
            'OB_Opening_Wednesday_Afternoon__c',
            'OB_Opening_Wednesday_Morning__c',
            'OB_Province_Code__c',
            'OB_Street_Number__c',
            'OB_ShopSign__c',
            'OB_ReceiptCity__c',
            'OB_ReceiptHeader__c',
            'FirstName',
            'LastName',
            'MobilePhone',
            'Email',
            'OB_MCC__c',
            'OB_MCCL2__c'//,
            //francesca.ribezzi 11/09/19 OB_InternationalSettlementMethod__c deleted -> logRequest confermato
    };

    // End antonio.vatrano f2wave2-112 10/07/2019
    // NEXI-127 Marta Stempien <marta.stempien@accenture.com> 26/06/2019 - Fix for Punti Vendita Maintenance
    // NEXI-97 Marta Stempien <marta.stempien@accenture.com> 07/06/2019 'OB_SAE_Code__c', 'OB_ATECO__c' added to the list
    public static final list<string> DOCUMENTREQUIREDFIELDS = new list<String> {'Name', 'OB_Legal_Form__c', 'OB_SAE_Code__c', 'OB_ATECO__c'}; // List of API NAME fields to check to set documentRequired
    //NEXI-298 Marta Stempien <marta.stempien@accnture.com> 05/09/2019 Added OB_UtilityConstants.INTERNATIONAL_SETTLEMENT_METHOD_API_NAME to SERVICEPOINTFIELDNOTINTEGRATION list
    public static final list<string> SERVICEPOINTFIELDNOTINTEGRATION = new list<String> {'FirstName', 'LastName', 'MobilePhone', 'Email', 'OB_MCC__c', 'OB_MCCL2__c', OB_UtilityConstants.INTERNATIONAL_SETTLEMENT_METHOD_API_NAME}; // antonio.vatrano f2wave2-112 10/07/2019
    // NEXI-179 Marta Stempien <marta.stempien@accenture.com> 15/07/2019 Added list CHANGERECORDTYPE
    private static final String CHANGEREPORTTYPE = 'OB_ReportType__c';
    private static final List<String> SAE_ATECO_CHANGED = new List<String> {'OB_SAE_Code__c', 'OB_ATECO__c'};
    // NEXI-179 Marta Stempien <marta.stempien@accenture.com> 15/07/2019 Stop

    /*
    * Author : Claudio Quaranta
    * Date : 30/11/2018
    *   Description : method that check if field in input is contained into the list of field to check .
    *   input : fieldName : API name fields,
                checkboxFields : Object where set the checkbox
    *   output : N/A , the checkboxFields is modified
    */
    /*******************************************************************************
    Purpose:  Method set appropriate boolean fields of Log Request for Service Point changes
    Parameters: String fieldName, CheckboxesWrapper checkboxFields
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Claudio Quaranta      30/11/2018        Created         Method that check if field in input is contained into the list of field to check
    1.1         Marta Stempien        26/07/2019        Modified       NEXI-179 Deleted conditions for checkboxes related to Edit Account
    ********************************************************************************/
    public static void checkBoleanFields( string fieldName, CheckboxesWrapper checkboxFields )
    {
        if ( LEGALFORMFIELDS.contains( fieldName ) )
        {
            checkboxFields.changeLegalForm = true;
        }
        if ( LEGALREPRESENTATIVEFIELDS.contains( fieldName ) )
        {
            checkboxFields.changeLegalRepresentative = true;
        }
        if ( SERVICEPOINTDATAFIELDS.contains( fieldName ) )
        {
            checkboxFields.changeServicePointData = true;
        }
        //Start antonio.vatrano wn-250 27/08/2019
        if ( SERVICEPOINTFIELDNOTINTEGRATION.contains( fieldName ) )
        {
            checkboxFields.changeSPnotIntegration = true;
        }
        //End antonio.vatrano wn-250 27/08/2019
    }

    /*******************************************************************************
   Purpose:  Method that check if a log request already exits
   Parameters: List<String> oldData, List<String> newData, String objectDataMap
   Returns: List<Map<String, Object>>

   History
   --------
   VERSION     AUTHOR                  DATE            DETAIL          Description
   1.0         Marta Stempien        26/07/2019        Created         NEXI-179
   1.1         Marta Stempien        06/09/2019        Modified        NEXI-298 Added check for Settlement Procedure
   ********************************************************************************/
    private static void checkBooleanFieldsAccount( String fieldName, CheckboxesWrapper checkboxFields )
    {
        if ( COMPANYDATAFIELDS.contains( fieldName ) )
        {
            checkboxFields.changeCompanyData = true;
            //NEXI-179 Marta Stempien <marta.stempien@accenture.com> 29/07/2019 Start
            if ( SAE_ATECO_CHANGED.contains( fieldName ) )
            {
                checkboxFields.isNotIntegrated = true;
            }
            //NEXI-179 Marta Stempien <marta.stempien@accenture.com> 29/07/2019 Stop
        }
        if ( LEGALFORMFIELDS.contains( fieldName ) )
        {
            checkboxFields.changeLegalForm = true;
        }
        if ( LEGALREPRESENTATIVEFIELDS.contains( fieldName ) )
        {
            checkboxFields.changeLegalRepresentative = true;
        }
        if ( MERCHANTNAMEFIELDS.contains( fieldName ) )
        {
            checkboxFields.changeMerchantName = true;
        }
        if ( DOCUMENTREQUIREDFIELDS.contains( fieldName ) )
        {
            checkboxFields.documentRequired = true;
        }
        // NEXI-298 Marta Stempien <marta.stempien@accenture.com> 09/09/2019 Start
        if (OB_UtilityConstants.INTERNATIONAL_SETTLEMENT_METHOD_API_NAME.equalsIgnoreCase(fieldName))
        {
            checkboxFields.isSettlementProcedure = true;
        }
        // NEXI-298 Marta Stempien <marta.stempien@accenture.com> 09/09/2019 Stop
    }

    /*
    * Author : Claudio Quaranta
    * Date : 22/11/2018
    *   Description : method that return a list of JSobject name, retriving it for the generic SObject received in input
    *   input : listOfData --> list of SObject
    *   output : set<string> the set that contains all the SObject Types( E.G Account, Contact, NE__Produt__c... )
    */
    public static set<string> getSetOfObjectType( list<SObject> listOfData )
    {
        system.debug( 'listOfData --> ' + listOfData );
        set<string> listofString = new set<String>( );
        for ( SObject s : listOfData )
        {
            system.debug( 'SObject --> ' + s );
            //giovanni spinelli - add if condition
            if ( s != null )
                listofString.add( s.getSObjectType( ).getDescribe( ).getName( ) );
        }
        return listofString;
    }
    /* Author : Claudio Quaranta
    * Date : 22/11/2018
    * Description : method that return a list of JSobject name, retriving it for the generic SObject map received in input.
    *changelog : 28/11/2018 the method was moved into the one that receiv a list in input. this one was adapet as overloading of the new one
    */
    public static set<string> getSetOfObjectType( map<SObject, SObject> mapOldDataNewData )
    {
        /*set<string> listofString = new set<String>();
        for( SObject s : mapOldDataNewData.keyset())
            listofString.add( s.getSObjectType().getDescribe().getName());
        return listofString;*/
        return getSetOfObjectType( new list<SObject> ( mapOldDataNewData.keyset( ) ) );
    }

    /*
    * Author : Claudio Quaranta
    * Date : 22/11/2018
    *   Description : method that generate a object that contains olly the modified data.
    *   input :
    *   output : N/A
    */
    public static final Map<String, list<String>> fieldToSkip = new map <String, list<String>>
    {
            'Account' => new List<String> {'Createddate', 'Id'},
            'Contact' => new List<String> {'Createddate', 'Id'}
    };


    /*******************************************************************************
    Purpose:  Compare all the object contained into mapOldDataNewData producing a JSON stat contains only the field changed.
    Parameters: map<SObject,SObject> mapOldDataNewData : map that contains the old object as a key, and the modifed objet as a value
                serializeObject reducedOldData : list<SOJect> list of old object reduced , it is populated into - this is an output parameter
                serializeObject reducedNewData : list<SOJect> list of new bject reduced , it is populated into  - this is an output parameter
                checkboxFields : internal wrpapper that contains the checkbox to populate into log request data.
    Returns: void

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Claudio Quaranta      06/12/2018        Created         Compare all the object contained into mapOldDataNewData producing a JSON stat contains only the field changed.
    1.1         Grzegorz Banach       06/12/2018        Modified        NEXI-261 refactored and fixed part of logic of NEXI-187 and NEXI-180
    *******************************************************************************/

    public static void generateDifferenceObject( map<SObject, SObject> mapOldDataNewData, serializeObject reducedOldData, serializeObject reducedNewData, CheckboxesWrapper checkboxFields )
    {

        try
        {
            list<string> listSObjectType = new list<string>( );
            // Estract list of involved types
            System.debug( 'mapOldDataNewData -->' + mapOldDataNewData );
            System.debug( 'mapOldDataNewData keyset-->' + mapOldDataNewData.keyset( ) );
            listSObjectType.addall( getSetOfObjectType( mapOldDataNewData ) ) ;
            System.debug( 'listSObjectType --> ' + listSObjectType );
            // estracting the schema definition
            map<String, Map<String, Schema.DescribeFieldResult>> schemaDB = OB_Maintenance_Helper.fieldObjType2APINameSchema( listSObjectType );
            // looping for all old data
            // NEXI-180, Wojciech Szuba, <wojciech.szuba@accenture.com>, 23/07/2019, START
            OB_Mandatory_Fields_for_Log_Request__mdt[] mandatoryFieldsForLogRequest =
            [
                    SELECT OB_FieldName__c, OB_FieldSetName__c
                    FROM OB_Mandatory_Fields_for_Log_Request__mdt
                    WHERE OB_FieldSetName__c = :MODALITA_DI_LIQUIDAZIONE    // NEXI-187 Marlena Lukomska-Rogala <m.lukomska-rogala@accenture.com>, 25/07/2019
                    OR OB_FieldSetName__c = :TIPOLOGIA_DI_RENDICONTAZIONE   // NEXI-187 Marlena Lukomska-Rogala <m.lukomska-rogala@accenture.com>, 25/07/2019
            ];
            List<String> exceptionalFields = new List<String>( );
            // NEXI-187 Marlena Lukomska-Rogala <m.lukomska-rogala@accenture.com>, 25/07/2019 START
            List<String> modalitaExceptionalFields = new List<String>( );
            List<String> tipologiaExceptionalFields = new List<String>( );
            // NEXI-187 Marlena Lukomska-Rogala <m.lukomska-rogala@accenture.com>, 25/07/2019 STOP
            for ( OB_Mandatory_Fields_for_Log_Request__mdt mandatoryField : mandatoryFieldsForLogRequest )
            {
                // NEXI-187 Marlena Lukomska-Rogala <m.lukomska-rogala@accenture.com>, 25/07/2019 START
                if ( MODALITA_DI_LIQUIDAZIONE.equalsIgnoreCase( mandatoryField.OB_FieldSetName__c ) )
                {
                    modalitaExceptionalFields.add( mandatoryField.OB_FieldName__c );
                }
                else if ( TIPOLOGIA_DI_RENDICONTAZIONE.equalsIgnoreCase( mandatoryField.OB_FieldSetName__c ) )
                {
                    tipologiaExceptionalFields.add( mandatoryField.OB_FieldName__c );
                }
                // NEXI-187 Marlena Lukomska-Rogala <m.lukomska-rogala@accenture.com>, 25/07/2019 STOP
            }
            // NEXI-180, Wojciech Szuba, <wojciech.szuba@accenture.com>, 23/07/2019, STOP
            for ( SObject oldData : mapOldDataNewData.keyset( ) )
            {
                // retrive the  current Object type
                string currentObjectType = oldData.getSObjectType( ).getDescribe( ).getName( );

                // inizializating new Object, one for old data, one for new data
                SOBject oldReducedObject = ( SObject ) Schema.getGlobalDescribe( ).get( currentObjectType ).newSObject( );
                SOBject newReducedObject = ( SObject ) Schema.getGlobalDescribe( ).get( currentObjectType ).newSObject( );
                // retriving all fields for the current SObject
                Map<String, Schema.DescribeFieldResult> mapofFields = schemaDB.get( currentObjectType );

                SObject newData = mapOldDataNewData.get( oldData );
                System.debug( 'newData 1: ' + newData );
                boolean objectPopulated = false;
                // NEXI-180 Wojciech Szuba <wojciech.szuba@accenture.com> 12/07/2019, START
                for ( String field : mapofFields.keySet( ) )
                {
                    if ( oldData.get( field ) != newData.get( field ) && OB_UtilityConstants.INTERNATIONAL_SETTLEMENT_METHOD_API_NAME.equalsIgnoreCase( field ) )
                    {
                        checkboxFields.isSettlementProcedure = true;
                        exceptionalFields.addAll( modalitaExceptionalFields ); //NEXI-187 Marlena Lukomska-Rogala <m.lukomska-rogala@accenture.com>, 25/07/2019
                        break;
                    }
                    // NEXI-180 Wojciech Szuba <wojciech.szuba@accenture.com> 12/07/2019, STOP
                    // NEXI-187 Grzegorz Banach <grzegorz.banach@accenture.com> 22/07/2019, START
                    if ( CHANGEREPORTTYPE.equalsIgnoreCase( field ) && oldData.get( field ) != newData.get( field ) )
                    {
                        checkboxFields.changeReportType = true;
                        checkboxFields.isNotIntegrated = true; //NEXI-298 Marta Stempien <marta.stempien@accenture.com> )5/09/2019 Check isNotIntegrated for rendicondazione
                        exceptionalFields.addAll( tipologiaExceptionalFields );
                        break;
                    }
                    // NEXI-187 Grzegorz Banach <grzegorz.banach@accenture.com> 22/07/2019, STOP
                }

                Boolean isAtLeastOneChangeInObject = false;//NEXI-187 Grzegorz Banach <grzegorz.banach@accenture.com> 22/07/2019

                for ( String field : mapofFields.keySet( ) )
                {
                    System.debug( 'FIELD: ' + field );
                    //NEXI-187 Grzegorz Banach <grzegorz.banach@accenture.com> 22/07/2019 START
                    Boolean fieldValuesAreDifferent = ( !( String.isBlank( String.valueOf( oldData.get( field ) ) ) && String.isBlank( String.valueOf( newData.get( field ) ) ) ) &&
                            oldData.get( field ) != newData.get( field ) ); // NEXI-179 Marta Stempien <marta.stempien@accenture.com> 22/07/2019 Added check for blank strings
                    if ( ( 'Description'.equalsIgnoreCase( field ) ) && ( oldData.getSObjectType( ) == Schema.Contact.SObjectType ) )
                    {
                        continue; //fix for 'referenti' and other scenarios - for more info please check NEXI-130
                    }
                    if ( fieldValuesAreDifferent ) //NEXI-187 Grzegorz Banach <grzegorz.banach@accenture.com> 22/07/2019 STOP
                    {
                        // C.Q added to populate boolean fields
                        //NEXI-179 Marta Stempien <marta.stempien@accenture.com> 31/07/2019 Start
                        if ( OB_UtilityConstants.SOBJECT_ACCOUNT.equalsIgnoreCase( currentObjectType ) )
                        {
                            checkBooleanFieldsAccount( field, checkboxFields );
                        }
                        else
                        {
                            checkBoleanFields( field, checkboxFields );
                        }
                        //NEXI-179 Marta Stempien <marta.stempien@accenture.com> 31/07/2019 Stop
                        oldReducedObject.put( field, oldData.get( field ) );
                        newReducedObject.put( field, newData.get( field ) );
                        objectPopulated = true;
                    }
                }
                // if we find some difference, put into the object the related id
                System.debug( 'objectPopulated: ' + objectPopulated );
                if ( objectPopulated )
                {
                    //NEXI-261 Grzegorz Banach <grzegorz.banach@accenture.com> 14/08/2018 START
                    for ( String singleField : exceptionalFields )
                    {
                        if ( mapofFields.containsKey( singleField ) && ( checkboxFields.isSettlementProcedure || checkboxFields.changeReportType ) ) // NEXI-298 Marta Stempien <marta.stempien@accenture.com> 09/09/2019 Fix for &&
                        {
                            oldReducedObject.put( singleField, oldData.get( singleField ) );
                            newReducedObject.put( singleField, newData.get( singleField ) );
                        }
                    }
                    //NEXI-261 Grzegorz Banach <grzegorz.banach@accenture.com> 14/08/2018 STOP
                    System.debug( 'IF METHOD' );
                    System.debug( 'OLD DATA: ' + oldData );
                    System.debug( 'NEW DATA: ' + newData );

                    System.debug( 'OLD DATA ID: ' + oldData.get( 'Id' ) );
                    System.debug( 'is blank? : ' + String.isBlank( ( String ) oldData.get( 'Id' ) ) );
                    //giovanni spinelli - 02/01/2019 - do not add Id if it is null
                    if ( String.isNotBlank( ( String ) oldData.get( 'Id' ) ) )
                    {
                        System.debug( 'IF METHOD PUSH' );
                        oldReducedObject.put( 'Id', oldData.get( 'Id' ) );
                    }

                    newReducedObject.put( 'Id', newData.get( 'Id' ) );
                    reducedOldData.obj.add( oldReducedObject );
                    reducedNewData.obj.add( newReducedObject );
                    checkboxFields.isSuccess = true;
                }
                system.debug( 'oldReducedObject: ' + oldReducedObject );
                system.debug( 'newReducedObject: ' + newReducedObject );
            }
        } catch ( Exception ecc )
        {
            System.debug( 'Generic Error: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
        }

    }

    /*
    * Author : Claudio Quaranta
    * Date : 22/11/2018
    * Description : method that extract the field schema and return a map of <objectAPIName,objectLabel>
    * input : a map <fieldAPiName, fieldgetDescribe
    * output : a map that contasin the <FieldObjectApiname, fieldLab>
    */
    public static map<string, string> estractFieldsLabel( Map<String, Schema.DescribeFieldResult> objType2fieldData )
    {
        map<string, string> toReturn = new map<string, string> ( );
        for ( string fieldApiNAme : objType2fieldData.keySet( ) )
            toReturn.put( fieldApiNAme, objType2fieldData.get( fieldApiNAme ).getlabel( ) );
        return toReturn;
    }


    /*
    * Author : Claudio Quaranta
    * Date : 28/11/2018
    * Description : Method used to verify is the current user is a partner community user
    * Input : N/A
    * Output : Boolean : false : the user a partner community user , true : is a internal user
    */
    public static boolean isInternalUSer( )
    {
        boolean toReturn = false;
        string ProfileId = UserInfo.getProfileId( );
        try
        {
            Profile p = [ select id,UserLicense.name from Profile where id = :ProfileId limit 1 ];
            system.debug( Logginglevel.info, 'isInternalUSer - profile name  retrived is ' + p.UserLicense.name ) ;
            toReturn = Label.OB_License_PartnerCommunity.equalsignorecase( p.UserLicense.name ) ? false : true ;

        } catch ( Exception e )
        {
            system.debug( LoggingLevel.ERROR, 'Exception in OB_MaintenanceSearch_Controller : ' + e.getmessage( ) + ' at line : ' + e.getlinenumber( ) );
        }
        system.debug( LoggingLevel.INFO, 'OB_MaintenanceSearch_Controller - isInternalUSer toReturn is ' + toReturn );
        return toReturn;
    }


    /*
    * Author : Claudio Quaranta
    * Date : 30/11/2018
    * Description : Method used to estract a list of key fields
    *   Input : listOfObject to estract
                keyField  : API name of field to estract
    *   Output : Boolean : false : the user a partner community user , true : is a internal user
    */
    public static list<id> retriveListOfId( list<SObject> listOfObject )
    {
        list<id> listOfid = new list<id>( );
        for ( SOBject s : listOfObject )
        {
            listOfid.add( ( id ) s.get( 'Id' ) );
        }
        return listOfid;
    }

    /*******************************************************************************
    Purpose:  Method that check if a log request already exits
    Parameters: List<String> oldData, List<String> newData, String objectDataMap
    Returns: List<Map<String, Object>>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Claudio Quaranta      06/12/2018        Created             ?
    1.1             ?                 06/12/2018        Modified       Moved from OB_Maintenance_EditAccount_Controller
    1.2             ?                 06/12/2018        Modified       Changed where condition, wher status != confirmed and status != rejected
    2.0         Elena Preteni         06/05/2019        Modified       Change signature from Object LOG Request to Map<String,String> sourceMap
    3.0         Marta Stempien        26/07/2019        Modified       NEXI-179 Modify method to handles type of Log Requests that can have many checkboxes checked in various combinations
    3.1         Marta Stempien        02/09/2019        Modified       NEXI-273 Refactor of method
    ********************************************************************************/
    public static Map<String, String> CheckRequestAlreadyExist( Map<String, String> sourceMap )
    {
        // END elena.preteni 6/5/2019 change signature from Object LOG Request to Map<String,String> sourceMap
        //  micol.ferrari 19/12/2018 - CHANGED RETURN TYPE - MAIN_23_R1F1
        Map<String, String> toReturn = new Map<String, String>( );
        toReturn.put( 'RECORDFOUND', 'false' );
        toReturn.put( 'LOGNAME', null );
        // NEXI-179 Marta Stempien <marta.stempien@accenture.com> 26/07/2019 Start
        Boolean changeOfReportType = !String.isEmpty( sourceMap.get( 'OB_change_of_reporting_type__c' ) ) ? Boolean.valueOf( sourceMap.get( 'OB_change_of_reporting_type__c' ) ) : false;
        Boolean changeOfCompanyData = !String.isEmpty( sourceMap.get( 'OB_ChangeCompanyData__c' ) ) ? Boolean.valueOf( sourceMap.get( 'OB_ChangeCompanyData__c' ) ) : false;
        Boolean changeOfMerchantName = !String.isEmpty( sourceMap.get( 'OB_ChangeMerchantName__c' ) ) ? Boolean.valueOf( sourceMap.get( 'OB_ChangeMerchantName__c' ) ) : false;
        Boolean changeOfLegalForm = !String.isEmpty( sourceMap.get( 'OB_ChangeLegalForm__c' ) ) ? Boolean.valueOf( sourceMap.get( 'OB_ChangeLegalForm__c' ) ) : false;
        // NEXI-298 Marta Stempien <marta.stempien@accenture.com> 09/09/2019 Start
        Boolean changeOfLegalRepresentative = !String.isEmpty( sourceMap.get( 'OB_ChangeLegalRepresentative__c' ) ) ? Boolean.valueOf( sourceMap.get( 'OB_ChangeLegalRepresentative__c' ) ) : false;
        Boolean newLegalRepresentative = !String.isEmpty( sourceMap.get( 'OB_NewLegalRepresentative__c' ) ) ? Boolean.valueOf( sourceMap.get( 'OB_NewLegalRepresentative__c' ) ) : false;
        // NEXI-298 Marta Stempien <marta.stempien@accenture.com> 09/09/2019 Stop
        //     if ( !logRequests.isEmpty( ) )
        //     {
        //         toReturn.put( 'RECORDFOUND', 'true' );
        //         toReturn.put( 'LOGNAME', logRequests.get( 0 ).Name );
        //         toReturn.put( 'message', System.label.OB_MAINTENANCE_LOGALREADYEXIST + ' ' + logRequests.get( 0 ).Name );
        //         return toReturn;
        //     }
        // }
        // if ( changeOfCompanyData )
        // {
        // List<OB_LogRequest__c> logRequests =
        // [
        //         SELECT Id, Name
        //         FROM OB_LogRequest__c
        //         WHERE OB_AccountId__c = :sourceMap.get( 'OB_AccountId__c' )
        //             AND OB_ChangeCompanyData__c = true
        //             AND OB_isNotIntegrated__c = :Boolean.valueOf( sourceMap.get( 'OB_isNotIntegrated__c' ) )
        //             AND OB_Status__c != :System.Label.OB_MAINTENANCE_LOGREQUEST_STATUS_CONFIRMED
        //             AND OB_Status__c != :System.Label.OB_MAINTENANCE_LOGREQUEST_STATUS_REJECTED
        //             LIMIT 1
        //     ];
        //     if ( !logRequests.isEmpty( ) )
        //     {
        //         toReturn.put( 'RECORDFOUND', 'true' );
        //         toReturn.put( 'LOGNAME', logRequests.get( 0 ).Name );
        //         toReturn.put( 'message', System.label.OB_MAINTENANCE_LOGALREADYEXIST + ' ' + logRequests.get( 0 ).Name );
        //         return toReturn;
        //     }
        // }
        // if ( changeOfMerchantName )
        // {
        //     List<OB_LogRequest__c> logRequests =
        //     [
        //             SELECT Id, Name
        //             FROM OB_LogRequest__c
        //             WHERE OB_AccountId__c = :sourceMap.get( 'OB_AccountId__c' )
        //             AND OB_ChangeMerchantName__c = true
        //             AND OB_Status__c != :System.Label.OB_MAINTENANCE_LOGREQUEST_STATUS_CONFIRMED
        //             AND OB_Status__c != :System.Label.OB_MAINTENANCE_LOGREQUEST_STATUS_REJECTED
        //             LIMIT 1
        //     ];
        //     if ( !logRequests.isEmpty( ) )
        //     {
        //         toReturn.put( 'RECORDFOUND', 'true' );
        //         toReturn.put( 'LOGNAME', logRequests.get( 0 ).Name );
        //         toReturn.put( 'message', System.label.OB_MAINTENANCE_LOGALREADYEXIST + ' ' + logRequests.get( 0 ).Name );
        //         return toReturn;
        //     }
        // }
        // if ( changeOfLegalForm )
        // {
        //     List<OB_LogRequest__c> logRequests =
        //     [
        //             SELECT Id, Name
        //             FROM OB_LogRequest__c
        //             WHERE OB_AccountId__c = :sourceMap.get( 'OB_AccountId__c' )
        //             AND OB_ChangeLegalForm__c = true
        //             AND OB_Status__c != :System.Label.OB_MAINTENANCE_LOGREQUEST_STATUS_CONFIRMED
        //             AND OB_Status__c != :System.Label.OB_MAINTENANCE_LOGREQUEST_STATUS_REJECTED
        //             LIMIT 1
        //     ];
        //     if ( !logRequests.isEmpty( ) )
        //     {
        //         toReturn.put( 'RECORDFOUND', 'true' );
        //         toReturn.put( 'LOGNAME', logRequests.get( 0 ).Name );
        //         toReturn.put( 'message', System.label.OB_MAINTENANCE_LOGALREADYEXIST + ': ' + logRequests.get( 0 ).Name );
        //         return toReturn;
        //     }
        // }
        // NEXI-298 Marta Stempien <marta.stempien@accenture.com> 09/09/2019 Start
        //START - elena.preteni 10/09/2019 log request checks
        system.debug('changeOfLegalRepresentative'+changeOfLegalRepresentative+'newLegalRepresentative'+newLegalRepresentative+'changeOfCompanyData'+changeOfCompanyData);
        if( changeOfCompanyData )
        {
            List<OB_LogRequest__c> logRequests =
            [
                    SELECT Id, Name
                    FROM OB_LogRequest__c
                    WHERE OB_AccountId__c = :sourceMap.get( 'OB_AccountId__c' )
                    AND OB_ChangeCompanyData__c = :changeOfCompanyData
                    AND OB_Status__c != :System.Label.OB_MAINTENANCE_LOGREQUEST_STATUS_CONFIRMED
                    AND OB_Status__c != :System.Label.OB_MAINTENANCE_LOGREQUEST_STATUS_REJECTED

            ];
            if ( !logRequests.isEmpty( ) )
            {
                toReturn.put( 'RECORDFOUND', 'true' );
                toReturn.put( 'LOGNAME', logRequests.get( 0 ).Name );
                toReturn.put( 'message', System.label.OB_MAINTENANCE_LOGALREADYEXIST + ' ' + logRequests.get( 0 ).Name );
                // return toReturn;
            }
        }
        if(changeOfLegalRepresentative || newLegalRepresentative){
            List<OB_LogRequest__c> logRequests =
            [
                    SELECT Id, Name
                    FROM OB_LogRequest__c
                    WHERE OB_AccountId__c = :sourceMap.get( 'OB_AccountId__c' )
                    AND OB_NewLegalRepresentative__c = :newLegalRepresentative
                    AND OB_ChangeLegalRepresentative__c = : changeOfLegalRepresentative
                    AND OB_Status__c != :System.Label.OB_MAINTENANCE_LOGREQUEST_STATUS_CONFIRMED
                    AND OB_Status__c != :System.Label.OB_MAINTENANCE_LOGREQUEST_STATUS_REJECTED

            ];
            if ( !logRequests.isEmpty( ) )
            {
                toReturn.put( 'RECORDFOUND', 'true' );
                toReturn.put( 'LOGNAME', logRequests.get( 0 ).Name );
                toReturn.put( 'message', System.label.OB_MAINTENANCE_LOGALREADYEXIST + ' ' + logRequests.get( 0 ).Name );
                // return toReturn;
            }
        }
        //END - elena.preteni 10/09/2019 log request checks
        // NEXI-298 Marta Stempien <marta.stempien@accenture.com> 09/09/2019 Stop
        // NEXI-179 Marta Stempien <marta.stempien@accenture.com> 26/07/2019 Stop
        return toReturn;
    }

    /*******************************************************************************
    Purpose:  Method that check if a log request already exits
    Parameters: List<String> oldData, List<String> newData, String objectDataMap
    Returns: List<Map<String, Object>>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Micol Ferrari         21/12/2018        Created             ?
    1.1         Salvatore Pianura     06/12/2018        Modified       Change method to accept Map<String,String>
    2.0         Marta Stempien        03/09/2019        Modified         NEXI-294
    ********************************************************************************/
    public static Map<String, String> checkRequestAlreadyExist_ServicePoint( Map<String, String> tmpMap )
    {
        //  micol.ferrari 19/12/2018 - CHANGED RETURN TYPE - MAIN_23_R1F1
        Map<String, String> toReturn = new Map<String, String>( );
        toReturn.put( 'RECORDFOUND', 'false' );
        toReturn.put( 'LOGNAME', null );
        system.debug( logginglevel.info, 'logrequest is ' + tmpMap );
        Boolean changeSettlementMethod = !String.isEmpty( tmpMap.get( 'OB_Settlement_Procedure__c' ) ) ? Boolean.valueOf( tmpMap.get( 'OB_Settlement_Procedure__c' ) ) : false;
        Boolean changeServicePoint = !String.isEmpty( tmpMap.get( 'OB_ChangeServicePointData__c' ) ) ? Boolean.valueOf( tmpMap.get( 'OB_ChangeServicePointData__c' ) ) : false;
        //START elena.preteni 11/09/19 - query on logrequest
        List<OB_LogRequest__c> requests =
        [
                SELECT Id,Name
                FROM OB_LogRequest__c
                WHERE OB_AccountId__c = :tmpMap.get( 'OB_AccountId__c' )
                AND OB_ServicePointId__c = :tmpMap.get( 'OB_ServicePointId__c' )
                AND OB_ChangeServicePointData__c = :changeServicePoint
                AND OB_Status__c != :System.Label.OB_MAINTENANCE_LOGREQUEST_STATUS_CONFIRMED
                AND OB_Status__c != :System.Label.OB_MAINTENANCE_LOGREQUEST_STATUS_REJECTED
                LIMIT 1
        ];
        if ( !requests.isEmpty( ) )
        {
            //END elena.preteni 11/09/19
            toReturn.put( 'RECORDFOUND', 'true' );
            toReturn.put( 'LOGNAME', requests.get( 0 ).Name );
            toReturn.put( 'message', System.label.OB_MAINTENANCE_LOGALREADYEXIST + ' ' + requests.get( 0 ).Name );
        }
        return toReturn;
    }
    //  END   micol.ferrari 21/12/2018
    //END - 2019/05/06 - salvatore.pianura - Change method to accept Map<String,String>
    //giovanni spinelli - 10/01/2019 - start - utility method to get current user
    @auraEnabled
    public List<User> getCurrentUser( )
    {
        String valueAbi;
        List<User> listOfUsers = [ SELECT Id, Profile.Userlicense.Name,OB_CAB__c, contact.account.OB_ABI__c, OB_ABI__c FROM User WHERE Id = :userinfo.getuserid( ) LIMIT 1 ];

        return listOfUsers;
    }
    //giovanni spinelli - 10/01/2019 - end - utility method to get current user

    /*******************************************************************************
    Purpose:  Method updates log request statuses
    Parameters: String inLogRequestId, String inStatus
    Returns: -
    Throwable: Use it only inside try catch

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien          07/09/2019      Created         NEXI-298
    ********************************************************************************/
    public static void updateLogRequestStatus( List<String> inLogRequestsIds, String inStatus )
    {
        List<OB_LogRequest__c> logRequestsToUpdate = [SELECT Id FROM OB_LogRequest__c WHERE Id IN :inLogRequestsIds];
        for(OB_LogRequest__c loopLogRequest : logRequestsToUpdate)
        {
            loopLogRequest.OB_Status__c = inStatus;
        }

        update logRequestsToUpdate;
    }
}