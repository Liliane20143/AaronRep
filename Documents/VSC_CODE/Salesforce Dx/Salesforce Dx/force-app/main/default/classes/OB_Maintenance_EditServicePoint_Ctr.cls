public without sharing class OB_Maintenance_EditServicePoint_Ctr
{
    // NEXI-173 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 09/07/2019 START
    public static final String VISA_MASTERCARD = 'VISAMASTERCARD';
    public static final String ASSET_MONETICA = 'MONETICA';
    // NEXI-173 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 09/07/2019 STOP
    // NEXI-187 Zuzanna Urban <z.urban@accenture.com>, 26/07/2019 START
    public static final String TRUE_VALUE = 'true';
    public static final String FALSE_VALUE = 'false';
    // NEXI-187 Zuzanna Urban <z.urban@accenture.com>, 26/07/2019 STOP

    public static final String CODICE_SFDC_ALB_AUTO = 'ALB_AUTO'; // NEXI-209  Joanna Mielczarek <joanna.mielczarek@accenture.com>, 15/07/2019
    // NEXI-225  Joanna Mielczarek <joanna.mielczarek@accenture.com>, 19/07/2019 START
    public static final Id ASSET_RT_VAS = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.PRODUCT_RECORDTYPE_VAS ).getRecordTypeId( );
    public static final Id ASSET_RT_POS = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.POS_RT ).getRecordTypeId( );
    public static final Id PRODUCT_RT_POS = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.POS_RT ).getRecordTypeId( );
    // NEXI-225  Joanna Mielczarek <joanna.mielczarek@accenture.com>, 19/07/2019 STOP
    public static final Id PRODUCT_RT_VAS = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.PRODUCT_RECORDTYPE_VAS ).getRecordTypeId( ); // antonio.vatrano wn-122 25/07/2019

    public static final String ASSET_NAME_VISA_MASTERCARD = 'Visa/Mastercard';//NEXI-146 grzegorz.banach@accenture.com 04.07.2019
    // NEXI-175 Wojciech Kucharek <wojciech.kucharek@accenture.com>, 10.07/2019 START
    public static final String MCC = 'MCC';
    public static final String PO118 = 'PO118';
    // NEXI-175 Wojciech Kucharek <wojciech.kucharek@accenture.com>, 10.07/2019 STOP

    // NEXI-180 Wojciech Szuba <wojciech.szuba@accenture.com>, 11/07/2019 START
    public static final String ASSET_ESM_FIELD_RELATION = 'OB_ServicePointCodeShopCode__c';
    // NEXI-180 Wojciech Szuba <wojciech.szuba@accenture.com>, 11/07/2019 STOP  

    // NEXI-361 Grzegorz Banach <grzegorz.banach@accenture.com> 10/10/2019 START
    public static final Set<Schema.sObjectField> LOCATION_REFERENTS_COMPARE_FIELDS = new Set<Schema.sObjectField>{
            Schema.Contact.FirstName, Schema.Contact.LastName, Schema.Contact.Email, Schema.Contact.MobilePhone
    };
    // NEXI-361 Grzegorz Banach <grzegorz.banach@accenture.com> 10/10/2019 START

    public class SchemaWrapper
    {
        @AuraEnabled
        public map<string, map<string, string>> mapSObjectfields { get; set; }

        public SchemaWrapper( )
        {
            this.mapSObjectfields = new map<string, map<string, string>>( );
        }
    }

    public class ServicePointWrapper
    {
        @AuraEnabled
        public boolean errorOccurred ;
        @AuraEnabled
        public string errorMessage;
        @AuraEnabled
        public string logrequestId;
        @AuraEnabled
        public NE__Service_Point__c pv { get; set ; }
        @AuraEnabled
        public list<ExternalSourceMapping__c> listOfSourceMapping { get; set; }
        //START NEXI-105 05/06/2019 z.urban@accenture.com Add get and set to Contact
        @AuraEnabled
        public Contact administrativeResponsible { get; set ; }
        @AuraEnabled
        public Contact technicalReferent { get; set ; }
        @AuraEnabled
        public Contact servicePointResponsible { get; set ; }
        //STOP NEXI-105 05/06/2019 z.urban@accenture.com Add get and set to Contact
        //NEXI-65 Wojciech Kucharek <wojciech.kucharek@accenture.com> 13/06/2019 START
        @AuraEnabled
        public string logName;
        @AuraEnabled
        public Boolean documentRequired;
        @AuraEnabled
        public Boolean conditionMCC;
        //NEXI-65 Wojciech Kucharek <wojciech.kucharek@accenture.com> 13/06/2019 STOP
        @AuraEnabled
        public Boolean approvalProcessRequired;//NEXI-146 Grzegorz Banach <grzegorz.banach@accenture.com> 08/07/2019
        // start antonio.vatrano wn 144
        @AuraEnabled
        public Boolean isNotIntegrated;
        // End antonio.vatrano wn 144

        public ServicePointWrapper( )
        {
            this.errorOccurred = false;
            this.errorMessage = '';
            this.pv = new NE__Service_Point__c( );
            this.technicalReferent = new Contact( );
            this.servicePointResponsible = new Contact( );
            this.administrativeResponsible = new Contact( );
            this.documentRequired = false; // NEXI-65 Wojciech Kucharek <wojciech.kucharek@accenture.com> 13/06/2019
            this.conditionMCC = true; // NEXI-127 Marta Stempien <marta.stempien@accentura.com> 26/06/2019 // NEXI-166 Joanna Mielczarek <joanna.mielczarek@accenutre.com>, 12/07/2019 true as default
            this.approvalProcessRequired = false; // NEXI-146 Grzegorz Banach <grzegorz.banach@accenture.com> 08/07/2019
            this.isNotIntegrated = false;  //  antonio.vatrano wn 144
        }
    }
    // NEXI-261, Wojciech Szuba, <wojciech.szuba@accenture.com>, 12/08/2019, START
    public class MerchantAssetCheckWrapper
    {
        @AuraEnabled
        public Boolean assetCheck;
        @AuraEnabled
        public Boolean merchantCheck;

        public MerchantAssetCheckWrapper( )
        {
            this.assetCheck = false;
            this.merchantCheck = false;
        }
    }
    // NEXI-261, Wojciech Szuba, <wojciech.szuba@accenture.com>, 12/08/2019, STOP

    /*
    * Author : Claudio Quaranta
    * Date : 05/12/2018
    *	Description : method that populates the map of SOBJECT - SOBJECT that contains the old value / new value
    *	input : id of the service point to display
    *	output : a JSON that contains service data and related contact information
    *
    */
    @testVisible
    public static map<SObject, SObject> generateDiffernenceMap( ServicePointWrapper simpleOld, ServicePointWrapper simpleNew )
    {
        system.debug( 'generateDiffernenceMap simpleOld --> ' + simpleOld );
        system.debug( 'generateDiffernenceMap simpleNew --> ' + simpleNew );

        map<SObject, SObject> mapDifference = new map<SObject, SObject>( );
        mapDifference.put( simpleOld.pv, simpleNew.pv );
        // punnting the list of external sourcing into the map, when the id is the same
        if ( simpleOld.listOfSourceMapping != null && !simpleOld.listOfSourceMapping.isEmpty( ) )
        {
            for ( ExternalSourceMapping__c oldExtSource : simpleOld.listOfSourceMapping )
            {
                for ( ExternalSourceMapping__c newExtSource : simpleNew.listOfSourceMapping )
                {
                    if ( oldExtSource.id == newExtSource.id )
                    {
                        mapDifference.put( oldExtSource, newExtSource );
                    }
                }
            }
        }
        // NEXI-130 Zuzanna Urban <z.urban@accentura.com> 28/06/2019 START Referenti fix
        simpleOld.technicalReferent.Description = OB_UtilityConstants.REFERENTE_TECNICO;
        simpleOld.administrativeResponsible.Description = OB_UtilityConstants.RESPONSABILE_AMMINISTRATIVO;
        simpleOld.servicePointResponsible.Description = OB_UtilityConstants.REFERENTE_PUNTO_VENDITA;

        if ( ( simpleOld.administrativeResponsible != null || simpleNew.administrativeResponsible != null )
                && String.isNotBlank( simpleNew.administrativeResponsible.LastName ) )
        {
            System.debug( 'IF ADMIN RESP' );
            mapDifference.put( simpleOld.administrativeResponsible, simpleNew.administrativeResponsible );
            System.debug( 'MAP DIFFERENCE ADMIN RESP: ' + mapDifference );
        }

        if ( ( simpleOld.technicalReferent != null || simpleNew.technicalReferent != null )
                && String.isNotBlank( simpleNew.technicalReferent.LastName ) )
        {
            System.debug( 'IF TECH REF' );
            mapDifference.put( simpleOld.technicalReferent, simpleNew.technicalReferent );
            System.debug( 'MAP DIFFERENCE TECH REF: ' + mapDifference );
        }

        if ( ( simpleOld.servicePointResponsible != null || simpleNew.servicePointResponsible != null )
                && String.isNotBlank( simpleNew.servicePointResponsible.LastName ) )
        {
            System.debug( 'IF SP RESP' );
            mapDifference.put( simpleOld.servicePointResponsible, simpleNew.servicePointResponsible );
            System.debug( 'MAP DIFFERENCE SP RESP: ' + mapDifference );
        }
        // NEXI-130 Zuzanna Urban <z.urban@accentura.com> 28/06/2019 STOP Referenti fix

        System.debug( 'mapDifference generated --> ' + mapDifference );
        return mapDifference;
    }


    /*
    * Author : Claudio Quaranta
    * Date : 05/12/2018
    *	Description : utility method , retrive the account
    *
    */
    @testVisible
    private static string retriveAccountId( NE__Service_Point__c servicePoint )
    {
        return [ select NE__Account__c from NE__Service_Point__c where id = :servicePoint.id limit 1 ].NE__Account__c;
    }

    //NEXI-294 Marta Stempien <marta.stempien@accenture.com> 02/09/2019 Added new Exception class
    public class LogRequestExistsException extends Exception
    {
    }

    /*******************************************************************************
    Purpose:  Method calls saveRequests method for each change
    Parameters: List<String> oldData, List<String> newData, String objectDataMap
    Returns: List<Map<String, Object>>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Antonio Vatrano       18/07/2019        Created         create 2 logrequests
    1.1         Marta Stempien        02/09/2019        Modified        NEXI-287 Prevent creation of second type logRequest when first type already exist
    ********************************************************************************/

    @AuraEnabled
    public static List<ServicePointWrapper> getRequests( List<String> oldData, List<String> newData, String objectDataMap )
    {
        Savepoint sSavePoint = Database.setSavepoint( );
        List<ServicePointWrapper> requestsData = new List<ServicePointWrapper>( );
        try
        {
            //START - elena.preteni check existing log request 10/09/2019 
            if ( !oldData.isEmpty( ) && !newData.isEmpty( ) && ( !String.isEmpty( newData.get( 0 ) ) ) && ( !String.isEmpty( oldData.get( 0 ) ) ) )
            {
                checkExistence( oldData, newData );
            }
            //END - elena.preteni check existing log request 10/09/2019 
            if ( !String.isBlank( objectDataMap ) )
            {
                if ( !oldData.isEmpty( ) && !newData.isEmpty( ) && ( !String.isEmpty( newData.get( 0 ) ) ) && ( !String.isEmpty( oldData.get( 0 ) ) ) )
                {
                    requestsData.add( saveRequest( oldData.get( 0 ), newData.get( 0 ), objectDataMap ) );
                }

                if ( newData.size( ) >= 2 && !String.isEmpty( newData.get( 1 ) ) && oldData.size( ) >= 2 && !String.isEmpty( oldData.get( 1 ) )
                        && ( ( requestsData.get( 0 ) ).errorMessage == '' && ( ( requestsData.get( 0 ) ).logrequestId ) != null ) )
                {
                    requestsData.add( saveRequest( oldData.get( 1 ), newData.get( 1 ), objectDataMap ) );
                }
            }
        } catch ( LogRequestExistsException ex )
        {
            System.debug( LoggingLevel.ERROR, '[EXC] Exception ' + ex.getMessage( ) + ' stacktrace ' + ex.getStackTraceString( ) );
            Database.rollback( sSavePoint );
            ServicePointWrapper errorServicePointWrapper = new ServicePointWrapper( );
            errorServicePointWrapper.errorMessage = ex.getMessage( );
            errorServicePointWrapper.errorOccurred = true;
            requestsData.clear( );
            requestsData.add( errorServicePointWrapper );
        }
        return requestsData;
    }

    /*******************************************************************************
    Purpose:  Method calls saveRequests method for each change
    Parameters: string oldData, string newData, String flowData
    Returns: ServicePointWrapper

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Claudio Quaranta      05/12/2018        Created         Method called from a lighting component, used to save a new logrequest with the "Reduced" difference JSON
    1.1         Marta Stempien        02/09/2019        Modified        NEXI-294
    ********************************************************************************/
    @AuraEnabled
    public static ServicePointWrapper saveRequest( string oldData, string newData, String flowData ) // NEXI-127 Marta.Stempien <marta.stempien@accenture.com> 26/06/2019 Fix - revert change of method's signature
    {
        Boolean logRequestExistsException = false;
        ServicePointWrapper result = new ServicePointWrapper( );
        system.debug( 'simpleOld --> ' + oldData );
        system.debug( 'simpleNew --> ' + newData );

        //	START 	micol.ferrari 17/12/2018
        //-------------------------------------
        //	NEWDATA
        Map<String, Object> newMapGeneral = ( Map<String, Object> ) JSON.deserializeUntyped( newData );
        system.debug( 'newMapGeneral --> ' + newMapGeneral );

        //	GET PV NODE
        Map<String, Object> newPV = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( newMapGeneral.get( 'pv' ) ) );
        //NEXI-261 Grzegorz Banach <grzegorz.banach@accenture.com> 21/08/2019 START
        String accountIdOfServicePoint = ( String ) newPV.get( 'NE__Account__c' );
        String servicePointCity = ( String ) newPV.get( 'NE__City__c' );
        if ( String.isBlank( accountIdOfServicePoint ) )
        {
            return generateErrorWrapper( Label.OB_ServerLogicFailed );
        }
        List<Account> accountList =
        [
                SELECT OB_VAT_Not_Present__c,
                        OB_DescriptionVATNotPresent__c
                FROM Account
                WHERE Id = :accountIdOfServicePoint
        ];
        if ( accountList.isEmpty( ) )
        {
            return generateErrorWrapper( Label.OB_ServerLogicFailed );
        }
        Account checkedAccount = accountList.get( 0 );
        if ( checkedAccount.OB_VAT_Not_Present__c &&
                OB_UtilityConstants.LIVIGNO.equalsIgnoreCase( checkedAccount.OB_DescriptionVATNotPresent__c ) &&
                !OB_UtilityConstants.LIVIGNO.equalsIgnoreCase( servicePointCity )
                )
        {
            return generateErrorWrapper( Label.OB_LIVIGNO_CHECK_ERROR );
        }
        //NEXI-261 Grzegorz Banach <grzegorz.banach@accenture.com> 21/08/2019 STOP

        //	SAVE TIME FIELDS INTO VARIABLES
        String newOB_Opening_Time = ( String ) newPV.get( 'OB_Opening_Time__c' );
        String newOB_Break_End_Time = ( String ) newPV.get( 'OB_Break_End_Time__c' );
        String newOB_Break_Start_Time = ( String ) newPV.get( 'OB_Break_Start_Time__c' );
        String newOB_Ending_Time = ( String ) newPV.get( 'OB_Ending_Time__c' );

        //	BLANK TIME FIELDS
        newPV.put( 'OB_Opening_Time__c', null );
        newPV.put( 'OB_Break_End_Time__c', null );
        newPV.put( 'OB_Break_Start_Time__c', null );
        newPV.put( 'OB_Ending_Time__c', null );
        system.debug( 'newPV2 --> ' + newPV );

        newMapGeneral.put( 'pv', ( Object ) newPV );
        system.debug( 'mapGeneral2 --> ' + newMapGeneral );

        //	DESERIALIZE
        ServicePointWrapper simpleNew = ( ServicePointWrapper ) JSON.deserialize( JSON.serialize( newMapGeneral ), ServicePointWrapper.class );

        //	PARSETIME AND SET THE RIGHT VALUE INTO THE JSON
        simpleNew.pv.OB_Opening_Time__c = ParseTime( newOB_Opening_Time );
        simpleNew.pv.OB_Break_End_Time__c = ParseTime( newOB_Break_End_Time );
        simpleNew.pv.OB_Break_Start_Time__c = ParseTime( newOB_Break_Start_Time );
        simpleNew.pv.OB_Ending_Time__c = ParseTime( newOB_Ending_Time );

        system.debug( 'simpleNew --> ' + simpleNew );

        //-------------------------------------
        //	OLDDATA
        Map<String, Object> oldMapGeneral = ( Map<String, Object> ) JSON.deserializeUntyped( oldData );
        system.debug( 'oldMapGeneral --> ' + oldMapGeneral );

        //	GET PV NODE
        Map<String, Object> oldPV = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( oldMapGeneral.get( 'pv' ) ) );
        system.debug( 'oldPV --> ' + oldPV );

        //	SAVE TIME FIELDS INTO VARIABLES
        String oldOB_Opening_Time = ( String ) oldPV.get( 'OB_Opening_Time__c' );
        String oldOB_Break_End_Time = ( String ) oldPV.get( 'OB_Break_End_Time__c' );
        String oldOB_Break_Start_Time = ( String ) oldPV.get( 'OB_Break_Start_Time__c' );
        String oldOB_Ending_Time = ( String ) oldPV.get( 'OB_Ending_Time__c' );

        //	BLANK TIME FIELDS
        oldPV.put( 'OB_Opening_Time__c', null );
        oldPV.put( 'OB_Break_End_Time__c', null );
        oldPV.put( 'OB_Break_Start_Time__c', null );
        oldPV.put( 'OB_Ending_Time__c', null );
        system.debug( 'oldPV2 --> ' + oldPV );

        oldMapGeneral.put( 'pv', ( Object ) oldPV );
        system.debug( 'mapGeneral2 --> ' + oldMapGeneral );

        //	DESERIALIZE
        ServicePointWrapper simpleOld = ( ServicePointWrapper ) JSON.deserialize( JSON.serialize( oldMapGeneral ), ServicePointWrapper.class );

        //	PARSETIME AND SET THE RIGHT VALUE INTO THE JSON
        simpleold.pv.OB_Opening_Time__c = ParseTime( oldOB_Opening_Time );
        simpleold.pv.OB_Break_End_Time__c = ParseTime( oldOB_Break_End_Time );
        simpleold.pv.OB_Break_Start_Time__c = ParseTime( oldOB_Break_Start_Time );
        simpleold.pv.OB_Ending_Time__c = ParseTime( oldOB_Ending_Time );

        system.debug( 'simpleOld --> ' + simpleOld );
        OB_Maintenance_Helper mh = new OB_Maintenance_Helper( );
        List<User> users = mh.getCurrentUser( );
        String bank = users.get( 0 ).Profile.UserLicense.Name.equalsIgnoreCase( 'Partner Community' ) ? users.get( 0 ).contact.account.id : simpleold.servicePointResponsible.OB_Bank__c;
        System.debug( 'IF CONDITION RESP AMM: ' + ( simpleNew.administrativeResponsible != null && simpleOld.administrativeResponsible.LastName == '' ) );
        Map<String, String> tmpMap = new Map<String, String> {'OB_Change_of_location_referents__c' => FALSE_VALUE};//NEXI-187 Grzegorz Banach <grzegorz.banach@accenture.com> 16.07.2019, moved map declaration higher in code
        //NEXI-361 Grzegorz Banach <grzegorz.banach@accenture.com> 10.10.2019 START
        if ( simpleNew.servicePointResponsible != null && String.isNotBlank( simpleNew.servicePointResponsible.LastName ) &&
                (String.isBlank( simpleOld.servicePointResponsible.LastName) || existsAtLeastOneDifferenceForContact( simpleNew.servicePointResponsible, simpleOld.servicePointResponsible ) )
                )
        //NEXI-361 Grzegorz Banach <grzegorz.banach@accenture.com> 10.10.2019 STOP
        {
            System.debug( 'IF RESPONSABILE' );
            Id servicePointReferentType = Schema.SObjectType.Contact.getRecordTypeInfosByName( ).get( 'Referente Punto Vendita' ).getRecordTypeId( );
            system.debug( 'servicePointReferentType --> ' + servicePointReferentType );

            simpleNew.servicePointResponsible.RecordtypeId = servicePointReferentType;
            simpleNew.servicePointResponsible.AccountId = simpleold.pv.NE__Account__c;
            simpleNew.servicePointResponsible.OB_Bank__c = bank;
            tmpMap.put( 'OB_Change_of_location_referents__c', TRUE_VALUE );//NEXI-187  Grzegorz Banach <grzegorz.banach@accenture.com> 16.07.2019
            System.debug( 'SIMPLE NEW RESP AMM: ' + simpleNew.servicePointResponsible );
        }
        //NEXI-361 Grzegorz Banach <grzegorz.banach@accenture.com> 10.10.2019 START
        if ( simpleNew.administrativeResponsible != null && String.isNotBlank( simpleNew.administrativeResponsible.LastName ) &&
                (String.isBlank( simpleOld.administrativeResponsible.LastName) || existsAtLeastOneDifferenceForContact( simpleNew.administrativeResponsible, simpleOld.administrativeResponsible ) )
            )
        //NEXI-361 Grzegorz Banach <grzegorz.banach@accenture.com> 10.10.2019 STOP
        {
            System.debug( 'IF RESPONSABILE AMMINISTRATIVO' );
            Id administrativeResponsibleType = Schema.SObjectType.Contact.getRecordTypeInfosByName( ).get( 'Responsabile Amministrativo' ).getRecordTypeId( );
            system.debug( 'administrativeResponsibleType --> ' + administrativeResponsibleType );

            simpleNew.administrativeResponsible.RecordtypeId = administrativeResponsibleType;
            simpleNew.administrativeResponsible.AccountId = simpleold.pv.NE__Account__c;
            simpleNew.administrativeResponsible.OB_Bank__c = bank;
            tmpMap.put( 'OB_Change_of_location_referents__c', TRUE_VALUE );//NEXI-187 Grzegorz Banach <grzegorz.banach@accenture.com> 16.07.2019
            System.debug( 'SIMPLE NEW RESP AMM: ' + simpleNew.administrativeResponsible );
        }
        System.debug( 'IF CONDITION REF TEC: ' + ( simpleNew.technicalReferent != null && simpleOld.technicalReferent.LastName == '' ) );
        //NEXI-361 Grzegorz Banach <grzegorz.banach@accenture.com> 10.10.2019 START
        if ( simpleNew.technicalReferent != null && String.isNotBlank( simpleNew.technicalReferent.LastName ) &&
                (String.isBlank( simpleOld.technicalReferent.LastName) || existsAtLeastOneDifferenceForContact( simpleNew.technicalReferent, simpleOld.technicalReferent ) )
            )
        //NEXI-361 Grzegorz Banach <grzegorz.banach@accenture.com> 10.10.2019 STOP
        {
            System.debug( 'IF REFERENTE TECNICO' );
            Id technicalReferentType = Schema.SObjectType.Contact.getRecordTypeInfosByName( ).get( 'Referente Tecnico' ).getRecordTypeId( );

            simpleNew.technicalReferent.RecordtypeId = technicalReferentType;
            simpleNew.technicalReferent.AccountId = simpleold.pv.NE__Account__c;
            simpleNew.technicalReferent.OB_Bank__c = bank;
            tmpMap.put( 'OB_Change_of_location_referents__c', TRUE_VALUE );//NEXI-187 Grzegorz Banach <grzegorz.banach@accenture.com> 16.07.2019
            System.debug( 'SIMPLE NEW REF TECNICO: ' + simpleNew.technicalReferent );
        }
        System.debug( 'simpleNew after updates referents -->' + simpleNew );
        //	END 	micol.ferrari 17/12/2018

        // Setting the object differnce map
        map<SObject, SObject> mapDifference = generateDiffernenceMap( simpleOld, simpleNew );
        System.debug( 'mapDifference save request-->' + mapDifference );
        System.debug( 'simpleOld.administrativeResponsible: ' + simpleOld.administrativeResponsible.RecordTypeId );
        System.debug( 'SIMPLE OLD AFTER MAP DIFFERENCE: ' + simpleold );

        OB_Maintenance_Helper.serializeObject reducedOldData = new OB_Maintenance_Helper.serializeObject( );
        OB_Maintenance_Helper.serializeObject reducedNewData = new OB_Maintenance_Helper.serializeObject( );
        System.debug( 'reducedOldData SP: ' + JSON.serialize( reducedOldData ) );
        System.debug( 'reducedNewdData SP: ' + JSON.serialize( reducedNewData ) );
        OB_Maintenance_Helper.CheckboxesWrapper checkboxFields = new OB_Maintenance_Helper.CheckboxesWrapper( );
        OB_Maintenance_Helper.generateDifferenceObject( mapDifference, reducedOldData, reducedNewData, checkboxFields );
        // START - 2019/05/07 - salvatore.pianura - Create map to use OB_Utility.insertLogRequest() method
        System.debug( '@@@@ checkboxFields are: ' + JSON.serialize( checkboxFields ) );
        try
        {
            if ( checkboxFields.isSuccess )  // NEXI-261 Marta Stempien <marta.stempien@accenture.com> 16/08/2019 Change the entry condition
            {
                // NEXI-180 Wojciech Szuba <wojciech.szuba@accenture.com> 12/07/2019, START
                String isSettlementProcedureString = ( checkboxFields.isSettlementProcedure ) ? 'true' : 'false';
                tmpMap.put( 'OB_Settlement_Procedure__c', isSettlementProcedureString );
                // NEXI-180 Wojciech Szuba <wojciech.szuba@accenture.com> 12/07/2019, STOP
                System.debug( 'IF CHECK BOX SUCCESS' );
                String accountId = retriveAccountId( simpleOld.pv );
                tmpMap.put( 'OB_AccountId__c', accountId );
                String reducedOldDataToModify = JSON.serialize( reducedOldData );

                if ( reducedOldDataToModify.contains( 'Nuovo Referente Tecnico' ) )
                {
                    reducedOldDataToModify = reducedOldDataToModify.replaceAll( 'Nuovo Referente Tecnico', '' );
                }
                system.debug( '@# reducedOldData' + reducedOldDataToModify );
                if ( reducedOldDataToModify.contains( 'Nuovo Responsabile Punto Vendita' ) )
                {
                    reducedOldDataToModify = reducedOldDataToModify.replaceAll( 'Nuovo Responsabile Punto Vendita', '' );
                }
                system.debug( '@# reducedOldData' + reducedOldDataToModify );
                if ( reducedOldDataToModify.contains( 'Nuovo Responsabile Amministrativo' ) )
                {
                    reducedOldDataToModify = reducedOldDataToModify.replaceAll( 'Nuovo Responsabile Amministrativo', '' );
                }
                system.debug( '@# reducedOldData' + reducedOldDataToModify );
                Boolean flagSia = false;
                List<ExternalSourceMapping__c> associativeList = [ SELECT id,OB_Source__c,OB_CustomerCodeClientCode__c, OB_ServicePointCodeShopCode__c, OB_MCC__c FROM ExternalSourceMapping__c WHERE OB_Service_Point_ID__c = :simpleNew.pv.id ]; // NEXI-83 Marta Stempien <marta.stempien@accenture.com> 24/06/2019 Added OB_MCC__c to selection

                for ( ExternalSourceMapping__c esm : associativeList )
                {
                    if ( esm.OB_Source__c == ( 'SIA' ) )
                    {
                        flagSia = true;
                        break;
                    }
                }
                //START - elena.preteni change interface agreement 04/09/2019
                Map<String, ExternalSourceMapping__c> mapEsm = new Map<String, ExternalSourceMapping__c>( );
                for ( ExternalSourceMapping__c esm : associativeList )
                {
                    mapEsm.put( esm.OB_Source__c + esm.OB_CustomerCodeClientCode__c + esm.OB_ServicePointCodeShopCode__c, esm );
                }
                system.debug( 'mapEsm' + mapEsm );
                //END - elena.preteni change interface agreement 04/09/2019

                // NEXI-146 grzegorz.banach@accenture.com 09/07/2019 START
                List<ExternalSourceMapping__c> externalSourceMappingsOld = ( List<ExternalSourceMapping__c> ) JSON.deserialize( JSON.serialize( oldMapGeneral.get( 'listOfSourceMapping' ) ), List<ExternalSourceMapping__c>.class );
                // NEXI-146 grzegorz.banach@accenture.com 09/07/2019 STOP
                // NEXI-83 Marta Stempien <marta.stempien@accenture.com> 24/06/2019 - Start
                List<ExternalSourceMapping__c> externalSourceMappingsNew = ( List<ExternalSourceMapping__c> ) JSON.deserialize( JSON.serialize( newMapGeneral.get( 'listOfSourceMapping' ) ), List<ExternalSourceMapping__c>.class );
                // NEXI-127 Marta Stempien <marta.stempien@accenture.com> 26/06/2019 - Added check for externalSourceMappings.isEmpty()
                // NEXI-174 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 11/07/2019 START add new condition and loop for ESMs
                // NEXI-259 Marta Stemmpien <marta.stempien@accenture.com>, 08/08/2019 Added checks for null
                if ( externalSourceMappingsNew != null && !externalSourceMappingsNew.isEmpty( ) && externalSourceMappingsOld != null && !externalSourceMappingsOld.isEmpty( ) )
                {
                    for ( Integer i = 0; i < externalSourceMappingsNew.size( ); i++ )
                    {
                        System.debug( LoggingLevel.INFO, '[OB_Maintenance_EditServicePoint_Ctr.saveRequest] Result on start of the loop : ' + result );

                        // NEXI-225 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 22/07/2019 START
                        ExternalSourceMapping__c externalSourceMapping = externalSourceMappingsNew.get( i );
                        String mccCode = String.isBlank( externalSourceMapping.OB_MCC__c ) ? '' : externalSourceMapping.OB_MCC__c;
                        String mccOldCode = String.isBlank( externalSourceMappingsOld.get( i ).OB_MCC__c ) ? '' : externalSourceMappingsOld.get( i ).OB_MCC__c;
                        // NEXI-225 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 22/07/2019 STOP
                        // NEXI-146 grzegorz.banach@accenture.com 09/07/2019 START
                        OB_Util006_MaintenanceAnagrafica.CheckboxesGablingAndPO118Wrapper checkboxesGablingAndPO118forOldMCC = new OB_Util006_MaintenanceAnagrafica.CheckboxesGablingAndPO118Wrapper( );
                        checkboxesGablingAndPO118forOldMCC = OB_Util006_MaintenanceAnagrafica.checkForGamblingAndPO118( mccOldCode ); // NEXI-225 Joanna Mielczarek <joanna.mielczarek@accenture.com> using variable
                        // NEXI-146 grzegorz.banach@accenture.com 09/07/2019 STOP
                        OB_Util006_MaintenanceAnagrafica.CheckboxesGablingAndPO118Wrapper checkboxesGablingAndPO118forNewMCC = new OB_Util006_MaintenanceAnagrafica.CheckboxesGablingAndPO118Wrapper( );
                        checkboxesGablingAndPO118forNewMCC = OB_Util006_MaintenanceAnagrafica.checkForGamblingAndPO118( mccCode ); // NEXI-225 Joanna Mielczarek <joanna.mielczarek@accenture.com> using variable

                        System.debug( LoggingLevel.INFO, '[OB_Maintenance_EditServicePoint_Ctr.saveRequest] ESM Old : ' + externalSourceMappingsOld.get( i ) );
                        System.debug( LoggingLevel.INFO, '[OB_Maintenance_EditServicePoint_Ctr.saveRequest] ESM New : ' + externalSourceMapping );

                        if ( i == 0 )
                        {
                            tmpMap.put( 'OB_isGambling__c', String.valueOf( checkboxesGablingAndPO118forNewMCC.isGambling ) );
                            tmpMap.put( 'OB_PO118_eCommerce__c', String.valueOf( checkboxesGablingAndPO118forNewMCC.isPO118 ) );
                        }
                        tmpMap.put( 'OB_isGambling__c', String.valueOf( Boolean.valueOf( tmpMap.get( 'OB_isGambling__c' ) ) || checkboxesGablingAndPO118forNewMCC.isGambling ) );
                        tmpMap.put( 'OB_PO118_eCommerce__c', String.valueOf( Boolean.valueOf( tmpMap.get( 'OB_PO118_eCommerce__c' ) ) || checkboxesGablingAndPO118forNewMCC.isPO118 ) );

                        System.debug( LoggingLevel.INFO, '[OB_Maintenance_EditServicePoint_Ctr.saveRequest] isGambling from method : ' + checkboxesGablingAndPO118forNewMCC.isGambling + ' from map ' + tmpMap.get( 'OB_isGambling__c' ) );
                        System.debug( LoggingLevel.INFO, '[OB_Maintenance_EditServicePoint_Ctr.saveRequest] isPO118 from method : ' + checkboxesGablingAndPO118forNewMCC.isPO118 + ' from map ' + tmpMap.get( 'OB_PO118_eCommerce__c' ) );

                        // NEXI-232 Michal Targiel <michal.targiel@accenture.com> 22/07/2019 - START
                        tmpMap.putAll( logRequestPO118MoToSet( simpleNew, simpleOld ) );
                        // NEXI-232 Michal Targiel <michal.targiel@accenture.com> 22/07/2019 - STOP

                        if ( !mccCode.equalsIgnoreCase( mccOldCode ) ) // NEXI-225 Joanna Mielczarek <joanna.mielczarek@accenture.com> using variables
                        {
                            result.documentRequired = true;
                            // NEXI-225 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 19/07/2019 START
                            List<String> alberghiCodes = new List<String> {'7011', '7033', '7512'};
                            if ( '5542'.equalsIgnoreCase( mccOldCode ) )
                            {
                                result.conditionMCC = false;
                            }
                            if ( alberghiCodes.contains( mccOldCode ) && !alberghiCodes.contains( mccCode ) )
                            {
                                result.conditionMCC = result.conditionMCC && checkConditionsForMCCAlberghi( externalSourceMapping.Id );
                                System.debug( LoggingLevel.INFO, '[OB_Maintenance_EditServicePoint_Ctr.saveRequest] IF MCC ALBERGHI: ' + result );
                            }
                            // NEXI-225 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 19/07/2019 STOP
                            // NEXI-176 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 10/07/2019 START
                            if ( '5541'.equalsIgnoreCase( mccCode ) || '5542'.equalsIgnoreCase( mccCode ) )
                            {
                                result.conditionMCC = result.conditionMCC && '5541'.equalsIgnoreCase( mccCode ) ? checkConditionsForMCCNumber5541( externalSourceMapping.Id ) : checkConditionsForMCCNumber5542( externalSourceMapping.Id ); // NEXI-209 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 15/07/2019 changed or to and
                                System.debug( LoggingLevel.INFO, '[OB_Maintenance_EditServicePoint_Ctr.saveRequest] IF MCC : ' + result );
                            }
                            // NEXI-176 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 10/07/2019 STOP
                            // NEXI-146 grzegorz.banach@accenture.com 03/07/2019 START
                            if ( !checkboxesGablingAndPO118forOldMCC.isGambling && checkboxesGablingAndPO118forNewMCC.isGambling )
                            {
                                result.approvalProcessRequired = result.approvalProcessRequired || checkConditionsForGambling( externalSourceMapping.Id );
                                System.debug( LoggingLevel.INFO, '[OB_Maintenance_EditServicePoint_Ctr.saveRequest] IF GAMBLING : ' + result );
                            }
                            // NEXI-146 grzegorz.banach@accenture.com 03/07/2019 STOP
                            // NEXI-175 Wojciech Kucharek  wojciech.kucharek@accenture.com 09/07/2019 START
                            if ( !checkboxesGablingAndPO118forOldMCC.isPO118 && checkboxesGablingAndPO118forNewMCC.isPO118 )
                            {
                                result.approvalProcessRequired = result.approvalProcessRequired || checkConditionsForPO118( externalSourceMapping );
                                System.debug( LoggingLevel.INFO, '[OB_Maintenance_EditServicePoint_Ctr.saveRequest] IF PO118 : ' + result );
                            }
                            // NEXI-175 Wojciech Kucharek  wojciech.kucharek@accenture.com 09/07/2019 START
                        }
                        System.debug( LoggingLevel.INFO, '[OB_Maintenance_EditServicePoint_Ctr.saveRequest] Result on end of the loop : ' + result );
                    }
                }
                // NEXI-174 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 11/07/2019 STOP
                tmpMap.put( 'OB_StartApprovalProcess__c', String.valueOf( result.documentRequired ) );
                // NEXI-83 Marta Stempien <marta.stempien@accenture.com> 24/06/2019 - Stop

                tmpMap.put( 'OB_ReducedOldData__c', reducedOldDataToModify );
                //Start antonio.vatrano f2wave2-112 10/07/2019
                //NEXI-259 Marta Stempien <marta.stempien@accenture.com> 08/08/2019 Start
                if ( checkboxFields.changeSPnotIntegration )
                {

                    tmpMap.put( 'OB_isNotIntegrated__c', TRUE_VALUE ); //antonio.vatrano 19/07/2019 wn-144
                }
                else
                {
                    tmpMap.put( 'OB_isNotIntegrated__c', FALSE_VALUE );
                }
                if ( !result.documentRequired && checkboxFields.changeServicePointData && checkboxFields.changeSPnotIntegration ) // antonio.vatrano wn250 27/08/2019
                {
                    tmpMap.put( 'OB_Status__c', OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA );
                }
                // NEXI-261 Marta Stempien <marta.stempien@accenture.com 16/08/2019 Start
                else if ( checkboxFields.isSettlementProcedure && !( checkboxFields.changeServicePointData || checkboxFields.documentRequired ) )//NEXI-294 Grzegorz Banach <grzegorz.banach@accenture.com> 02/09/2019 Omitted "Confirmed" status when more data changed
                {
                    tmpMap.put( 'OB_Status__c', OB_UtilityConstants.LOGREQUEST_STATUS_CONFERMATO );
                }
                // NEXI-261 Marta Stempien <marta.stempien@accenture.com 16/08/2019 Start
                else
                {
                    tmpMap.put( 'OB_Status__c', OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT );
                }
                //NEXI-259 Marta Stempien <marta.stempien@accenture.com> 08/08/2019 Stop
                //END antonio.vatrano f2wave2-112 10/07/2019
                tmpMap.put( 'OB_ReducedNewData__c', JSON.Serialize( reducedNewData ) );
                //NEXI-113 Zuzanna Urban <z.urban@accenture.com> 21/06/2019 START, fix
                tmpMap.put( 'OB_ChangeServicePointData__c', TRUE_VALUE );// // elena.preteni check existing log request 10/09/2019  // NEXI-261 Marta Stempien <marta.stempien@accenture.com> 16/08/2019 Value of field changed for the value from checkbox
                tmpMap.put( 'OB_ChangeLegalForm__c', FALSE_VALUE );
                tmpMap.put( 'OB_ChangeCompanyData__c', FALSE_VALUE );
                tmpMap.put( 'OB_ChangeLegalRepresentative__c', FALSE_VALUE );
                tmpMap.put( 'OB_ChangeMerchantName__c', FALSE_VALUE );
                tmpMap.put( 'OB_NewLegalRepresentative__c', FALSE_VALUE );
                tmpMap.put( 'OB_SIAToBeApproved__c', FALSE_VALUE );
                tmpMap.put( 'OB_Change_of_data_of_beneficial_owners__c', FALSE_VALUE );
                //NEXI-133 Zuzanna Urban <z.urban@accenture.com> 21/06/2019 STOP, fix
                tmpMap.put( 'OB_MaintenanceType__c', 'Anagrafica' );
                Id idRecordType = Schema.SObjectType.OB_LogRequest__c.getRecordTypeInfosByDeveloperName( ).get( 'OB_Anagrafica' ).getRecordTypeId( );
                tmpMap.put( 'RecordTypeId', idRecordType );
                //	START 	micol.ferrari 17/12/2018
                tmpMap.put( 'OB_ServicePointId__c', simpleNew.pv.ID );

                // DG - 29/03/2019 - R1F2_RP_019 - START
                //Start antonio.vatrano 19/07/2019 wn-144
                Map<String, Object> flowDataObject = ( Map<String, Object> ) JSON.deserializeUntyped( flowData );
                if ( flowDataObject.get( 'docRequired' ) != null && Boolean.valueOf( flowDataObject.get( 'docRequired' ) ) )
                {
                    result.documentRequired = true;
                }
                //End antonio.vatrano 19/07/2019 wn-144
                Object cabObject = flowDataObject.get( 'userWrapper' );
                Map<String, Object> cabMap = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( cabObject ) );
                if ( cabMap != null )
                {
                    tmpMap.put( 'OB_CAB__c', String.valueOf( cabMap.get( 'cab' ) ) );
                }
                // DG - 29/03/2019 - R1F2_RP_019 - END

                List<User> listOfUsers = [ SELECT Id, Profile.Userlicense.Name,OB_CAB__c, contact.account.OB_ABI__c FROM User WHERE Id = :userinfo.getuserid( ) LIMIT 1 ];
                if ( !listOfUsers.isEmpty( ) )
                {
                    String abi = listOfUsers.get( 0 ).Profile.Userlicense.Name == Label.OB_License_PartnerCommunity ? listOfUsers.get( 0 ).contact.account.OB_ABI__c : null;
                    tmpMap.put( 'OB_ABI__c', abi );
                }
                System.debug( 'logRequest reduce old: ' + tmpMap.get( 'OB_ReducedOldData__c' ) );
                System.debug( 'logRequest reduce new: ' + tmpMap.get( 'OB_ReducedNewData__c' ) );
                System.debug( 'logRequest: ' + JSON.serialize( tmpMap ) );
                //	END 	micol.ferrari 17/12/2018
                // START elena.preteni@accenture.com 3/5/19 add callout to submit Stream Maintenance integrazioni Anagrafica
                Map<String, Object> mapReducedNewData = ( Map<String, Object> ) JSON.deserializeUntyped( tmpMap.get( 'OB_ReducedNewData__c' ) );
                system.debug( '## mapReducedNewData: ' + mapReducedNewData );
                system.debug( '## obj: ' + mapReducedNewData.get( 'obj' ) );
                List<Object> newlistOfObjs = ( List<Object> ) JSON.deserializeUntyped( JSON.serialize( mapReducedNewData.get( 'obj' ) ) );
                system.debug( '## listOfObjs: ' + newlistOfObjs );
                List<Map<String, Object>> newlistOfMaps = new List<Map<String, Object>>( );
                for ( Object obj : newlistOfObjs )
                {
                    newlistOfMaps.add( ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( obj ) ) );
                }
                system.debug( '## newlistOfMaps: ' + newlistOfMaps );
                // END elena.preteni@accenture.com 29/4/19 add callout to submit Stream Maintenance integrazioni Anagrafica
                // if ( requestAlreadyExist.containsKey( 'RECORDFOUND' ) && requestAlreadyExist.get( 'RECORDFOUND' ) == FALSE_VALUE )
                // {
                OB_LogRequest__c logRequest = OB_Utility.insertLogRequest( tmpMap );
                String idRequest = logRequest.Id;
                System.debug( '@@@@ LogRequest inserted: ' + idRequest );
                // END - 2019/05/07 - salvatore.pianura - Create map to use OB_Utility.insertLogRequest() method

                OB_Maintenance_Serialize_Anagrafica.SerializeWrapperServicePoint wrapperServicePoint = new OB_Maintenance_Serialize_Anagrafica.SerializeWrapperServicePoint( );

                Id servicePointResponsibleType = Schema.SObjectType.Contact.getRecordTypeInfosByName( ).get( 'Referente Punto Vendita' ).getRecordTypeId( );
                Id administrativeResponsibleType = Schema.SObjectType.Contact.getRecordTypeInfosByName( ).get( 'Responsabile Amministrativo' ).getRecordTypeId( );
                Id technicalReferentType = Schema.SObjectType.Contact.getRecordTypeInfosByName( ).get( 'Referente Tecnico' ).getRecordTypeId( );
                List<Contact> referents =
                [
                        SELECT Id,RecordTypeId, LastName,Name
                        FROM Contact
                        WHERE AccountId = :simpleNew.pv.NE__Account__c AND OB_Contact_State__c = 'Active' AND RecordTypeId in (:technicalReferentType, :administrativeResponsibleType, :servicePointResponsibleType)
                ];//AND CreatedDate = TODAY
                system.debug( 'referents -->' + referents );
                Map<String, String> referentRecordType = new Map<String, String>( );
                for ( Contact referent : referents )
                {
                    referentRecordType.put( referent.RecordTypeId, referent.Id );
                }

                OB_Maintenance_Serialize_Anagrafica.Address address = new OB_Maintenance_Serialize_Anagrafica.Address( );
                OB_Maintenance_Serialize_Anagrafica.OpeningTimes opt = new OB_Maintenance_Serialize_Anagrafica.OpeningTimes( );
                OB_Maintenance_Serialize_Anagrafica.OpeningDays opd = new OB_Maintenance_Serialize_Anagrafica.OpeningDays( );
                OB_Maintenance_Serialize_Anagrafica.Phones adminPhone = new OB_Maintenance_Serialize_Anagrafica.Phones( );
                OB_Maintenance_Serialize_Anagrafica.Phones techPhone = new OB_Maintenance_Serialize_Anagrafica.Phones( );
                OB_Maintenance_Serialize_Anagrafica.Phones respPhone = new OB_Maintenance_Serialize_Anagrafica.Phones( );
                // OB_Maintenance_Serialize_Anagrafica.Phones spPhone = new OB_Maintenance_Serialize_Anagrafica.Phones( ); // <daniele.gandini@ccenture.com> - 15/07/2019 - WN-77
                List<OB_Maintenance_Serialize_Anagrafica.ContactExecutor> listOfContact = new List<OB_Maintenance_Serialize_Anagrafica.ContactExecutor>( );//2019/05/07 - salvatore.pianura
                //START - elena.preteni WN-161,WN-152
                //START - elena.preteni change interface agreement 04/09/2019
                for ( ExternalSourceMapping__c esm : mapEsm.values( ) )
                {
                    system.debug( 'esm create body' + esm );
                    // <daniele.gandini@ccenture.com> - 17/07/2019 - WN-77 - start
                    OB_Maintenance_Serialize_Anagrafica.SalesPointChanges spc = new OB_Maintenance_Serialize_Anagrafica.SalesPointChanges( );
                    OB_Maintenance_Serialize_Anagrafica.Phones spPhone = new OB_Maintenance_Serialize_Anagrafica.Phones( );
                    // wrapperServicePoint.salesPointChanges =  new List<OB_Maintenance_Serialize_Anagrafica.SalesPointChanges>( );
                    spc.phones = new List<OB_Maintenance_Serialize_Anagrafica.Phones>( );
                    spc.source = esm.OB_Source__c;
                    spc.companyCode = esm.OB_CustomerCodeClientCode__c;
                    spc.pvCode = esm.OB_ServicePointCodeShopCode__c;
                    system.debug( ' wrapperServicePoint.salesPointCodes.codes' + JSON.serialize( spc ) );
                    // <daniele.gandini@ccenture.com> - 17/07/2019 - WN-77 - stop
                    // wrapperServicePoint.salesPointCodes.add( codes );
                    // system.debug( ' wrapperServicePoint.salesPointCodes' + JSON.serialize( wrapperServicePoint.salesPointCodes ) );
                    for ( Map<String, Object> singlemap : newlistOfMaps )
                    {
                        if ( singlemap.containsKey( 'attributes' ) )
                        {
                            Map<String, Object> attributesmap = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( singlemap.get( 'attributes' ) ) );
                            system.debug( '## attributesmap: ' + attributesmap );
                            if ( attributesmap.containsKey( 'type' ) && attributesmap.get( 'type' ) == 'NE__Service_Point__c' )
                            {
                                //NEXI-356 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 07/10/2019 START
                                //START - elena.preteni 26/07/2019 WN-156,WN-160 indirizzo completo
                                if ( singlemap.containsKey( 'OB_Province_Code__c' ) )
                                {
                                    address.country = 'ITA';
                                }
                                address.postalCode = singlemap.containsKey( 'NE__Postal_Code__c' ) ? ( String ) singlemap.get( 'NE__Postal_Code__c' ) : null;
                                address.city = singlemap.containsKey( 'NE__City__c' ) ? ( String ) singlemap.get( 'NE__City__c' ) : null;
                                //START - ELENA.PRETENI WN-156
                                address.province = singlemap.containsKey( 'OB_Province_Code__c' ) ? ( String ) singlemap.get( 'OB_Province_Code__c' ) : null;
                                //END - ELENA.PRETENI WN-156
                                //NEXI-356 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 07/10/2019 STOP
                                //END - elena.preteni 26/07/2019 WN-156,WN-160 indirizzo completo
                                address.street = singlemap.containsKey( 'NE__Street__c' ) ? ( String ) singlemap.get( 'NE__Street__c' ) : null;
                                address.civicNumber = singlemap.containsKey( 'OB_Street_Number__c' ) ? ( String ) singlemap.get( 'OB_Street_Number__c' ) : null;
                                //TODO manca careOf
                                // wrapperServicePoint.salesPointChanges.changes.address.careOf
                                //START - elena.preteni 25/07/2019 WN-152
                                List<String> openingTime = new List<String>( );
                                String openingTimeString;
                                List<String> endingTime = new List<String>( );
                                String endingTimeString;
                                List<String> breakStartTime = new List<String>( );
                                String breakStartString;
                                List<String> breakEndTime = new List<String>( );
                                String breakEndString;

                                if ( singlemap.containsKey( 'OB_Opening_Time__c' ) && singlemap.get( 'OB_Opening_Time__c' ) != null) //gianluigi.virga 05/12/2019 - PROD-259
                                {
                                    openingTime = String.valueOf( singlemap.get( 'OB_Opening_Time__c' ) ).split( ':' );
                                    openingTimeString = openingTime[ 0 ] + ':' + openingTime[ 1 ];
                                }
                                if ( singlemap.containsKey( 'OB_Ending_Time__c' ) && singlemap.get( 'OB_Ending_Time__c' ) != null ) //gianluigi.virga 05/12/2019 - PROD-259
                                {
                                    endingTime = String.valueOf( singlemap.get( 'OB_Ending_Time__c' ) ).split( ':' );
                                    endingTimeString = endingTime[ 0 ] + ':' + endingTime[ 1 ];
                                }
                                if ( singlemap.containsKey( 'OB_Break_Start_Time__c' ) && singlemap.get( 'OB_Break_Start_Time__c' ) != null) //gianluigi.virga 05/12/2019 - PROD-259
                                {
                                    breakStartTime = String.valueOf( singlemap.get( 'OB_Break_Start_Time__c' ) ).split( ':' );
                                    breakStartString = breakStartTime[ 0 ] + ':' + breakStartTime[ 1 ];
                                }
                                if ( singlemap.containsKey( 'OB_Break_End_Time__c' ) && singlemap.get( 'OB_Break_End_Time__c' ) != null) //gianluigi.virga 05/12/2019 - PROD-259
                                {
                                    breakEndTime = String.valueOf( singlemap.get( 'OB_Break_End_Time__c' ) ).split( ':' );
                                    breakEndString = breakEndTime[ 0 ] + ':' + breakEndTime[ 1 ];
                                }

                                opt.openingHour = singlemap.containsKey( 'OB_Opening_Time__c' ) ? openingTimeString : null;
                                opt.closingHour = singlemap.containsKey( 'OB_Ending_Time__c' ) ? endingTimeString : null;
                                opt.startBreak = singlemap.containsKey( 'OB_Break_Start_Time__c' ) ? breakStartString : null;
                                opt.endBreak = singlemap.containsKey( 'OB_Break_End_Time__c' ) ? ( String ) breakEndString : null;
                                //END - elena.preteni 25/07/2019 WN-152
                                opt.startSeasonalActivity = singlemap.containsKey( 'OB_Start_Seasonal__c' ) ? ( String ) singlemap.get( 'OB_Start_Seasonal__c' ) : null;
                                opt.endSeasonalActivity = singlemap.containsKey( 'OB_End_Seasonal__c' ) ? ( String ) singlemap.get( 'OB_End_Seasonal__c' ) : null;
                                // NEXI-263 Marta Stempien <marta.stempien@accenture.com 09/08/2019 Set old value instead of null in case of no changes, Start
                                opd.mondayMorning = singlemap.containsKey( 'OB_Opening_Monday_Morning__c' ) ? String.valueOf( singlemap.get( 'OB_Opening_Monday_Morning__c' ) ) : String.valueOf( simpleOld.pv.OB_Opening_Monday_Morning__c );
                                opd.mondayAfternoon = singlemap.containsKey( 'OB_Opening_Monday_Afternoon__c' ) ? String.valueOf( singlemap.get( 'OB_Opening_Monday_Afternoon__c' ) ) : String.valueOf( simpleOld.pv.OB_Opening_Monday_Afternoon__c );
                                opd.tuesdayMorning = singlemap.containsKey( 'OB_Opening_Tuesday_Morning__c' ) ? String.valueOf( singlemap.get( 'OB_Opening_Tuesday_Morning__c' ) ) : String.valueOf( simpleOld.pv.OB_Opening_Tuesday_Morning__c );
                                opd.tuesdayAfternoon = singlemap.containsKey( 'OB_Opening_Tuesday_Afternoon__c' ) ? String.valueOf( singlemap.get( 'OB_Opening_Tuesday_Afternoon__c' ) ) : String.valueOf( simpleOld.pv.OB_Opening_Tuesday_Afternoon__c );
                                opd.wednesdayMorning = singlemap.containsKey( 'OB_Opening_Wednesday_Morning__c' ) ? String.valueOf( singlemap.get( 'OB_Opening_Wednesday_Morning__c' ) ) : String.valueOf( simpleOld.pv.OB_Opening_Wednesday_Morning__c );
                                opd.wednesdayAfternoon = singlemap.containsKey( 'OB_Opening_Wednesday_Afternoon__c' ) ? String.valueOf( singlemap.get( 'OB_Opening_Wednesday_Afternoon__c' ) ) : String.valueOf( simpleOld.pv.OB_Opening_Wednesday_Afternoon__c );
                                opd.thursdayMorning = singlemap.containsKey( 'OB_Opening_Thursday_Morning__c' ) ? String.valueOf( singlemap.get( 'OB_Opening_Thursday_Morning__c' ) ) : String.valueOf( simpleOld.pv.OB_Opening_Thursday_Morning__c );
                                opd.thursdayAfternoon = singlemap.containsKey( 'OB_Opening_Thursday_Afternoon__c' ) ? String.valueOf( singlemap.get( 'OB_Opening_Thursday_Afternoon__c' ) ) : String.valueOf( simpleOld.pv.OB_Opening_Thursday_Afternoon__c );
                                opd.fridayMorning = singlemap.containsKey( 'OB_Opening_Friday_Morning__c' ) ? String.valueOf( singlemap.get( 'OB_Opening_Friday_Morning__c' ) ) : String.valueOf( simpleOld.pv.OB_Opening_Friday_Morning__c );
                                opd.fridayAfternoon = singlemap.containsKey( 'OB_Opening_Friday_Afternoon__c' ) ? String.valueOf( singlemap.get( 'OB_Opening_Friday_Afternoon__c' ) ) : String.valueOf( simpleOld.pv.OB_Opening_Friday_Afternoon__c );
                                opd.saturdayMorning = singlemap.containsKey( 'OB_Opening_Saturday_Morning__c' ) ? String.valueOf( singlemap.get( 'OB_Opening_Saturday_Morning__c' ) ) : String.valueOf( simpleOld.pv.OB_Opening_Saturday_Morning__c );
                                opd.saturdayAfternoon = singlemap.containsKey( 'OB_Opening_Saturday_Afternoon__c' ) ? String.valueOf( singlemap.get( 'OB_Opening_Saturday_Afternoon__c' ) ) : String.valueOf( simpleOld.pv.OB_Opening_Saturday_Afternoon__c );
                                opd.sundayMorning = singlemap.containsKey( 'OB_Opening_Sunday_Morning__c' ) ? String.valueOf( singlemap.get( 'OB_Opening_Sunday_Morning__c' ) ) : String.valueOf( simpleOld.pv.OB_Opening_Sunday_Morning__c );
                                opd.sundayAfternoon = singlemap.containsKey( 'OB_Opening_Sunday_Afternoon__c' ) ? String.valueOf( singlemap.get( 'OB_Opening_Sunday_Afternoon__c' ) ) : String.valueOf( simpleOld.pv.OB_Opening_Sunday_Afternoon__c );
                                // NEXI-263 Marta Stempien <marta.stempien@accenture.com 09/08/2019 Set old value instead of null in case of no changes, Stop

                                // <daniele.gandini@ccenture.com> - 15/07/2019 - WN-77 - start
                                //START - elena.preteni 26/07/2019 Mobile only if telephone changed
                                spPhone.modality = singlemap.containsKey( 'OB_Mobile_Phone_Number__c' ) ? 'MOBILE' : null;
                                //END - elena.preteni 26/07/2019 Mobile only if telephone changed
                                spPhone.phoneNumber = singlemap.containsKey( 'OB_Mobile_Phone_Number__c' ) ? ( String ) singlemap.get( 'OB_Mobile_Phone_Number__c' ) : null;
                                // <daniele.gandini@ccenture.com> - 15/07/2019 - WN-77 - stop
                                //START - elena.preteni 23/07/2019 WN-161,WN-152
                                spc.shopName = singlemap.containsKey( 'Name' ) ? ( String ) singlemap.get( 'Name' ) : null;
                                spc.email = singlemap.containsKey( 'OB_Email__c' ) ? ( String ) singlemap.get( 'OB_Email__c' ) : null;
                                spc.merchantCategoryCode = singlemap.containsKey( 'OB_MCC__c' ) ? ( String ) singlemap.get( 'OB_MCC__c' ) : null;
                                spc.PEC = null;
                                spc.flagPrivacyC3 = null;
                                spc.flagPrivacyC4 = null;
                                spc.flagPrivacyC5 = null;
                                //END - elena.preteni 23/07/2019 WN-161,WN-152
                            }

                            //START - elena.preteni WN-161,WN-152
                            if ( attributesmap.containsKey( 'type' ) && attributesmap.get( 'type' ) == 'ExternalSourceMapping__c' )
                            {
                                spc.shopName = singlemap.containsKey( 'OB_ShopSign__c' ) ? ( String ) singlemap.get( 'OB_ShopSign__c' ) : null;
                                spc.receiptLocation = singlemap.containsKey( 'OB_ReceiptCity__c' ) ? ( String ) singlemap.get( 'OB_ReceiptCity__c' ) : null;
                                spc.receiptheader = singlemap.containsKey( 'OB_ReceiptHeader__c' ) ? ( String ) singlemap.get( 'OB_ReceiptHeader__c' ) : null;
                            }
                            //END - elena.preteni WN-161,WN-152
                        }
                    }
                    opt.openingDays = opd;
                    //START - elena.preteni WN-161,WN-152 is not an Array
                    spc.address = address;
                    spc.openingTimes = opt;
                    spc.phones.add( spPhone ); // <daniele.gandini@accenture.com> - 15/07/2019 - WN-77
                    //END - elena.preteni WN-161,WN-152 is not an Array
                    system.debug( 'spc' + spc );
                    wrapperServicePoint.salesPointChanges.add( spc ) ;
                }
                //END - elena.preteni WN-161,WN-152
                //END - elena.preteni change interface agreement 04/09/2019


                wrapperServicePoint.requestId = idRequest;
                system.debug( 'wrapperServicePoint' + wrapperServicePoint );

                if ( !Test.isRunningTest( ) )
                {
                    //Start antonio.vatrano wn-412 13/09/2019
                    if ( !logRequest.OB_isNotIntegrated__c )
                    {
                        OB_UtilityCallingServices.callService( 'callout:OB_callService/api/merchants/' + simpleNew.pv.NE__Account__c + '/sales-points/' + simpleNew.pv.id, 'POST', OB_Maintenance_Serialize_Anagrafica.serializeObjectServicePoint( wrapperServicePoint ) );
                    }
                    //End antonio.vatrano wn-412 13/09/2019
                }
                else
                {
                    system.debug( 'SubmitCall' );
                }
                //elena.preteni@accenture.com 29/4/19 add callout to submit Stream Maintenance integrazioni Anagrafica
                result.errorOccurred = false;
                result.logrequestId = idRequest;
                result.isNotIntegrated = logRequest.OB_isNotIntegrated__c;  // start antonio.vatrano wn 144

                //NEXI-65 Wojciech Kucharek <wojciech.kucharek@accenture.com> 13/06/2019 START
                result.logName = logRequest.Name;
                //NEXI-65 Wojciech Kucharek <wojciech.kucharek@accenture.com> 13/06/2019 STOP
                // }
                // else
                // {
                //     System.debug( '@@@@ No logRequest  inserted' );
                //     result.errorOccurred = true;
                //     String namelog = requestAlreadyExist.containsKey( 'LOGNAME' ) && requestAlreadyExist.get( 'LOGNAME' ) != null ? ' (' + requestAlreadyExist.get( 'LOGNAME' ) + ')' : '';
                //     result.errorMessage = System.label.OB_MAINTENANCE_LOGALREADYEXIST + namelog;
                // }
                // DG - 21/02/2019 - START - No change has been made
            }
            else
            {
                result.errorMessage = System.label.OB_NoChangesMessage;
            }
            // DG - 21/02/2019 - END - No change has been made
        } catch ( Exception e )
        {
            if ( logRequestExistsException )
            {
                throw new LogRequestExistsException( e.getMessage( ) );
            }
            //NEXI-179 Marta Stempien <marta.stempien@accenture.com> 30/07/2019 Stop
            System.debug( 'Generic Error: ' + e.getMessage( ) + ' at line: ' + e.getLineNumber( ) + ' stack trace: ' + e.getStackTraceString( ) );
            result.errorOccurred = true;
            result.errorMessage = e.getMessage( );
        }
        system.debug( 'result -->' + result );
        return result; // NEXI-127 Marta Stempien <marta.stempien@accenture.com> 26/06/2019 Fix - revert change of returned type
    }

    /*
    *   Author : Claudio Quaranta
    *   Date : 04/12/2018
    *	Description : method called from a lighting component, used to retrieve data to display
    *	input : id of the service point to display
    *	output : a JSON that contains service data and related contact information
    *
    */
    @AuraEnabled
    public static string retrieveServicePointData( string servicePointId )
    {
        ServicePointWrapper wrap = new ServicePointWrapper( );
        system.debug( 'servicePointId --> ' + servicePointId );
        if ( !String.isBlank( servicePointId ) )
        {
            try
            {
                List<NE__Service_Point__c> servicePoints = //francesca.ribezzi 14/10/19 put select result into list
                [
                        select id,
                                Name,
                                OB_MCC__c,
                                OB_Email__c,
                                NE__Country__c,
                                NE__Country_Code__c,
                                NE__Province__c,
                                NE__City__c,
                                OB_District__c,
                                NE__Street__c,
                                OB_Street_Number__c,
                                NE__Postal_Code__c,
                                OB_Address_Detail__c,
                                NE__Account__c,
                                OB_Opening_Sunday_Afternoon__c,
                                OB_Opening_Saturday_Afternoon__c,
                                OB_Opening_Friday_Afternoon__c,
                                OB_Opening_Thursday_Afternoon__c,
                                OB_Opening_Wednesday_Afternoon__c,
                                OB_Opening_Tuesday_Afternoon__c,
                                OB_Opening_Monday_Afternoon__c,
                                OB_Opening_Sunday_Morning__c,
                                OB_Opening_Saturday_Morning__c,
                                OB_Opening_Friday_Morning__c,
                                OB_Opening_Thursday_Morning__c,
                                OB_Opening_Wednesday_Morning__c,
                                OB_Opening_Tuesday_Morning__c,
                                OB_Opening_Monday_Morning__c,
                                OB_Opening_Time__c,
                                OB_Ending_Time__c,
                                OB_Break_Start_Time__c,
                                OB_Break_End_Time__c,
                                OB_Mobile_Phone_Number__c,
                                OB_MCC_Description__c,
                                OB_Province_Code__c, //NEXI-356 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 07/10/2019
                                OB_Start_Seasonal__c, //francesca.ribezzi 11/11/19 - PROD-43 - adding start seasonal and end seasonal
                                OB_End_Seasonal__c
                        from NE__Service_Point__c
                        where id = :servicePointId
                        limit 1
                ];
                if(servicePoints.size() > 0){
                     wrap.pv = servicePoints[0];
                } 
                //START: Elena Preteni 2/1/2019
                wrap.listOfSourceMapping = OB_Maintenance_EditServicePoint_Ctr.retrievePuntiVenditaData( servicePointId );
                //START NEXI-105 05/06/2019 z.urban@accenture.com retrieve Contacts
                Id servicePointReferentType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.REFERENTE_PUNTO_VENDITA ).getRecordTypeId( );
                Id administrativeResponsibleType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.RESPONSABILE_AMMINISTRATIVO ).getRecordTypeId( );
                Id technicalReferentType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.REFERENTE_TECNICO ).getRecordTypeId( );

                wrap.servicePointResponsible = OB_Maintenance_EditServicePoint_Ctr.retrieveContact( servicePointId, servicePointReferentType );
                wrap.administrativeResponsible = OB_Maintenance_EditServicePoint_Ctr.retrieveContact( servicePointId, administrativeResponsibleType );
                wrap.technicalReferent = OB_Maintenance_EditServicePoint_Ctr.retrieveContact( servicePointId, technicalReferentType );
                //STOP NEXI-105 05/06/2019 z.urban@accenture.com retrieve Contacts
            } catch ( Exception e )
            {
                wrap.errorOccurred = true;
                wrap.errorMessage = System.label.OB_MAINTENANCE_NO_SERVICEPOINT_SELECTED;
            }
            System.debug( 'wrap.servicePoint --> ' + wrap.pv );
        }
        else
        {
            wrap.errorOccurred = true;
            wrap.errorMessage = System.label.OB_MAINTENANCE_NO_SERVICEPOINT_SELECTED;
        }
        string toReturnJSON = JSON.serialize( wrap );
        system.debug( 'toReturnJSON --> ' + toReturnJSON );
        return toReturnJSON ;
    }

    /*
    *   Author : Claudio Quaranta
    *   Date : 03/12/2018
    *	Description : method called from a lighting component, used to retrieve the fields label for object retrivedi in input.
    *	input : the list of SObject for schema estraction (E.G 'Account', 'Contact' ecc)
    *	output : a map that contasin the object as akey, and a map of field api name- field label
    */
    @auraEnabled
    public static string retriveSchemaInformation( list<string> SObjectToRetrive )
    {
        Map<String, Map<String, Schema.DescribeFieldResult>> objType2fieldData = new Map<String, Map<String, Schema.DescribeFieldResult>>( );
        objType2fieldData.putAll( OB_Maintenance_Helper.fieldObjType2APINameSchema( SObjectToRetrive ) );
        SchemaWrapper returnWrapper = new SchemaWrapper( );
        for ( string currentSObject : SObjectToRetrive )
        {
            returnWrapper.mapSObjectfields.put( currentSObject, OB_maintenance_helper.estractFieldsLabel( objType2fieldData.get( currentSObject ) ) );
        }
        string toReturnJSON = JSON.serialize( returnWrapper );
        return toReturnJSON;
    }

    @AuraEnabled
    public static List<String> retrieveValueTypology( )
    {
        List<String> pickListValuesList = new List<String>( );
        Schema.DescribeFieldResult fieldResult = NE__Service_Point__c.OB_Typology__c.getDescribe( );
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues( );
        for ( Schema.PicklistEntry pickListVal : ple )
        {
            pickListValuesList.add( pickListVal.getValue( ) );
            System.debug( 'pickListValuesList reportTypes ' + pickListValuesList );
        }
        return pickListValuesList;
    }

    @AuraEnabled
    public static List<ExternalSourceMapping__c> retrievePuntiVenditaData( String servicePointId )
    {
        //START: Elena Preteni 31/12/2018
        String valueAbi = '';
        List<ExternalSourceMapping__c> esmListToReturn = new List<ExternalSourceMapping__c>( );
        Set<ExternalSourceMapping__c> esmSetToReturn = new Set<ExternalSourceMapping__c>( );
        List<User> listOfUsers = [ SELECT Id, Profile.Userlicense.Name, Profile.Name, OB_CAB__c, contact.account.OB_ABI__c FROM User WHERE Id = :userinfo.getuserid( ) LIMIT 1 ];
        if ( !listOfUsers.isEmpty( ) )
        {
            valueAbi = listOfUsers.get( 0 ).Profile.Userlicense.Name == Label.OB_License_PartnerCommunity ? listOfUsers.get( 0 ).contact.account.OB_ABI__c : null;
        }
        string profileName = listOfUsers.get( 0 ).Profile.Name;
        esmSetToReturn = OB_Maintenance_EditServicePoint_Ctr.createSetSalesPoints( servicePointId, valueAbi, profileName );
        esmListToReturn.addAll( esmSetToReturn );

        return esmListToReturn;
        //ENE: Elena Preteni 31/12/2018
    }

    //GIOVANNI SPINELLI - 20/12/2018 -GET LOVS L2
    @AuraEnabled
    public static List<NE__Lov__c> retrieveLovMccL2( )
    {
        List<NE__Lov__c> lovL2List = new List<NE__Lov__c>( );
        lovL2List =
        [
                SELECT Id, Name, NE__Active__c, NE__Lov__c, NE__Source_Lov_Id__c,
                        NE__Sub_Type__c, NE__Type__c, NE__Value1__c, NE__Value2__c,
                        NE__Value3__c, OB_Value4__c, OB_Value5__c
                FROM NE__Lov__c
                WHERE NE__Active__c = true AND NE__Type__c = 'MCC' AND NE__Value3__c = 'L2'
                ORDER BY Name
        ];
        return lovL2List;
    }

    //GIOVANNI SPINELLI - 20/12/2018 -GET LOVS L3
    @AuraEnabled
    public static List<NE__Lov__c> retrieveLovMccL3( )
    {
        List<NE__Lov__c> lovL3List = new List<NE__Lov__c>( );
        lovL3List =
        [
                SELECT Id, Name, NE__Active__c, NE__Lov__c, NE__Source_Lov_Id__c,
                        NE__Sub_Type__c, NE__Type__c, NE__Value1__c, NE__Value2__c,
                        NE__Value3__c, OB_Value4__c, OB_Value5__c
                FROM NE__Lov__c
                WHERE NE__Active__c = true AND NE__Type__c = 'MCC' AND NE__Value3__c = 'L3'
                ORDER BY Name
        ];
        return lovL3List;
    }

    //	START 	micol.ferrari 17/12/2018
    public static Time ParseTime( String timeString )
    {
        if ( timeString != null && timeString != '' )
        {
            // 14:26:41.276Z or "14:26:41.276Z"
            List<String> values = timeString.replace( 'Z', '' ).replace( '"', '' ).split( ':' );

            // (14, 26, 41.276)
            Integer hours = Integer.valueOf( values[ 0 ] );
            Integer minutes = Integer.valueOf( values[ 1 ] );

            // 41.276 -> (41, 276)
            Integer seconds = Integer.valueOf( values[ 2 ].split( '\\.' )[ 0 ] );
            Integer milliseconds = Integer.valueOf( values[ 2 ].split( '\\.' )[ 1 ] );

            return Time.newInstance( hours, minutes, seconds, milliseconds );
        }
        else
        {
            return null;
        }
    }
    //	END 	micol.ferrari 17/12/2018

    //ANDREA START: TESTING COERENCY UPON TIME FIELDS
    @AuraEnabled
    public static Boolean checkCoherencyDate( Time openingTime, Time endingTime, Time breakStartTime, Time breakEndTime )
    {
        Boolean toReturn;

        Time midnight = Time.newInstance( 00, 00, 00, 00 );
        if ( openingTime != null || endingTime != null || breakStartTime != null || breakEndTime != null )
        {
            if ( ( openingTime == null && endingTime == null ) && ( breakStartTime != null && breakEndTime != null ) )
            {
                toReturn = false;

            }

            if ( ( openingTime != null && endingTime == null ) && ( breakStartTime != null && breakEndTime != null ) )
            {
                toReturn = false;
            }

            if ( ( openingTime == null && endingTime != null ) && ( breakStartTime != null && breakEndTime != null ) )
            {
                toReturn = false;
            }
            if ( ( openingTime != null && endingTime != null )
                    &&
                    ( breakStartTime == null && breakEndTime != null )
                    &&
                    ( ( breakEndTime > openingTime ) && ( breakEndTime < endingTime || endingTime == midnight ) ) )
            {

                toReturn = false;
            }

            if ( ( openingTime != null && endingTime != null )
                    && ( breakStartTime != null && breakEndTime == null )
                    && ( ( breakStartTime > openingTime ) && ( breakStartTime < endingTime || endingTime == midnight ) ) )
            {
                toReturn = false;
            }

            if ( ( openingTime >= endingTime && endingTime != midnight )
                    ||
                    ( openingTime == endingTime && endingTime == midnight && openingTime == midnight ) )
            {

                toReturn = false;

            }

            if ( openingTime < endingTime && endingTime != midnight )
            {
                if ( (
                        ( breakStartTime > openingTime ) && ( breakStartTime < endingTime && endingTime != midnight ) )
                        &&
                        ( ( breakEndTime <= openingTime ) || ( breakEndTime >= endingTime && endingTime != midnight ) ) )
                {

                    toReturn = false;
                }
                else if ( ( ( breakEndTime > openingTime ) && ( breakEndTime < endingTime && endingTime != midnight ) )
                        &&
                        ( ( breakStartTime <= openingTime ) || ( breakStartTime >= endingTime && endingTime != midnight ) ) )
                {

                    toReturn = false;
                }
            }

            if ( ( ( breakStartTime <= openingTime ) || ( breakStartTime >= endingTime && endingTime != midnight ) )
                    &&
                    ( ( breakEndTime <= openingTime ) || ( breakEndTime >= endingTime && endingTime != midnight ) ) )
            {

                toReturn = false;
            }

            if ( breakStartTime >= breakEndTime && breakEndTime != midnight )
            {
                toReturn = false;
            }

        }
        return toReturn;
    }
    //ANDREA END

    /*******************************************************************************
    Purpose:    Method for validating merchant during maintenance EditServicePoint
    Parameters: Id accountId
    Returns:    Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba          02/07/2019      Created         NEXI-116
    ********************************************************************************/
    private static Boolean merchantCheck( Id accountId )
    {
        List<Account> accounts =
        [
                SELECT Id,
                        OB_VAT_Not_Present__c,
                        OB_DescriptionVATNotPresent__c
                FROM Account
                WHERE Id = :accountId
                LIMIT 1
        ];
        Account account;
        if ( !accounts.isEmpty( ) )
        {
            account = accounts[ 0 ];
            return ( account.OB_VAT_Not_Present__c == true && OB_UtilityConstants.B_AND_B.equalsIgnoreCase( account.OB_DescriptionVATNotPresent__c ) );
        }
        return false;

    }

    /*******************************************************************************
    Purpose:    Wrapper method for validating merchant and asset during maintenance EditServicePoint
    Parameters: Id accountId, String mappingListJson
    Returns:    MerchantAssetCheckWrapper

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba          12/08/2019      Created         NEXI-261
    ********************************************************************************/
    @AuraEnabled
    public static MerchantAssetCheckWrapper merchantAndAssetCheck( Id accountId, String mappingListJson )
    {
        MerchantAssetCheckWrapper result = new MerchantAssetCheckWrapper( );
        result.merchantCheck = merchantCheck( accountId );
        result.assetCheck = checkIfRelatedAssetsExist( mappingListJson );
        return result;
    }

    //START: Elena Preteni 2/1/2019
    private static Set<ExternalSourceMapping__c> createSetSalesPoints( String servicePointId, String valueAbi, String profileName )
    {
        Set<ExternalSourceMapping__c> esmSetToReturn = new Set<ExternalSourceMapping__c>( );

        //START: 15/03/19 francesca.ribezzi adding new list to return:
        Set<ExternalSourceMapping__c> newESMsetToReturn = new Set<ExternalSourceMapping__c>( );
        //adding monetica and equens lists:
        Set<ExternalSourceMapping__c> moneticaList = new Set<ExternalSourceMapping__c>( );
        Set<ExternalSourceMapping__c> equensList = new Set<ExternalSourceMapping__c>( );
        //END

        List<ExternalSourceMapping__c> esm =
        [
                SELECT Id,
                        OB_Source__c, // enrico.purificato WN-118
                        OB_ShopSign__c,
                        OB_ReceiptHeader__c,
                        OB_ReceiptCity__c,
                        OB_MCC__c,
                        OB_MCCL2__c,
                        OB_ServicePointCodeShopCode__c,
                        OB_CustomerCodeClientCode__c,
                        OB_Conventioncode__c,  //simone misani 24/05/2019 RI-87
                        OB_InternationalSettlementMethod__c // NEXI-261 Marta Stempien <marta.stempien@accenture.com> Added field to Quesry - fix for not displaying OB_InternationalSettlementMethod__c in table 14/08/2019
                FROM ExternalSourceMapping__c
                WHERE OB_Service_Point_ID__c = :servicePointId
        ];

        system.debug( 'valueAbi -->' + valueAbi + 'servicePointId -->' + servicePointId );
        System.debug( 'esm --> ' + esm );
        String assetQuery = 'SELECT NE__Service_Point__c,  NE__Status__c, OB_ABI__c, OB_ProposerABI__r.OB_ABI__c, OB_GT__c, ' +
                'OB_Processor__c, OB_CustomerCode__c, OB_CompanyCode__c, OB_ServicePointCode__c, OB_ShopCode__c FROM Asset  WHERE ' +
                +'NE__Service_Point__c = \'' + servicePointId + '\'';
        if ( profileName != 'Operation' )
        {
            assetQuery += ' AND OB_ProposerABI__r.OB_ABI__c =\'' + valueAbi + '\'';
        }
        assetQuery += ' AND (OB_GT__c!= null OR OB_Processor__c != null)'; // enrico.purificato WN-118
        List<Asset> assets = Database.query( assetQuery );

        system.debug( 'assets -->' + assets );
        //enrico.purificato WN-118 START
        Map<String, ExternalSourceMapping__c> GTMap = new Map<String, ExternalSourceMapping__c>( );
        Map<String, ExternalSourceMapping__c> AssetCodeMap = new Map<String, ExternalSourceMapping__c>( );
        Map<String, ExternalSourceMapping__c> AcquiringMap = new Map<String, ExternalSourceMapping__c>( );
        Map<String, ExternalSourceMapping__c> AcquiringMapAsset = new Map<String, ExternalSourceMapping__c>( );

        for ( ExternalSourceMapping__c e : esm )
        {
            if ( 'Monetica'.equalsIgnoreCase( e.OB_Source__c ) )
            {
                String KEY = e.OB_Source__c + e.OB_ServicePointCodeShopCode__c + e.OB_CustomerCodeClientCode__c + e.OB_Conventioncode__c;
                GTMap.put( KEY, e );
            }
            if ( 'SIA'.equalsIgnoreCase( e.OB_Source__c ) || 'Equens'.equalsIgnoreCase( e.OB_Source__c ) )
            {
                AcquiringMap.put( e.OB_ServicePointCodeShopCode__c, e );
            }
        }

        for ( ExternalSourceMapping__c e : GTMap.values( ) )
        {
            if ( !String.isBlank( e.OB_Conventioncode__c ) && AcquiringMap.containsKey( e.OB_Conventioncode__c ) )
            {
                //francesca.ribezzi 14/10/19 - R1F3-137 mapping OB_InternationalSettlementMethod__c from equens to monetica                 
                e.OB_InternationalSettlementMethod__c = AcquiringMap.get(e.OB_Conventioncode__c).OB_InternationalSettlementMethod__c; 
                AcquiringMap.remove( e.OB_Conventioncode__c );
            }
            String KEY = e.OB_Source__c + e.OB_ServicePointCodeShopCode__c + e.OB_CustomerCodeClientCode__c;
            AssetCodeMap.put( KEY, e );
        }

        for ( ExternalSourceMapping__c e : AcquiringMap.values( ) )
        {
            String KEY = e.OB_Source__c + e.OB_ServicePointCodeShopCode__c + e.OB_CustomerCodeClientCode__c;
            AssetCodeMap.put( KEY, e );
        }
        for ( Asset a : assets )
        {
            String KEY = '';
            if ( !String.isBlank( a.OB_GT__c ) )
            {
                KEY = a.OB_GT__c + a.OB_ShopCode__c + a.OB_CustomerCode__c;
            }
            if ( !String.isBlank( a.OB_Processor__c ) && KEY == '' ) //antonio.vatrano r1f3-105 24/09/2019 add condition
            {
                KEY = a.OB_Processor__c + a.OB_ServicePointCode__c + a.OB_CompanyCode__c;
            }
            if ( KEY != '' && AssetCodeMap.containsKey( KEY ) )
            {

                newESMsetToReturn.add( AssetCodeMap.get( KEY ) );
            }
        }
        return newESMsetToReturn;
        //enrico.purificato WN-118 END
    }
    //END: Elena Preteni 2/1/2019


    /*******************************************************************************
    Purpose:  Method select Contact servicePointResponsible
    Parameters: String servicePointId
    Returns: Contact

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Zuzanna Urban     06/06/2019            Created         NEXI-105
    2.0         Zuzanna Urban     04/07/2019            Modyfied        NEXI-162
    ********************************************************************************/
    private static Contact retrieveContact( string servicePointId, id recordTypeId )
    {
        Contact contactReturned = new Contact( );
        try
        {
            List<Contact> contacts =  //francesca.ribezzi 14/10/19 put select result into list
            [
                    select id,
                            FirstName,
                            LastName,
                            Email,
                            MobilePhone,
                            OB_BypassValidation__c,
                            AccountId,
                            OB_Bank__c,
                            OB_Service_Point__c
                    from Contact
                    where OB_Service_Point__c = :servicePointId
                    and RecordtypeId = :recordTypeId
                    order by LastModifiedDate DESC
                    limit 1
            ];
        if(contacts.size()> 0){
            contactReturned = contacts[0];
        }
        
        } catch ( Exception ex )
        {
            System.debug( LoggingLevel.ERROR, '[EXC] Exception ' + ex.getMessage( ) + ' stacktrace ' + ex.getStackTraceString( ) );
        }
        return contactReturned;
    }

    /*******************************************************************************
    Purpose:    Method check if there is any Asset related to externalSourceMapping selected on front
    Parameters: String mappingListJson
    Returns:    Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Szuba          11/07/2019      Created         NEXI-180
    ********************************************************************************/
    private static Boolean checkIfRelatedAssetsExist( String mappingListJson )
    {
        System.debug( LoggingLevel.INFO, 'OB_Maintenance_EditServicePoint_Ctr.checkIfRelatedAssetsExist start ' + mappingListJson );
        if ( String.isBlank( mappingListJson ) )
        {
            return false;
        }
        List<Object> listOfMappings = new List<Object>( );
        try
        {
            listOfMappings = ( List<Object> ) JSON.deserializeUntyped( mappingListJson );
        } catch ( Exception ex )
        {
            System.debug( LoggingLevel.ERROR, 'OB_Maintenance_EditServicePoint_Ctr.checkIfRelatedAssetsExist - deserializing json failed' );
        }
        Map< String, Object > externalSourceMapping = new Map<String, Object>( );
        Set<String> servicePointShopCodes = new Set<String>( );
        for ( Object mapping : listOfMappings )
        {
            try
            {
                externalSourceMapping = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( mapping ) );
            } catch ( Exception ex )
            {
                System.debug( LoggingLevel.ERROR, 'OB_Maintenance_EditServicePoint_Ctr.checkIfRelatedAssetsExist - deserializing json failed' );
            }
            System.debug( LoggingLevel.INFO, 'OB_Maintenance_EditServicePoint_Ctr.checkIfRelatedAssetsExist In loop esm ' + externalSourceMapping );
            if ( !externalSourceMapping.isEmpty( ) && externalSourceMapping.get( ASSET_ESM_FIELD_RELATION ) != null )
            {
                servicePointShopCodes.add( ( String ) externalSourceMapping.get( ASSET_ESM_FIELD_RELATION ) );
            }
        }
        System.debug( LoggingLevel.INFO, 'OB_Maintenance_EditServicePoint_Ctr.checkIfRelatedAssetsExist servicePointShopCodes  ' + servicePointShopCodes );
        if ( !servicePointShopCodes.isEmpty( ) )
        {
            List<Asset> relatedAssets =
            [
                    SELECT Id
                    FROM Asset
                    WHERE OB_ServicePointCode__c IN:servicePointShopCodes
                    AND OB_SettlementType__c = :OB_UtilityConstants.SETTLEMENT_TYPE_BANCA_LORDO
                    LIMIT 1
            ];
            if ( !relatedAssets.isEmpty( ) )
            {
                System.debug( LoggingLevel.INFO, 'OB_Maintenance_EditServicePoint_Ctr.checkIfRelatedAssetsExist end true  ' );
                return true;
            }
        }
        System.debug( LoggingLevel.INFO, 'OB_Maintenance_EditServicePoint_Ctr.checkIfRelatedAssetsExist end false  ' );
        return false;
    }

    /*******************************************************************************
    Purpose:    Method returns assets related to provided external source mapping
    Parameters: String inExternalSourceMappingId
    Returns:    List<Asset>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       09/07/2019      Created         NEXI-176
    1.1         Joanna Mielczarek       19/07/2019      Modified        NEXI-225 changed query logic
    ********************************************************************************/
    private static List<Asset> getActiveAssetsForESM( String inExternalSourceMappingId )
    {
        List<ExternalSourceMapping__c> externalSourceMappings =
        [
                SELECT OB_Service_Point_ID__c,
                        OB_MCC__c,
                        OB_MCCL2__c
                FROM ExternalSourceMapping__c
                WHERE Id = :inExternalSourceMappingId
        ];

        if ( externalSourceMappings.isEmpty( ) )
        {
            return new List<Asset>( );
        }

        ExternalSourceMapping__c externalSourceMapping = externalSourceMappings.get( 0 );

        List<Asset> activeAssets =
        [
                SELECT Name,
                        OB_Processor__c,
                        NE__Root_Order_Item__c,
                        NE__ProdId__r.OB_Codice_sfdc__c,
                        NE__ProdId__r.RecordTypeId,
                        NE__Root_Order_Item__r.NE__ProdId__r.OB_Codice_sfdc__c,
                        // NEXI-262 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 07/08/2019 START
                        NE__Bundle_Configuration__r.NE__ProdId__r.OB_Codice_sfdc__c,
                        NE__Root_Order_Item__r.OB_enablement__c
                // NEXI-262 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 07/08/2019 STOP
                FROM Asset
                WHERE NE__Service_Point__c = :externalSourceMapping.OB_Service_Point_ID__c
                AND NE__Status__c != :OB_UtilityConstants.ASSET_STATUS_DISCONNECTED
                AND OB_MCC__c = :externalSourceMapping.OB_MCC__c
                AND OB_MCCL2__c = :externalSourceMapping.OB_MCCL2__c
                LIMIT 50000
        ];

        return activeAssets.isEmpty( ) ? new List<Asset>( ) : activeAssets;
    }

    /*******************************************************************************
    Purpose:    Method checks if related assets have proper values and changes can be saved - fo 5542 code
    Parameters: String inExternalSourceMappingId
    Returns:    Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek       14/06/2019      Created         NEXI-82
    1.1         Joanna Mielczarek       09/07/2019      Modified        NEXI-176 refactored code
    1.2         Joanna Mielczarek       19/07/2019      Modified        NEXI-225 change in param, logic conditions
    ********************************************************************************/
    private static Boolean checkConditionsForMCCNumber5542( String inExternalSourceMappingId )
    {
        List<Asset> activeAssets = getActiveAssetsForESM( inExternalSourceMappingId );
        if ( activeAssets.isEmpty( ) )
        {
            return true;
        }

        for ( Asset loopAsset : activeAssets )
        {
            String codiceSfdc = loopAsset.NE__ProdId__r.OB_Codice_sfdc__c;
            if ( ( loopAsset.NE__ProdID__r.RecordTypeId == PRODUCT_RT_POS && //  WN-98 Micol Ferrari <micol.ferrari@accenture.com>, 13/07/2019 - Change condition, RT from Prod not from Asset
                    !OB_UtilityConstants.POS_TERZI_UNATTENDED.equalsIgnoreCase( codiceSfdc ) ) ||
                    ( VISA_MASTERCARD.equalsIgnoreCase( codiceSfdc ) &&
                            !OB_UtilityConstants.SIA.equalsIgnoreCase( loopAsset.OB_Processor__c ) &&
                            loopAsset.NE__Root_Order_Item__c == null ) )
            {
                return false;
            }
        }
        return true;
    }

    /*******************************************************************************
    Purpose:    Method checks if related assets have proper values and changes can be saved
    Parameters: String inExternalSourceMappingId
    Returns:    Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek       14/06/2019      Created         NEXI-82
    1.1         Joanna Mielczarek       08/07/2019      Modified        NEXI-173 refactored code
    1.2         Joanna Mielczarek       09/07/2019      Modified        NEXI-176 added core method
    1.3         Joanna Mielczarek       19/07/2019      Modified        NEXI-225 change in param, logic conditions
    1.4         Joanna Mielczarek       07/08/2019      Modified        NEXI-262 modified conditions
    ********************************************************************************/
    private static Boolean checkConditionsForMCCNumber5541( String inExternalSourceMappingId )
    {
        List<Asset> activeAssets = getActiveAssetsForESM( inExternalSourceMappingId ); // NEXI-176 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 09/07/2019
        if ( activeAssets.isEmpty( ) )
        {
            return true;
        }

        for ( Asset loopAsset : activeAssets )
        {
            if ( loopAsset.NE__ProdId__r.RecordTypeId == PRODUCT_RT_POS ) // Antonio.vatrano wn 122 change recordtype 25/07/2019
            {
                if ( OB_UtilityConstants.POS_TERZI_UNATTENDED.equalsIgnoreCase( loopAsset.NE__ProdId__r.OB_Codice_sfdc__c ) &&
                        OB_UtilityConstants.START_SFDC.equalsIgnoreCase( loopAsset.NE__Bundle_Configuration__r.NE__ProdId__r.OB_Codice_sfdc__c ) &&
                        'Y'.equalsIgnoreCase( loopAsset.NE__Root_Order_Item__r.OB_enablement__c ) && VISA_MASTERCARD.equalsIgnoreCase( loopAsset.NE__Root_Order_Item__r.NE__ProdId__r.OB_Codice_sfdc__c ) )
                {
                    return false;
                }
            }
        }
        return true;
    }

    /*******************************************************************************
    Purpose:    Method for delete log request when user dont upload required documents
    Parameters: String logRequestId
    Returns: String

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek       14/06/2019      Created         NEXI-82
    1.1         Joanna Mielczarek       15/07/2019      Modified        NEXI-212 added catch statement, return string
    ********************************************************************************/
    @AuraEnabled
    public static String deleteLogRequest( String logRequestId )
    {
        try
        {
            OB_LogRequest__c logRequestToDelete = new OB_LogRequest__c( Id = logRequestId );
            delete logRequestToDelete;
            return '';
        } catch ( Exception ex )
        {
            System.debug( LoggingLevel.ERROR, '[EXC] Exception ' + ex.getMessage( ) + ' stacktrace ' + ex.getStackTraceString( ) );
            return '[EXC] Exception ' + ex.getMessage( ) + ' stacktrace ' + ex.getStackTraceString( );
        }
    }

    /*******************************************************************************
    Purpose:    Method checks if an any 'Visa/Mastercard' active Asset
                without root Order Item is related with given External Source Mapping
    Returns:    Boolean - true if the relationship exists

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Grzegorz Banach      04/07/2019         Created          NEXI-146
    ********************************************************************************/
    private static Boolean checkConditionsForGambling( String externalSourceMappingId )
    {
        List<ExternalSourceMapping__c> esmList =
        [
                SELECT Id,
                        OB_Service_Point_ID__c
                FROM ExternalSourceMapping__c
                WHERE Id = :externalSourceMappingId
                LIMIT 1
        ];

        if ( esmList.isEmpty( ) || esmList.get( 0 ).OB_Service_Point_ID__c == null )
        {
            return false;
        }

        List<Asset> assetList =
        [
                SELECT Id
                FROM Asset
                WHERE NE__Service_Point__c = :esmList.get( 0 ).OB_Service_Point_ID__c
                AND Name = :ASSET_NAME_VISA_MASTERCARD
                AND NE__Status__c = :OB_UtilityConstants.STATUS_ACTIVE
                AND NE__Root_Order_Item__c = null
                LIMIT 1
        ];

        if ( assetList.isEmpty( ) )
        {
            return false;
        }
        return true;
    }

    /*******************************************************************************
    Purpose:    Method starts Approval Process
    Parameters: String logRequestId

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Grzegorz Banach      08/07/2019         Created          NEXI-146
    ********************************************************************************/
    @AuraEnabled
    public static Boolean startApprovalProcess( String logRequestId )
    {
        return OB_Util006_MaintenanceAnagrafica.startMaintenanceApprovalProcessIfNeeded( new List<String> {logRequestId}, OB_Util006_MaintenanceAnagrafica.MAINTENANCE_TYPE_MCC );
    }

    /*******************************************************************************
    Purpose:    Method check condition when MCC is selected a PO118
    Parameters: ExternalSourceMapping__c externalSourceMapping
    Returns:    Boolean true if all condition is met

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek       09/07/2019      Created         NEXI-175
    ********************************************************************************/
    private static Boolean checkConditionsForPO118( ExternalSourceMapping__c externalSourceMapping )
    {
        List<ExternalSourceMapping__c> esmList = [ SELECT OB_Service_Point_ID__c, OB_MCC__c FROM ExternalSourceMapping__c WHERE Id = :externalSourceMapping.Id LIMIT 1 ];
        if ( esmList.isEmpty( ) )
        {
            return false;
        }

        List<Asset> assetList =
        [
                SELECT Id, NE__ProdId__r.RecordTypeId
                FROM Asset
                WHERE NE__Service_Point__c = :esmList.get( 0 ).OB_Service_Point_ID__c
                AND NE__Status__c = :OB_UtilityConstants.STATUS_ACTIVE
                AND NE__Root_Order_Item__c = null
        ];

        if ( assetList.isEmpty( ) )
        {
            return false;
        }

        List<NE__Lov__c> lovList =
        [
                SELECT Id
                FROM NE__Lov__c
                WHERE NE__Type__c = :OB_Maintenance_EditServicePoint_Ctr.MCC
                AND NE__Value2__c = :externalSourceMapping.OB_MCC__c
                AND NE__Value1__c = :OB_Maintenance_EditServicePoint_Ctr.PO118
        ];

        if ( lovList.isEmpty( ) )
        {
            return false;
        }

        Id eCommerceRT = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( 'eCommerce' ).getRecordTypeId( );
        Boolean atLeastOneAssetECommerce = false;
        for ( Asset assetItem : assetList )
        {
            if ( assetItem.NE__ProdId__r.RecordTypeId == eCommerceRT )
            {
                atLeastOneAssetECommerce = true;
                break;
            }
        }
        return atLeastOneAssetECommerce;
    }

    /*******************************************************************************
    Purpose:    Method to update OB_LogRequest__c.OB_Status__c to in Attesa
    Parameters: String inLogRequestId
    Retrurn: Boolean isUpdated

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Marta Stempien          08/08/2019      Created         NEXI-259
   ********************************************************************************/
    @auraEnabled
    public static Boolean confirmUploadedDocumentsSetInAttesaStatus( String inLogRequestId )
    {
        List<OB_LogRequest__c> logRequests = [ SELECT Id FROM OB_LogRequest__c WHERE Id = :inLogRequestId LIMIT 1 ];
        if ( !logRequests.isEmpty( ) )
        {
            logRequests.get( 0 ).OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA;
        }
        try
        {
            update logRequests;
            return true;
        } catch ( DmlException eException )
        {
            System.debug( LoggingLevel.ERROR, '[EXC] Exception ' + eException.getMessage( ) + ' stacktrace ' + eException.getStackTraceString( ) );
            return false;
        }
    }

    /*******************************************************************************
    Purpose:    Method to save log without docs
    Parameters: OB_LogReqeust__c is


    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Elena Preteni           13/07/2019      Created         WN-101
    ********************************************************************************/
    @AuraEnabled
    public static void saveDraft( String logId )
    {
        String toReturn = '@@@ update Draft';
        try
        {
            //Start antonio.vatrano 17/07/2019 logic to show BTN Upload documents
            OB_LogRequest__c logrequest = [ select id,OB_Status__c, OB_Save_as_Draft__c from OB_LogRequest__c where id = :logId limit 1 ];
            logrequest.OB_Status__c = System.Label.OB_MAINTENANCE_LOGREQUEST_STATUS_DRAFT;
            logrequest.OB_Save_as_Draft__c = true;
            update logrequest ;
            //End antonio.vatrano 17/07/2019 logic to show BTN Upload documents

        } catch ( Exception e )
        {
            toReturn = '@@@ not update Draft';
        }
        System.debug( toReturn );
    }

    /*******************************************************************************
    Purpose:    Method checks if related assets have proper values and changes can be saved
    Parameters: String inExternalSourceMappingId
    Returns:    Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       15/07/2019      Created         NEXI-209
    1.1         Joanna Mielczarek       16/07/2019      Modified        NEXI-212 changed returns from variables to simple values
    1.2         Joanna Mielczarek       17/07/2019      Modified        NEXI-225 removed ! from condition
    1.3         Joanna Mielczarek       19/07/2019      Modified        NEXI-225 changed logic of looking for Assets
    ********************************************************************************/
    private static Boolean checkConditionsForMCCAlberghi( String inExternalSourceMappingId )
    {
        List<Asset> activeAssets = getActiveAssetsForESM( inExternalSourceMappingId );

        if ( activeAssets.isEmpty( ) )
        {
            return true;
        }

        for ( Asset loopAsset : activeAssets )
        {
            //Antonio.vatrano wn 122 25/07/2019 change condition on recordType
            if ( loopAsset.NE__ProdId__r.RecordTypeId == PRODUCT_RT_VAS && loopAsset.NE__Root_Order_Item__c == null &&
                    CODICE_SFDC_ALB_AUTO.equalsIgnoreCase( loopAsset.NE__ProdId__r.OB_Codice_sfdc__c ) ) // NEXI-225 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 17/07/2019
            {
                return false;
            }
        }
        return true;
    }

    /*******************************************************************************
    Purpose:    Method check set true to field LogRquest.PO118MoTo in case of maintenance
                of MCC AND Old_MCC != PO118 AND New_MCC = PO118 AND there is at least one asset
                (status != disconnected) with product recordtype = ‘MoTo’  check on the assets related
    Parameters: ServicePointWrapper externalSourceMappings, ServicePointWrapper oldExternalSourceMappings
    Returns:    Map<String,String>
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Michal Targiel      22/07/2019         Created           NEXI-232
********************************************************************************/
    public static Map<String, String> logRequestPO118MoToSet( ServicePointWrapper externalSourceMappings, ServicePointWrapper oldExternalSourceMappings )
    {
        if ( externalSourceMappings == null || oldExternalSourceMappings == null )
        {
            return new Map<String, String>
            {
                    OB_UtilityConstants.OB_PO118_MOTO => 'false'
            };
        }
        Integer products = 0;
        if ( checkDifferenceMCCinOldAndNewExternalSourceMapping( externalSourceMappings.listOfSourceMapping, oldExternalSourceMappings.listOfSourceMapping ) )
        {
            products =
            [
                    SELECT count( )
                    FROM NE__Product__c
                    WHERE Id IN
                    (
                            Select NE__ProdId__c
                            FROM asset
                            WHERE NE__Service_Point__c = :externalSourceMappings.pv.Id
                            AND Status != :OB_UtilityConstants.ASSET_STATUS_DISCONNECTED
                    )
                    AND RecordType.Name = :OB_UtilityConstants.PRODUCT_RECORDTYPE_MOTO
            ];
        }
        if ( products > 0 )
        {
            return new Map<String, String>
            {
                    OB_UtilityConstants.OB_PO118_MOTO => 'true'
            };
        }
        return new Map<String, String>
        {
                OB_UtilityConstants.OB_PO118_MOTO => 'false'
        };
    }

    /*******************************************************************************
    Purpose:    Method check set true to field LogRquest.PO118MoTo in case of maintenance
    of MCC AND Old_MCC != PO118 AND New_MCC = PO118 AND there is at least one asset
    (status != disconnected) with product recordtype = ‘MoTo’  check on the assets related
    Parameters: List<ExternalSourceMapping__c> external, List<ExternalSourceMapping__c> oldExternal
    Returns: Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Michal Targiel      23/07/2019         Created           NEXI-232
    ********************************************************************************/
    private static Boolean checkDifferenceMCCinOldAndNewExternalSourceMapping( List<ExternalSourceMapping__c> newExternalSource, List<ExternalSourceMapping__c> oldExternalSource )
    {
        List<String> oldMCC = new List<String>( );
        List<String> newMCC = new List<String>( );

        for ( ExternalSourceMapping__c oldExternal : oldExternalSource )
        {
            oldMCC.add( oldExternal.OB_MCC__c );
        }
        for ( ExternalSourceMapping__c newExternal : newExternalSource )
        {
            newMCC.add( newExternal.OB_MCC__c );
        }

        List<NE__Lov__c> oldNELov = createListMCCTypesFromNELovC( oldMCC );
        List<NE__Lov__c> newNELov = createListMCCTypesFromNELovC( newMCC );

        for ( ExternalSourceMapping__c newExternal : newExternalSource )
        {
            for ( ExternalSourceMapping__c oldExternal : oldExternalSource )
            {
                if ( newExternal.Id.equals( oldExternal.Id ) )
                {
                    if ( checkForO118( newNELov, newExternal.OB_MCC__c ) && !checkForO118( oldNELov, oldExternal.OB_MCC__c ) )
                    {
                        return true;
                    }
                    break;
                }
            }
        }
        return false;
    }

    /*******************************************************************************
    Purpose: Select NE__Lov__c for checkDifferenceMCCinOldAndNewExternalSourceMapping method
    is need to select new list and the old list of Lov to check MCC.
    Parameters: List<String> MCCList
    Returns:  List<NE__Lov__c>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Michal Targiel      26/07/2019         Created           NEXI-232
    ********************************************************************************/
    private static List<NE__Lov__c> createListMCCTypesFromNELovC( List<String> MCCList )
    {
        if ( MCCList.isEmpty( ) )
        {
            return new NE__Lov__c[] {};
        }
        return
        [
                SELECT NE__Value1__c, NE__Value2__c
                FROM NE__LOV__c
                WHERE NE__Value2__c
                        IN :MCCList
                AND NE__Type__c = 'MCC'
        ];
    }

    /*******************************************************************************
    Purpose: Check that MCC is equals to PO118 in NE__Lov__c list.
    Parameters: List<NE__Lov__c> MCCList, String MCC
    Returns:  Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Michal Targiel      26/07/2019         Created           NEXI-232
    ********************************************************************************/
    private static Boolean checkForO118( List<NE__Lov__c> MCCList, String MCC )
    {
        if ( MCCList.isEmpty( ) || String.isBlank( MCC ) )
        {
            return false;
        }

        for ( NE__Lov__c nelovc : MCCList )
        {
            if ( OB_UtilityConstants.MCC_LOV_PO118.equalsIgnoreCase( nelovc.NE__Value1__c ) && MCC.equalsIgnoreCase( nelovc.NE__Value2__c ) )
            {
                return true;
            }
        }
        return false;
    }

    /*******************************************************************************
    Purpose: Method generates ServicePointWrapper indicating error state
    Parameters: String inErrorMessage
    Returns:  ServicePointWrapper

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Grzegorz Banach      21/08/2019         Created           NEXI-261
    ********************************************************************************/
    private static ServicePointWrapper generateErrorWrapper( String inErrorMessage )
    {
        ServicePointWrapper wrapper = new ServicePointWrapper( );
        wrapper.errorOccurred = true;
        wrapper.errorMessage = inErrorMessage;
        return wrapper;
    }

    /*******************************************************************************
    Purpose: Method to check existing log request
    Parameters: MAps List<String> oldData, List<String> newData
    Returns:  ServicePointWrapper

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Elena Preteni           10/09/2019      Created         log reqeust
    ********************************************************************************/
    private static void checkExistence( List<String> oldData, List<String> newData )
    {
        Map<String, String> tmpMap = new Map<String, String>( );
        OB_Maintenance_Helper.CheckboxesWrapper checkboxFields = new OB_Maintenance_Helper.CheckboxesWrapper( ); // NEXI-298 Marta Stempien <marta.stempien@accenture.com> 13/09/2019 Move declaration out of try-catch
        //11/09/19 elena preteni - adding try catch
        try
        {
            Map<String, Object> oldMapGeneral = ( Map<String, Object> ) JSON.deserializeUntyped( oldData.get( 0 ) );
            Map<String, Object> newMapGeneral = ( Map<String, Object> ) JSON.deserializeUntyped( newData.get( 0 ) );
            Map<String, Object> newPV = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( newMapGeneral.get( 'pv' ) ) );
            String newOB_Opening_Time = ( String ) newPV.get( 'OB_Opening_Time__c' );
            String newOB_Break_End_Time = ( String ) newPV.get( 'OB_Break_End_Time__c' );
            String newOB_Break_Start_Time = ( String ) newPV.get( 'OB_Break_Start_Time__c' );
            String newOB_Ending_Time = ( String ) newPV.get( 'OB_Ending_Time__c' );
            newPV.put( 'OB_Opening_Time__c', null );
            newPV.put( 'OB_Break_End_Time__c', null );
            newPV.put( 'OB_Break_Start_Time__c', null );
            newPV.put( 'OB_Ending_Time__c', null );

            newMapGeneral.put( 'pv', ( Object ) newPV );
            Map<String, Object> oldPV = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( oldMapGeneral.get( 'pv' ) ) );
            String oldOB_Opening_Time = ( String ) oldPV.get( 'OB_Opening_Time__c' );
            String oldOB_Break_End_Time = ( String ) oldPV.get( 'OB_Break_End_Time__c' );
            String oldOB_Break_Start_Time = ( String ) oldPV.get( 'OB_Break_Start_Time__c' );
            String oldOB_Ending_Time = ( String ) oldPV.get( 'OB_Ending_Time__c' );
            oldPV.put( 'OB_Opening_Time__c', null );
            oldPV.put( 'OB_Break_End_Time__c', null );
            oldPV.put( 'OB_Break_Start_Time__c', null );
            oldPV.put( 'OB_Ending_Time__c', null );
            oldMapGeneral.put( 'pv', ( Object ) oldPV );
            ServicePointWrapper simpleNew = ( ServicePointWrapper ) JSON.deserialize( JSON.serialize( newMapGeneral ), ServicePointWrapper.class );
            ServicePointWrapper simpleOld = ( ServicePointWrapper ) JSON.deserialize( JSON.serialize( oldMapGeneral ), ServicePointWrapper.class );
            map<SObject, SObject> mapDifference = generateDiffernenceMap( simpleOld, simpleNew );
            OB_Maintenance_Helper.serializeObject reducedOldData = new OB_Maintenance_Helper.serializeObject( );
            OB_Maintenance_Helper.serializeObject reducedNewData = new OB_Maintenance_Helper.serializeObject( );
            OB_Maintenance_Helper.generateDifferenceObject( mapDifference, reducedOldData, reducedNewData, checkboxFields );
            String accountId = retriveAccountId( simpleOld.pv );
            tmpMap.put( 'OB_AccountId__c', accountId );
            tmpMap.put( 'OB_ServicePointId__c', simpleOld.pv.Id );
        }
        //NEXI-298 Marta Stempien <marta.stempien@accenture.com> 13/09/2019 Moved catch up to exclude thrown LogRequestExistsException
        catch ( Exception e )
        {
            System.debug( LoggingLevel.ERROR, +e.getMessage( ) + ' at line: ' + e.getLineNumber( ) + ' stack trace: ' + e.getStackTraceString( ) );
        }
        if ( checkboxFields.isSuccess )
        {
            String isSettlementProcedureString = ( checkboxFields.isSettlementProcedure ) ? 'true' : 'false';
            tmpMap.put( 'OB_Settlement_Procedure__c', isSettlementProcedureString );
            tmpMap.put( 'OB_ChangeServicePointData__c', string.valueOf( checkboxFields.changeServicePointData ) );

            Map<String, String> requestAlreadyExist = OB_Maintenance_Helper.checkRequestAlreadyExist_ServicePoint( tmpMap );
            if ( requestAlreadyExist.get( 'message' ) != null )
            {
                throw new LogRequestExistsException( requestAlreadyExist.get( 'message' ) );
            }
        }
        //NEXI-298 Marta Stempien <marta.stempien@accenture.com> 13/09/2019 Catch moved up
    }

    /*******************************************************************************
    Purpose: Method compares contacts from front-end if they have at least one difference
    Parameters: Contact oldLocationReferent, Contact newLocationReferent
    Returns:  Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Grzegorz Banach         10.10.2019      CREATED         NEXI-361
    ********************************************************************************/
    private static Boolean existsAtLeastOneDifferenceForContact( Contact oldLocationReferent, Contact newLocationReferent )
    {
        for ( Schema.sObjectField fieldName : LOCATION_REFERENTS_COMPARE_FIELDS )
        {
            String oldFieldValue = String.valueOf( oldLocationReferent.get( fieldName ) );
            String newFieldValue = String.valueOf( newLocationReferent.get( fieldName ) );
            if ( String.isBlank(oldFieldValue) && String.isBlank(newFieldValue))
            {
                continue;
            }
            if ( String.isBlank(newFieldValue) || !newFieldValue.equals( oldFieldValue ) )
            {
                return true;
            }
        }
        return false;
    }
}