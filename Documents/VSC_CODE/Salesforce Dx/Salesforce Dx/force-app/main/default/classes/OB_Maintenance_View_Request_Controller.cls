public without sharing class OB_Maintenance_View_Request_Controller
{
    //NEXI-91 grzegorz.banach@accenture.com 19/06/2019 START
    private static String LOG_REQUEST_TYPE_MAINTENANCE_OF_DATA_OF_ACTUAL_OWNERS = 'Maintenance of data of actual owners';
    private static String LOG_REQUEST_TYPE_MAINTENANCE_OF_LOCATION_REFERENTS = 'Maintenance of location referents';
    //NEXI-91 grzegorz.banach@accenture.com 19/06/2019 STOP
    public static Final String LOG_REQUEST_TYPE_MAINTENANCE_OF_ESECUTORE = 'Maintenance of esecutore';//NEXI-149 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 01/07/2019
    public static final String LOG_REQUEST_TYPE_OTHER = 'Other';//NEXI-187 Grzegorz Banach<grzegorz.banach@accenture.com> 16/07/2019
    private static String EXTERNAL_SOURCE_MAPPING = 'ExternalSourceMapping__c';//NEXI-240 Marlena Lukomska-Rogala <m.lukomska-rogala@accenture.com> 1/08/2019
    // class used as wrapper into the lightning component
    public class returnWrapper
    {
        @AuraEnabled
        public boolean errorOccurred ; // true if an error occurs
        @AuraEnabled
        public string errorMessage ; // if errorOccurred = true, this field contains the error message
        @AuraEnabled
        public string requestStatus ; // the status of logrequest
        @AuraEnabled
        public boolean isInternalUser ; // true if the user has  a Salesforce License
        @AuraEnabled
        public String logRequestType;//NEXI-91 grzegorz.banach@accenture.com 19/06/2019
        @AuraEnabled
        public list<ObjectWrapper> oldData;    // list of object that represent a fields, contains the oldobject data
        @AuraEnabled
        public list<ObjectWrapper> newData;
        //NEXI-240 Marlena Lukomska-Rogala <m.lukomska-rogala@accenture.com> 31/07/2019 START
        @AuraEnabled // NEXI-274 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 26/08/2019
        public boolean changeServicePoint;
        @AuraEnabled // NEXI-274 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 26/08/2019
        public boolean changeMerchant;
        //NEXI-240 Marlena Lukomska-Rogala <m.lukomska-rogala@accenture.com> 31/07/2019 STOP
        // NEXI-274 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 27/08/2019 START
        @AuraEnabled
        public List<CodesWrapper> codesWrappers;
        // NEXI-274 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 27/08/2019 STOP
        public returnWrapper( )
        {
            this.logRequestType = LOG_REQUEST_TYPE_OTHER;//NEXI-187 Grzegorz Banach<grzegorz.banach@accenture.com> 16/07/2019
            this.oldData = new list<ObjectWrapper>( );
            this.newData = new list<ObjectWrapper>( );
            this.errorOccurred = false;
            this.errorMessage = '' ;
            // NEXI-274 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 26/08/2019 START
            this.changeServicePoint = false;
            this.changeMerchant = false;
            this.codesWrappers = new List<CodesWrapper>( );
            // NEXI-274 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 26/08/2019 STOP
        }
    }

    public class ObjectWrapper
    {
        //NEXI-91 grzegorz.banach@accenture.com 24/06/2019 START
        @AuraEnabled
        public String objectId;
        //NEXI-91 grzegorz.banach@accenture.com 24/06/2019 STOP
        @auraEnabled
        public string objectLabel;
        @AuraEnabled
        public string objecType;

        //	START 	micol.ferrari 19/12/2018
        @AuraEnabled
        public string objectName;
        //	END 	micol.ferrari 19/12/2018

        //NEXI-91 grzegorz.banach@accenture.com 18/06/2019 START
        @AuraEnabled
        public String recordTypeName;
        //NEXI-91 grzegorz.banach@accenture.com 18/06/2019 STOP

        @AuraEnabled
        public list<rowWrapper> listOfRow;
        public ObjectWrapper( )
        {
            this.objecType = '';
            this.listOfRow = new list<rowWrapper>( );
        }
    }

    // NEXI-274 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 27/08/2019 START
    public class CodesWrapper
    {
        @AuraEnabled
        public String recordId;
        @AuraEnabled
        public String companyCode;
        @AuraEnabled
        public String servicePointCode;
        @AuraEnabled
        public String source;

        public CodesWrapper( )
        {
            this.recordId = '';
            this.companyCode = '';
            this.servicePointCode = '';
            this.source = '';
        }
    }
    // NEXI-274 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 27/08/2019 STOP

    public class rowWrapper
    {
        @AuraEnabled
        public string label;
        @AuraEnabled
        public Object value;
        @AuraEnabled
        public string apiname;
        @AuraEnabled
        public string datatype;
        @AuraEnabled
        public Integer sequence;
    }

    /*
      *	author : Elena Preteni
      * 	Date : 21/06/2019
      *	Description : Coba Log Reqeust Wrapper
      */
    public class CobaWrapper
    {
        @AuraEnabled
        public Boolean isCoba;
        @AuraEnabled
        public string termId;
        @AuraEnabled
        public Object racsia;
        @AuraEnabled
        public string oldIban;
        @AuraEnabled
        public string newIban;
        public CobaWrapper( )
        {
            termId = '';
            racsia = '';
            oldIban = '';
            newIban = '';
        }

    }
    /*
    *	author : claudio Quaranta
    * 	Date : 28/11/2018
    *	Description : method used to reject a logrequest
    *	input : logRequestId --> OB_LogRequest__c record id
                rejectReason --> string inserted into the UI, mapped into the OB_RejectReason__c field
        output :  if empty no error occurs, otherwise an error to show in page.
    */


    @auraEnabled
// Start AV Defect #00001577 switch field OB_RejectReason__c --> OB_Rejection_Comments__c
    public static string rejectLogRequest( id logRequestId, string rejectComments )
    {
        string error = '';
        try
        {
            // retriving record
            OB_LogRequest__c request = [ select id,OB_Status__c,OB_RejectReason__c,OB_Rejection_Comments__c from OB_LogRequest__c where id = :logRequestId limit 1 ];
            request.OB_Rejection_Comments__c = rejectComments;
// End AV Defect #00001577 switch field OB_RejectReason__c --> OB_Rejection_Comments__c
            request.OB_Status__c = System.Label.OB_MAINTENANCE_LOGREQUEST_STATUS_REJECTED;
            update( request );

        } catch ( Exception e )
        {
            error = e.getStackTraceString( );
        }
        return error;
    }

    //	START 	micol.ferrari 24/12/2018
    @auraEnabled
    public static String acceptLogRequestFinal( Id logRequestId )
    {
        Savepoint sp;
        //NEXI-149 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 02/07/2019 Start
        if ( !Test.isRunningTest( ) )
        {
            sp = Database.setSavepoint( );
        }
        //NEXI-149 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 02/07/2019 Stop
        string toReturn = '';
        try
        {
            OB_LogRequest__c request = [ select id,OB_ReducedOldData__c,OB_ReducedNewData__c,OB_Status__c,OB_AccountId__c,OB_ServicePointId__c,OB_ABI__c from OB_LogRequest__c where id = :logRequestId limit 1 ];
            system.debug( 'request -->' + request );

            //	START 	micol.ferrari 18/12/2018
            String oB_ReducednewData = '';
            String newOB_Opening_Time = '';
            String newOB_Break_End_Time = '';
            String newOB_Break_Start_Time = '';
            String newOB_Ending_Time = '';

            Map<String, Object> mapReducednewData = ( Map<String, Object> ) JSON.deserializeUntyped( request.OB_ReducednewData__c );
            system.debug( '## mapReducednewData: ' + mapReducednewData );
            system.debug( '## obj: ' + mapReducednewData.get( 'obj' ) );
            List<Object> newlistOfObjs = ( List<Object> ) JSON.deserializeUntyped( JSON.serialize( mapReducednewData.get( 'obj' ) ) );
            system.debug( '## newlistOfObjs: ' + newlistOfObjs );
            // Elena Preteni 11/01/2019 update Asset when External Source Mapping updated
            Map<String, Object> mapReducedOldData = ( Map<String, Object> ) JSON.deserializeUntyped( request.OB_ReducedOldData__c );
            system.debug( 'mapReducedOldData --> ' + mapReducedOldData );
            List<Object> oldListOfObjs = ( List<Object> ) JSON.deserializeUntyped( JSON.serialize( mapReducedOldData.get( 'obj' ) ) );
            system.debug( 'oldlistOfObjs --> ' + oldListOfObjs );
            List<Map<String, Object>> oldListOfMaps = new List<Map<String, Object>>( );
            //START francesca.ribezzi 18/03/19 adding a new set of external source mapping obj to update:
            Set<ExternalSourceMapping__c> esmSetToUpdate = new Set<ExternalSourceMapping__c>( );
            //adding monetica and equens lists:
            Set<ExternalSourceMapping__c> moneticaList = new Set<ExternalSourceMapping__c>( );
            Set<ExternalSourceMapping__c> equensList = new Set<ExternalSourceMapping__c>( );
            //END
            for ( Object obj : oldListOfObjs )
            {
                oldListOfMaps.add( ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( obj ) ) );
            }
            system.debug( 'oldlistOfMaps --> ' + oldListOfMaps );
            List<String> idSPList = new List<String>( );
            for ( Map<String, Object> singlemap : oldListOfMaps )
            {
                if ( singlemap.containsKey( 'attributes' ) )
                {
                    Map<String, Object> attributesmap = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( singlemap.get( 'attributes' ) ) );
                    system.debug( 'attributesmap: ' + attributesmap );
                    if ( attributesmap.containsKey( 'type' ) && attributesmap.get( 'type' ) == 'ExternalSourceMapping__c' )
                    {
                        idSPList.add( String.valueOf( singlemap.get( 'Id' ) ) );
                    }
                }
            }
            // Elena Preteni 11/01/2019 update Asset when External Source Mapping updated
            List<Map<String, Object>> newlistOfMaps = new List<Map<String, Object>>( );
            List<Map<String, Object>> newupdatedListOfMaps = new List<Map<String, Object>>( );
            for ( Object obj : newlistOfObjs )
            {
                newlistOfMaps.add( ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( obj ) ) );
            }
            system.debug( '## newlistOfMaps: ' + newlistOfMaps );
            for ( Map<String, Object> singlemap : newlistOfMaps )
            {
                if ( singlemap.containsKey( 'attributes' ) )
                {
                    Map<String, Object> attributesmap = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( singlemap.get( 'attributes' ) ) );
                    system.debug( '## attributesmap: ' + attributesmap );

                    //------------------------------------------------------------------------------------------------------
                    //	START - ONLY IF SERVICE POINT, BECAUSE OF TIME FIELDS
                    //------------------------------------------------------------------------------------------------------
                    if ( attributesmap.containsKey( 'type' ) && attributesmap.get( 'type' ) == 'NE__Service_Point__c' )
                    {
                        if ( singlemap.containsKey( 'OB_Opening_Time__c' ) )
                        {
                            newOB_Opening_Time = ( String ) singlemap.get( 'OB_Opening_Time__c' );
                            singlemap.put( 'OB_Opening_Time__c', null );
                        }
                        else
                        {
                            newOB_Opening_Time = 'SKIP';
                        }
                        if ( singlemap.containsKey( 'OB_Break_End_Time__c' ) )
                        {
                            newOB_Break_End_Time = ( String ) singlemap.get( 'OB_Break_End_Time__c' );
                            singlemap.put( 'OB_Break_End_Time__c', null );
                        }
                        else
                        {
                            newOB_Break_End_Time = 'SKIP';
                        }
                        if ( singlemap.containsKey( 'OB_Break_Start_Time__c' ) )
                        {
                            newOB_Break_Start_Time = ( String ) singlemap.get( 'OB_Break_Start_Time__c' );
                            singlemap.put( 'OB_Break_Start_Time__c', null );
                        }
                        else
                        {
                            newOB_Break_Start_Time = 'SKIP';
                        }
                        if ( singlemap.containsKey( 'OB_Ending_Time__c' ) )
                        {
                            newOB_Ending_Time = ( String ) singlemap.get( 'OB_Ending_Time__c' );
                            singlemap.put( 'OB_Ending_Time__c', null );
                        }
                        else
                        {
                            newOB_Ending_Time = 'SKIP';
                        }
                    }
                    //------------------------------------------------------------------------------------------------------
                    //	END - ONLY IF SERVICE POINT, BECAUSE OF TIME FIELDS
                    //------------------------------------------------------------------------------------------------------
                }
                newupdatedListOfMaps.add( singlemap );
            }

            List<Object> newupdatedListOfObjs = ( List<Object> ) JSON.deserializeUntyped( JSON.serialize( newupdatedListOfMaps ) );
            mapReducednewData.put( 'obj', ( Object ) newupdatedListOfObjs );

            oB_ReducednewData = JSON.serialize( mapReducednewData );
            system.debug( '## oB_ReducednewData: ' + oB_ReducednewData );

            list<SObject> newData ;

            if ( !string.isblank( oB_ReducednewData ) )
            {
                newData = ( ( OB_Maintenance_Helper.serializeObject ) JSON.deserialize( oB_ReducednewData, OB_Maintenance_Helper.serializeObject.class ) ).obj;
            }
            else
            {
                toReturn = System.Label.OB_MAINTENANCE_LOGREQUEST_NODATA;
            }
            //	END 	micol.ferrari 18/12/2018

            system.debug( 'newData' + newData );

            //	START 	micol.ferrari 19/12/2018
            list<SObject> newDataUpdated = new list<SObject>( );
            NE__Service_Point__c currentSP = new NE__Service_Point__c( );
            for ( SObject currentData : newData )
            {
                Schema.SObjectType expected = Schema.NE__Service_Point__c.getSObjectType( );
                if ( currentData.getSObjectType( ) == expected )
                {
                    currentSP = ( NE__Service_Point__c ) currentData;
                    if ( newOB_Opening_Time != 'SKIP' )
                    {
                        currentSP.OB_Opening_Time__c = ParseTime( newOB_Opening_Time );
                    }
                    if ( newOB_Ending_Time != 'SKIP' )
                    {
                        currentSP.OB_Ending_Time__c = ParseTime( newOB_Ending_Time );
                    }
                    if ( newOB_Break_End_Time != 'SKIP' )
                    {
                        currentSP.OB_Break_End_Time__c = ParseTime( newOB_Break_End_Time );
                    }
                    if ( newOB_Break_Start_Time != 'SKIP' )
                    {
                        currentSP.OB_Break_Start_Time__c = ParseTime( newOB_Break_Start_Time );
                    }

                    SObject currentSPSobject = ( SObject ) currentSP;
                    newDataUpdated.add( currentSPSobject );
                }
                else
                {
                    newDataUpdated.add( currentData );
                }
            }
            system.debug( '##newDataUpdated' + newDataUpdated );
            //	END 	micol.ferrari 19/12/2018

            //	START 	micol.ferrari 19/12/2018
            // splitting the object to insert and to update
            //	Simone Misani 17/12/2019 START 
            list<SObject> newDataUpdatedUtil = new list<SObject>( );
            list<SObject> toInsert = new list<SObject>( );
            Id esecutoreRT = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Esecutore').getRecordTypeId();
            Id isNewSpReferenteRT = Schema.SObjectType.Contact.getRecordTypeInfosByName( ).get( 'Referente Punto Vendita' ).getRecordTypeId( );
            Id titolareRT = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Titolare Effettivo').getRecordTypeId();
            for ( Integer i = 0; i < newDataUpdated.size( ); i++ )
            {//SObject sobj : newData){
                //francesca.ribezzi 07/11/19 - PROD-39 - checking if is new esecutore cause the contact insert is in logRequest trigger already - avoiding duplicates.
                //giovanni spinelli 08/01/2020 - PROD-294 - start
                Boolean isNewEsecutore 		= false;
                Boolean isNewSpReferente 	= false;
                Boolean isNewTitolare 		= false; 
                Boolean isExt = newDataUpdated.get(i) instanceof ExternalSourceMapping__c;
                if( isExt == false  ){
                    isNewEsecutore      = ( ( newDataUpdated.get(i).get('RecordTypeId') == esecutoreRT)           && newDataUpdated.get(i).get( 'Id') == null );
                    isNewSpReferente    = ( ( newDataUpdated.get(i).get('RecordTypeId') == isNewSpReferenteRT)    && newDataUpdated.get(i).get( 'Id') == null );
                    isNewTitolare       = ( ( newDataUpdated.get(i).get('RecordTypeId') == titolareRT)            && newDataUpdated.get(i).get( 'Id') == null );
                }
                //giovanni spinelli 08/01/2020 - PROD-294 - end 
                if ( String.isBlank( ( string ) newDataUpdated.get( i ).get( 'Id' ) ) && String.isNotBlank( ( string ) newDataUpdated.get( i ).get( 'LastName' ) ) )
                {
                     if(!isNewEsecutore && !isNewTitolare && !isNewSpReferente){
                        toInsert.add( newDataUpdated.get( i ) );
                    }
                }
                else
                {
                    newDataUpdatedUtil.add( newDataUpdated.get( i ) );
                }

            }
             //	Simone Misani 17/12/2019 END 
            newDataUpdated = new list<SObject>( );
            newDataUpdated.addAll( newDataUpdatedUtil );
            //	END 	micol.ferrari 19/12/2018

            // preparing the savepoint

            //	START 	micol.ferrari 19/12/2018
            system.debug( 'object to update is ' + newDataUpdated );
            system.debug( 'object to insert is ' + toInsert );
            List<Id> idContactInsert = new List<Id>( );
            if ( !toInsert.isempty( ) )
            {
                System.debug( 'INSERT' );
                Database.insert( toInsert, true );
                //giovanni spinelli - after insert contacts, save id in a list
                for ( SObject o : toInsert )
                {
                    idContactInsert.add( o.id );
                }
            }
            System.debug( 'idContactInsert: ' + idContactInsert );
            //	START 	elena.preteni -> only for service point update
            Id servicePointResponsibleType = Schema.SObjectType.Contact.getRecordTypeInfosByName( ).get( 'Referente Punto Vendita' ).getRecordTypeId( );
            Id administrativeResponsibleType = Schema.SObjectType.Contact.getRecordTypeInfosByName( ).get( 'Responsabile Amministrativo' ).getRecordTypeId( );
            Id technicalReferentType = Schema.SObjectType.Contact.getRecordTypeInfosByName( ).get( 'Referente Tecnico' ).getRecordTypeId( );
            System.debug( 'administrativeResponsibleType --> ' + administrativeResponsibleType + '  technicalReferentType-->' + technicalReferentType );

            //select contacts with lookup with sp
            List<Contact> referents =
            [
                    SELECT Id,RecordTypeId, LastName,Name
                    FROM Contact
                    WHERE AccountId = :request.OB_AccountId__c AND Id IN:idContactInsert AND OB_Contact_State__c = 'Active' AND RecordTypeId in (:technicalReferentType, :administrativeResponsibleType, :servicePointResponsibleType)
            ];//AND CreatedDate = TODAY
            system.debug( 'referents -->' + referents );
            Map<String, String> referentRecordType = new Map<String, String>( );
            for ( Contact referent : referents )
            {
                referentRecordType.put( referent.RecordTypeId, referent.Id );
            }
            //	END 	elena.preteni -> only for service point update
            // Elena Preteni 11/01/2019 update Asset when External Source Mapping updated
            //start giovanni spinelli <spinelli.giovanni@accenture.com> add field to filter query with record type = standard PRODOB-390
			String Standard = OB_UtilityConstants.RTASSETSTANDARD;
            List<Asset> assets =
            [
                    SELECT id,
                            NE__Service_Point__c,
                            NE__Status__c,
                            OB_ABI__c,
                            OB_ProposerABI__r.OB_ABI__c,
                            OB_GT__c,
                            OB_Processor__c,
                            OB_CustomerCode__c,
                            OB_CompanyCode__c,
                            OB_ServicePointCode__c,
                            OB_ShopCode__c,
                            OB_ShopSign__c,
                            OB_ReceiptHeader__c,
                            OB_ReceiptCity__c
                    FROM Asset
                    WHERE RecordType.DeveloperName =: Standard AND NE__Service_Point__c = :request.OB_ServicePointId__c
            ];
            //start giovanni spinelli <spinelli.giovanni@accenture.com> add field to filter query with record type = standard PRODOB-390

            //SIMONE Misani 21/05/2019 RI-60	OB_ProposerABI__r.OB_ABI__c =:request.OB_ABI__c comment for Cross-abi

            List<ExternalSourceMapping__c> esmListFromSfdc =
            [
                    SELECT Id,
                            OB_ShopSign__c,
                            OB_ReceiptHeader__c,
                            OB_ReceiptCity__c,
                            // NEXI-253 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 07/08/2019 removed MCC fields
                            OB_ServicePointCodeShopCode__c,
                            OB_CustomerCodeClientCode__c,
                            OB_Conventioncode__c
                    FROM ExternalSourceMapping__c
                    WHERE OB_Service_Point_ID__c = :request.OB_ServicePointId__c
            ];//AND id in :idSPList - francesca.ribezzi 18/03/19 commentata seconda condizione
            //END
            Set<Asset> assetsToUpdateSet = new Set<Asset>( );
            List<Asset> assetsToUpdate = new List<Asset>( );
            // Elena Preteni 11/01/2019 update Asset when External Source Mapping updated

            ExternalSourceMapping__c esm = new ExternalSourceMapping__c( );
            NE__Service_Point__c currentSPAfterInsert = new NE__Service_Point__c( );
            list<SObject> newDataUpdatedAfterInsert = new list<SObject>( );
            System.debug( 'newDataUpdated: ' + newDataUpdated );
            System.debug( 'esmListFromSfdc: ' + esmListFromSfdc );
            //giovanni spinelli - 21/01/2019 - start - logic to insert a new contact with SP lookup
            System.debug( 'SERVICE POINT ID: ' + request.OB_ServicePointId__c );
            //START NEXI-109 Zuzanna Urban 17/06/2019 Change logic to update 3 contacts
             // START - elena.preteni 13/07/2019 error list of contact
            List<Contact> currentContactSPRUpdate = new List<Contact>( );
            List<Contact> currentContactARUpdate = new List<Contact>( );
            List<Contact> currentContactTRUpdate = new List<Contact>( );
            Id servicePointReferentType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.REFERENTE_PUNTO_VENDITA ).getRecordTypeId( );
            administrativeResponsibleType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.RESPONSABILE_AMMINISTRATIVO ).getRecordTypeId( );
            technicalReferentType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.REFERENTE_TECNICO ).getRecordTypeId( );
            if ( String.isNotBlank( String.valueOf( request.OB_ServicePointId__c ) ) )
            {
                currentContactSPRUpdate =
                [
                        SELECT id,
                                RecordTypeId
                        FROM Contact
                        WHERE OB_Service_Point__c = :request.OB_ServicePointId__c
                        AND RecordtypeId = :servicePointReferentType
                        LIMIT 1
                ];
                currentContactARUpdate =
                [
                        SELECT id,
                                RecordTypeId
                        FROM Contact
                        WHERE OB_Service_Point__c = :request.OB_ServicePointId__c
                        AND RecordtypeId = :administrativeResponsibleType
                        LIMIT 1
                ];
                currentContactTRUpdate =
                [
                        SELECT id,
                                RecordTypeId
                        FROM Contact
                        WHERE OB_Service_Point__c = :request.OB_ServicePointId__c
                        AND RecordtypeId = :technicalReferentType
                        LIMIT 1
                ];

                for ( SObject currentContact : toInsert )
                {
                    Schema.SObjectType expected = Schema.Contact.getSObjectType( );

                    if ( String.isNotBlank( referentRecordType.get( servicePointResponsibleType ) ) && !currentContactSPRUpdate.isEmpty() )
                    {
                        currentContactSPRUpdate.get(0).Id = referentRecordType.get( servicePointResponsibleType );
                    }
                    if ( String.isNotBlank( referentRecordType.get( technicalReferentType ) ) && !currentContactTRUpdate.isEmpty() )
                    {
                        currentContactARUpdate.get(0).Id = referentRecordType.get( technicalReferentType );
                    }
                    if ( String.isNotBlank( referentRecordType.get( administrativeResponsibleType ) ) && !currentContactARUpdate.isEmpty() )
                    {
                        currentContactTRUpdate.get(0).Id = referentRecordType.get( administrativeResponsibleType );
                    }
                    // END - elena.preteni 13/07/2019 error list of contact 
                    System.debug( 'current SPR before update: ' + currentContactSPRUpdate );
                    System.debug( 'current AR before update: ' + currentContactARUpdate );
                    System.debug( 'current TR before update: ' + currentContactTRUpdate );
                    Database.update( currentContactSPRUpdate, true );
                    Database.update( currentContactARUpdate, true );
                    Database.update( currentContactTRUpdate, true );
                    //STOP NEXI-109 Zuzanna Urban 17/06/2019 Change logic to update 3 contacts

                }
            }
            //giovanni spinelli - 21/01/2019 - end - logic to insert a new contact with SP lookup

            for ( SObject currentData : newDataUpdated )
            {
                //	SERVICE POINT
                Schema.SObjectType expected = Schema.NE__Service_Point__c.getSObjectType( );
                Schema.SObjectType expectedEsm = Schema.ExternalSourceMapping__c.getSObjectType( );
                System.debug( 'currentData.getSObjectType(): ' + currentData.getSObjectType( ) );
                System.debug( 'expected: ' + expected );
                System.debug( 'expectedEsm: ' + expectedEsm );
                System.debug( 'IF CONDITION SERVICE POINT: ' + ( currentData.getSObjectType( ) == expected ) );

                // Elena Preteni 11/01/2019 update Asset when External Source Mapping updated
                if ( currentData.getSObjectType( ) == expectedEsm )
                {
                    esm = ( ExternalSourceMapping__c ) currentData;
                    system.debug( 'currentData -->' + currentData );

                    for ( Asset a : assets )
                    {

                        for ( ExternalSourceMapping__c e : esmListFromSfdc )
                        {
                            
                            //Start antonio.vatrano wn-412 16/09/2019
                            // if ( String.isNotBlank( a.OB_GT__c ) && a.OB_GT__c.equalsIgnoreCase( 'Monetica' ) && e.OB_CustomerCodeClientCode__c.equalsIgnoreCase( a.OB_CustomerCode__c )
                            //         && e.OB_ServicePointCodeShopCode__c.equalsIgnoreCase( a.OB_ShopCode__c ) && ( !a.NE__Status__c.equalsIgnoreCase( 'Disconnected' ) ) )
                            // {//SIMONE Misani 21/05/2019 RI-60
                            if(     (String.isNotBlank( a.OB_GT__c ) && 
                                    String.isNotBlank( e.OB_CustomerCodeClientCode__c ) && 
                                    String.isNotBlank( a.OB_CustomerCode__c ) && 
                                    String.isNotBlank( e.OB_ServicePointCodeShopCode__c ) && 
                                    String.isNotBlank( a.OB_ShopCode__c )) && 
                                    a.OB_GT__c.equalsIgnoreCase( 'Monetica' ) && 
                                    e.OB_CustomerCodeClientCode__c.equalsIgnoreCase( a.OB_CustomerCode__c )&& 
                                    e.OB_ServicePointCodeShopCode__c.equalsIgnoreCase( a.OB_ShopCode__c ) && 
                                    !a.NE__Status__c.equalsIgnoreCase( 'Disconnected' )){
                            //End antonio.vatrano wn-412 16/09/2019

                                if ( esm.OB_ShopSign__c != null )
                                {
                                    a.OB_ShopSign__c = esm.OB_ShopSign__c;
                                }
                                if ( esm.OB_ReceiptHeader__c != null )
                                {
                                    a.OB_ReceiptHeader__c = esm.OB_ReceiptHeader__c;
                                }
                                if ( esm.OB_ReceiptCity__c != null )
                                {
                                    a.OB_ReceiptCity__c = esm.OB_ReceiptCity__c;
                                }
                                assetsToUpdateSet.add( a );
                                //francesca.ribezzi 18/03/19 adding the external source mapping record to the new monetica set:
                                if ( e.id != esm.id )
                                {
                                    moneticaList.add( esm );
                                }
                                //	moneticaList.add(esm);
                                if ( !moneticaList.contains( e ) )
                                {
                                    moneticaList.add( e );
                                }


                                // system.debug('assetsToUpdateSet --> '+assetsToUpdateSet);
                            }
                            //Start antonio.vatrano wn-412 16/09/2019   
                            if (    String.isNotBlank( a.OB_Processor__c ) &&
                                    String.isNotBlank( e.OB_CustomerCodeClientCode__c ) && 
                                    String.isNotBlank( a.OB_CompanyCode__c ) && 
                                    String.isNotBlank( e.OB_ServicePointCodeShopCode__c ) && 
                                    String.isNotBlank( a.OB_ServicePointCode__c ) && 
                                    ( a.OB_Processor__c.equalsIgnoreCase( 'EQUENS' ) || a.OB_Processor__c.equalsIgnoreCase( 'SIA' ) ) && e.id == currentData.id && 
                                    e.OB_CustomerCodeClientCode__c.equalsIgnoreCase( a.OB_CompanyCode__c ) &&
                                    e.OB_ServicePointCodeShopCode__c.equalsIgnoreCase( a.OB_ServicePointCode__c ) &&
                                    ( !a.NE__Status__c.equalsIgnoreCase( 'Disconnected' ) ) )
                                {//Start antonio.vatrano wn-412 16/09/2019  //SIMONE Misani 21/05/2019 RI-60
                                if ( esm.OB_ShopSign__c != null )
                                {
                                    a.OB_ShopSign__c = esm.OB_ShopSign__c;
                                }
                                if ( esm.OB_ReceiptHeader__c != null )
                                {
                                    a.OB_ReceiptHeader__c = esm.OB_ReceiptHeader__c;
                                }
                                if ( esm.OB_ReceiptCity__c != null )
                                {
                                    a.OB_ReceiptCity__c = esm.OB_ReceiptCity__c;
                                }

                                assetsToUpdateSet.add( a );
                                //START francesca.ribezzi 18/03/19 adding new else if for equens to update:
                            }
                            else if ( String.isNotBlank( a.OB_Processor__c ) && ( a.OB_Processor__c.equalsIgnoreCase( 'EQUENS' ) || a.OB_Processor__c.equalsIgnoreCase( 'SIA' ) ) )
                            {
                                //adding the external source mapping record to the new equens set:
                                //	equensList.add(esm);
                                equensList.add( e );

                            }
                            //END francesca.ribezzi
                        }
                    }
                    newDataUpdatedAfterInsert.add( currentData );

                }

                // Elena Preteni 11/01/2019 update Asset when External Source Mapping updated
                //	NOT SERVICE POINT
                else
                {
                    newDataUpdatedAfterInsert.add( currentData );
                    system.debug( 'newDataUpdatedAfterInsert NOT SP-->' + newDataUpdatedAfterInsert );
                }

            }
            system.debug( 'moneticaList--> ' + moneticaList );
            system.debug( 'assetsToUpdate BEFORE --> ' + assetsToUpdate );
            assetsToUpdate.addAll( assetsToUpdateSet );
            system.debug( 'assetsToUpdate AFTER --> ' + assetsToUpdate );
            if ( !newDataUpdatedAfterInsert.isempty( ) )
            {
                system.debug( 'DEBUG' );
                System.debug( 'IF CONDITION UPDATE: ' + newDataUpdatedAfterInsert );
                //giovanni spinelli - 02/01/2019 - if the contact id is null --> do not update
                if ( String.isNotBlank( ( string ) newDataUpdatedAfterInsert.get( 0 ).get( 'Id' ) ) )
                {
                    System.debug( 'INTO IF UPDATE' );
                    database.update( newDataUpdatedAfterInsert, true );
                }
            }
            //	END 	micol.ferrari 19/12/2018
            //START - elena.preteni 31/07/2019 WN-202 avoid locking record problem
            request.OB_Status__c = System.label.OB_MAINTENANCE_LOGREQUEST_STATUS_CONFIRMED;   //02/05/2019 - DO NOT SET LOG REQUEST STATUS IN CONFIRMED - salvatore.pianura@accenture.com - Maintenance Tracking Anagrafica
            //END - elena.preteni 31/07/2019 WN-202 avoid locking record problem
            System.debug( 'REQUEST STATUS IS: ' + request.OB_Status__c );
            update request;
            update assetsToUpdate;

            //START francesca.ribezzi 18/03/19 updating new set of external source mapping records
            System.debug( 'moneticaList size: ' + moneticaList.size( ) );
            System.debug( 'equens size: ' + equensList.size( ) );
            for ( ExternalSourceMapping__c monetica : moneticaList )
            {
                for ( ExternalSourceMapping__c equens : equensList )
                {
                    if ( String.isBlank( monetica.OB_Conventioncode__c ) )
                    {
                        //do nothing
                    }
                    else if ( monetica.OB_Conventioncode__c == equens.OB_ServicePointCodeShopCode__c )
                    {
                        //updating equens with monetica values:

                        //esm record is the updated one
                        if ( String.isNotBlank( esm.OB_ShopSign__c ) )
                        {
                            equens.OB_ShopSign__c = esm.OB_ShopSign__c;
                            monetica.OB_ShopSign__c = esm.OB_ShopSign__c;
                        }
                        if ( String.isNotBlank( esm.OB_ReceiptHeader__c ) )
                        {
                            equens.OB_ReceiptHeader__c = esm.OB_ReceiptHeader__c;
                            monetica.OB_ReceiptHeader__c = esm.OB_ReceiptHeader__c;
                        }
                        if ( String.isNotBlank( esm.OB_ReceiptCity__c ) )
                        {
                            equens.OB_ReceiptCity__c = esm.OB_ReceiptCity__c;
                            monetica.OB_ReceiptCity__c = esm.OB_ReceiptCity__c;
                        }
                        esmSetToUpdate.add( equens );
                        System.debug( 'equens.OB_ShopSign__c: ' + equens.OB_ShopSign__c );
                        System.debug( 'monetica.OB_ShopSign__c: ' + monetica.OB_ShopSign__c );

                    }
                }
                esmSetToUpdate.add( monetica );
                if ( monetica.id != esm.id )
                {
                    esmSetToUpdate.add( esm );
                }
            }
            List<ExternalSourceMapping__c> esmListToUpdate = new List<ExternalSourceMapping__c>( esmSetToUpdate );
            List<ExternalSourceMapping__c> newEsmListToUpdate = new List<ExternalSourceMapping__c>( );
            Map<Id, ExternalSourceMapping__c> idEsmMap = new Map<Id, ExternalSourceMapping__c>( );
            for ( ExternalSourceMapping__c e : esmListToUpdate )
            {
                if ( idEsmMap.containsKey( e.Id ) )
                {

                }
                else
                {
                    idEsmMap.put( e.Id, e );
                    newEsmListToUpdate.add( e );
                }
            }

            System.debug( 'newEsmListToUpdate: ' + newEsmListToUpdate );
            update newEsmListToUpdate;
            //END
            System.debug( 'REQUEST AFTER UPDATE: ' + request );
        } catch ( Exception e )
        {
            // rollback the transaction
            //NEXI-149 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 02/07/2019 Start
            if ( !Test.isRunningTest( ) )
            {
                Database.rollback( sp );
            }
            //NEXI-149 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 02/07/2019 Stop
            system.debug( logginglevel.error, 'Exception in acceptLogRequest - ' + e.getMessage( ) + 'At line ' + e.getLineNumber( ) + ' where ' + e.getStackTraceString( ) );
            toReturn = e.getMessage( );
        }

        return toReturn ;
    }
    //	END 	micol.ferrari 24/12/2018


    /*
        *	author : claudio Quaranta
        * 	Date : 04/12/2018
        *	Description : method used to retrive the field NAME from the dynamic object
        *	input : oldData : list of SObject that contains the olddata
                    newData : list of SObject that contains the newData
            output : map<id,string>  map that contains the record id and it is relative name
        */

    private static map<id, string> retriveObjectDataNames( list<SObject> oldData, list<SObject> newData )
    {
        map<id, string> mapOfrecordIdString = new map<id, string>( );
        list<id> listOfrecordsId = new list<id>( );
        for ( Integer i = 0; i < oldData.size( ); i++ )
        {
            if ( !string.isBlank ( ( string ) oldData.get( i ).get( 'Id' ) ) )
            {
                listOfrecordsId.add( ( string ) oldData.get( i ).get( 'Id' ) );
            }
        }
        for ( Integer i = 0; i < newData.size( ); i++ )
        {
            if ( !string.isBlank ( ( string ) newData.get( i ).get( 'Id' ) ) )
            {
                listOfrecordsId.add( ( string ) newData.get( i ).get( 'Id' ) );
            }
        }

        if ( !listOfrecordsId.isempty( ) )
        {
            list<Account>listOfAccount = [ select id, Name from Account where id in :listOfrecordsId ];
            list<Contact>listOfContact = [ select id, Name from Contact where id in :listOfrecordsId ];
            if ( !listOfAccount.isempty( ) )
                for ( Account acc : listOfAccount )
                    mapOfrecordIdString.put( acc.id, acc.name );
            if ( !listOfContact.isempty( ) )
                for ( Contact con : listOfContact )
                    mapOfrecordIdString.put( con.id, con.name );

        }

        return mapOfrecordIdString;
    }

    /*
    *	author : claudio Quaranta
    * 	Date : 28/11/2018
    *	Description : method used to retrive data from a  logrequest
    *	input : logRequestId --> OB_LogRequest__c record id
        output : JSON
    */

    @auraEnabled
    public static String retrieveLogRequest( id logRequestId )
    {
        returnWrapper wrap = new returnWrapper( );
        // retrive log request
        //START - elena.preteni 24/06/2019 added list as return object
        List<OB_LogRequest__c> requestList =
        [
                SELECT Id,
                        OB_ReducedOldData__c,
                        OB_ReducedNewData__c,
                        OB_Status__c,
                        RecordType.DeveloperName,
                        OB_ServicePointId__c,
                        OB_ChangeServicePointData__c,
                        OB_Change_of_location_referents__c,//NEXI-187 Grzegorz Banach<grzegorz.banach@accenture.com> 16/07/2019
                        OB_Change_of_data_of_beneficial_owners__c,//NEXI-91 grzegorz.banach@accenture.com 19/06/2019
                        OB_ChangeLegalRepresentative__c,//NEXI-149 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 01/07/2019 Start
                        OB_NewLegalRepresentative__c,//NEXI-149 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 01/07/2019 Stop
                        OB_ChangeMerchantName__c,//NEXI-240 Marlena Lukomska-Rogala<m.lukomska-rogala@accenture.com> 30/07/2019 START
                        OB_AccountId__c, //NEXI-240 Marlena Lukomska-Rogala<m.lukomska-rogala@accenture.com> 30/07/2019 STOP
                        OB_MaintenanceType__c,//NEXI-240 Marlena Lukomska-Rogala<m.lukomska-rogala@accenture.com> 2/08/2019 STOP
                        OB_isNotIntegrated__c // NEXI-274 Joanna Mielczarek <joanna.mielczarek@accenture.com> 27/08/2019
                FROM OB_LogRequest__c
                WHERE id = :logRequestId
                LIMIT 1
        ];
        OB_LogRequest__c request;
        request = !requestList.isEmpty( ) ? requestList.get( 0 ) : new OB_LogRequest__c( );
        //END - elena.preteni 24/06/2019 added list as return object
        // retriving request status
        wrap.requestStatus = request.OB_Status__c;
        // retirve user license , used to show the button into the lightning component
        wrap.isInternalUser = OB_Maintenance_Helper.isInternalUSer( );
        //NEXI-240 Marlena Lukomska-Rogala <m.lukomska-rogala@accenture.com> 31/07/2019 START
        wrap.changeServicePoint = request.OB_ChangeServicePointData__c;
        wrap.changeMerchant = request.OB_ChangeMerchantName__c;
        //NEXI-240 Marlena Lukomska-Rogala <m.lukomska-rogala@accenture.com> 31/07/2019 STOP

        //	START 	micol.ferrari 18/12/2018 - TIME FIELDS
        //	OLD---------------------------------------------------------------------------------------
        String oB_ReducedOldData = '';
        String oldOB_Opening_Time = '';
        String oldOB_Break_End_Time = '';
        String oldOB_Break_Start_Time = '';
        String oldOB_Ending_Time = '';
        //START - elena.preteni 21/06/2019 added condition coba
        if ( request.RecordType.DeveloperName != 'OB_CambioCoBa' )
        {
            try
            {
                //END - elena.preteni 21/06/2019 added condition coba
                Map<String, Object> mapReducedOldData = ( Map<String, Object> ) JSON.deserializeUntyped( request.OB_ReducedOldData__c );
                system.debug( '## mapReducedOldData: ' + mapReducedOldData );
                system.debug( '## obj: ' + mapReducedOldData.get( 'obj' ) );
                List<Object> oldlistOfObjs = ( List<Object> ) JSON.deserializeUntyped( JSON.serialize( mapReducedOldData.get( 'obj' ) ) );
                system.debug( '## listOfObjs: ' + oldlistOfObjs );

                List<Map<String, Object>> oldlistOfMaps = new List<Map<String, Object>>( );
                List<Map<String, Object>> oldupdatedListOfMaps = new List<Map<String, Object>>( );
                for ( Object obj : oldlistOfObjs )
                {
                    oldlistOfMaps.add( ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( obj ) ) );
                }
                system.debug( '## oldlistOfMaps: ' + oldlistOfMaps );

                Set<Id> externalSourceMappingsIds = new Set<Id>( );  // NEXI-274 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 27/08/2019

                for ( Map<String, Object> singlemap : oldlistOfMaps )
                {
                    if ( singlemap.containsKey( 'attributes' ) )
                    {
                        Map<String, Object> attributesmap = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( singlemap.get( 'attributes' ) ) );
                        system.debug( '## attributesmap: ' + attributesmap );
                        if ( attributesmap.containsKey( 'type' ) && attributesmap.get( 'type' ) == 'NE__Service_Point__c' )
                        {
                            if ( singlemap.containsKey( 'OB_Opening_Time__c' ) )
                            {
                                oldOB_Opening_Time = ( String ) singlemap.get( 'OB_Opening_Time__c' );
                                singlemap.put( 'OB_Opening_Time__c', null );
                            }
                            else
                            {
                                oldOB_Opening_Time = 'SKIP';
                            }
                            if ( singlemap.containsKey( 'OB_Break_End_Time__c' ) )
                            {
                                oldOB_Break_End_Time = ( String ) singlemap.get( 'OB_Break_End_Time__c' );
                                singlemap.put( 'OB_Break_End_Time__c', null );
                            }
                            else
                            {
                                oldOB_Break_End_Time = 'SKIP';
                            }
                            if ( singlemap.containsKey( 'OB_Break_Start_Time__c' ) )
                            {
                                oldOB_Break_Start_Time = ( String ) singlemap.get( 'OB_Break_Start_Time__c' );
                                singlemap.put( 'OB_Break_Start_Time__c', null );
                            }
                            else
                            {
                                oldOB_Break_Start_Time = 'SKIP';
                            }
                            if ( singlemap.containsKey( 'OB_Ending_Time__c' ) )
                            {
                                oldOB_Ending_Time = ( String ) singlemap.get( 'OB_Ending_Time__c' );
                                singlemap.put( 'OB_Ending_Time__c', null );
                            }
                            else
                            {
                                oldOB_Ending_Time = 'SKIP';
                            }
                        }
                        externalSourceMappingsIds.add( ( Id ) singlemap.get( 'Id' ) ); // NEXI-274 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 27/08/2019
                    }
                    oldupdatedListOfMaps.add( singlemap );
                }
                externalSourceMappingsIds.remove( null ); // NEXI-274 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 27/08/2019

                List<Object> oldupdatedListOfObjs = ( List<Object> ) JSON.deserializeUntyped( JSON.serialize( oldupdatedListOfMaps ) );
                mapReducedOldData.put( 'obj', ( Object ) oldupdatedListOfObjs );

                oB_ReducedOldData = JSON.serialize( mapReducedOldData );
                system.debug( '## oB_ReducedOldData: ' + oB_ReducedOldData );

                list<SObject> oldData ;
                if ( !string.isblank( oB_ReducedOldData ) )
                    oldData = ( ( OB_Maintenance_Helper.serializeObject ) JSON.deserialize( oB_ReducedOldData, OB_Maintenance_Helper.serializeObject.class ) ).obj;
                else
                {
                    wrap.errorOccurred = true;
                    wrap.errorMessage = System.Label.OB_MAINTENANCE_LOGREQUEST_NODATA;
                }

                //	NEW---------------------------------------------------------------------------------------
                String oB_ReducednewData = '';
                String newOB_Opening_Time = '';
                String newOB_Break_End_Time = '';
                String newOB_Break_Start_Time = '';
                String newOB_Ending_Time = '';
                Map<String, Object> mapReducednewData = ( Map<String, Object> ) JSON.deserializeUntyped( request.OB_ReducednewData__c );
                system.debug( '## mapReducednewData: ' + mapReducednewData );
                system.debug( '## obj: ' + mapReducednewData.get( 'obj' ) );
                List<Object> newlistOfObjs = ( List<Object> ) JSON.deserializeUntyped( JSON.serialize( mapReducednewData.get( 'obj' ) ) );
                system.debug( '## newlistOfObjs: ' + newlistOfObjs );

                List<Map<String, Object>> newlistOfMaps = new List<Map<String, Object>>( );
                List<Map<String, Object>> newupdatedListOfMaps = new List<Map<String, Object>>( );
                for ( Object obj : newlistOfObjs )
                {
                    newlistOfMaps.add( ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( obj ) ) );
                }
                system.debug( '## newlistOfMaps: ' + newlistOfMaps );
                for ( Map<String, Object> singlemap : newlistOfMaps )
                {
                    if ( singlemap.containsKey( 'attributes' ) )
                    {
                        Map<String, Object> attributesmap = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( singlemap.get( 'attributes' ) ) );
                        system.debug( '## attributesmap: ' + attributesmap );

                        //------------------------------------------------------------------------------------------------------
                        //	START - ONLY IF SERVICE POINT, BECAUSE OF TIME FIELDS
                        //------------------------------------------------------------------------------------------------------
                        if ( attributesmap.containsKey( 'type' ) && attributesmap.get( 'type' ) == 'NE__Service_Point__c' )
                        {
                            if ( singlemap.containsKey( 'OB_Opening_Time__c' ) )
                            {
                                newOB_Opening_Time = ( String ) singlemap.get( 'OB_Opening_Time__c' );
                                singlemap.put( 'OB_Opening_Time__c', null );
                            }
                            else
                            {
                                newOB_Opening_Time = 'SKIP';
                            }
                            if ( singlemap.containsKey( 'OB_Break_End_Time__c' ) )
                            {
                                newOB_Break_End_Time = ( String ) singlemap.get( 'OB_Break_End_Time__c' );
                                singlemap.put( 'OB_Break_End_Time__c', null );
                            }
                            else
                            {
                                newOB_Break_End_Time = 'SKIP';
                            }
                            if ( singlemap.containsKey( 'OB_Break_Start_Time__c' ) )
                            {
                                newOB_Break_Start_Time = ( String ) singlemap.get( 'OB_Break_Start_Time__c' );
                                singlemap.put( 'OB_Break_Start_Time__c', null );
                            }
                            else
                            {
                                newOB_Break_Start_Time = 'SKIP';
                            }
                            if ( singlemap.containsKey( 'OB_Ending_Time__c' ) )
                            {
                                newOB_Ending_Time = ( String ) singlemap.get( 'OB_Ending_Time__c' );
                                singlemap.put( 'OB_Ending_Time__c', null );
                            }
                            else
                            {
                                newOB_Ending_Time = 'SKIP';
                            }
                        }
                        //------------------------------------------------------------------------------------------------------
                        //	END - ONLY IF SERVICE POINT, BECAUSE OF TIME FIELDS
                        //------------------------------------------------------------------------------------------------------
                    }
                    newupdatedListOfMaps.add( singlemap );
                }

                List<Object> newupdatedListOfObjs = ( List<Object> ) JSON.deserializeUntyped( JSON.serialize( newupdatedListOfMaps ) );
                mapReducednewData.put( 'obj', ( Object ) newupdatedListOfObjs );

                oB_ReducednewData = JSON.serialize( mapReducednewData );
                system.debug( '## oB_ReducednewData: ' + oB_ReducednewData );

                list<SObject> newData ;
                // retriving the newdata JSON, morphing it into a list of JObject
                if ( !string.isblank( oB_ReducednewData ) )
                    newData = ( ( OB_Maintenance_Helper.serializeObject ) JSON.deserialize( oB_ReducednewData, OB_Maintenance_Helper.serializeObject.class ) ).obj;
                else
                {
                    wrap.errorOccurred = true;
                    wrap.errorMessage = System.Label.OB_MAINTENANCE_LOGREQUEST_NODATA;
                }

                //	END 	micol.ferrari 18/12/2018 - TIME FIELDS

                if ( !wrap.errorOccurred )
                {
                    // retrivin schema information
                    list <string> sObjectToRetrive = new list<string>( OB_Maintenance_Helper.getSetOfObjectType( oldData ) );
                    Map<String, Map<String, Schema.DescribeFieldResult>> objType2fieldData = new Map<String, Map<String, Schema.DescribeFieldResult>>( );
                    objType2fieldData.putAll( OB_Maintenance_Helper.fieldObjType2APINameSchema( sObjectToRetrive ) );

                    map<id, string> mapOfrecordIdString = retriveObjectDataNames( oldData, newData );
                    //NEXI-91 grzegorz.banach@accenture.com 19/06/2019 START
                    Map<Id, Schema.RecordTypeInfo> contactRtMap = Schema.getGlobalDescribe( ).get( 'Contact' ).getDescribe( ).getRecordTypeInfosById( );
                    //NEXI-91 grzegorz.banach@accenture.com 19/06/2019 STOP

                   Map<Id, ExternalSourceMapping__c> externalSourceMappingsByIds = getExternalSourceMappings( externalSourceMappingsIds ); // NEXI-274 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 27/08/2019

                    // populating return wrapper
                    for ( Integer i = 0; i < oldData.size( ); i++ )
                    {
                        // retiving oldata object
                        SObject oldRecord = oldData.get( i );
                        // Retriving new data object
                        SObject newRecord = newData.get( i );

                        // retriving object name
                        string oldObjectName = oldRecord.getSObjectType( ).getDescribe( ).getName( );
                        string newObjectName = newRecord.getSObjectType( ).getDescribe( ).getName( );

                        //	micol.ferrari 19/12/2018
                        string oldObjectLabel = oldRecord.getSObjectType( ).getDescribe( ).getLabel( );
                        string newObjectLabel = newRecord.getSObjectType( ).getDescribe( ).getLabel( );


                        //	START 	micol.ferrari 18/12/2018
                        //	OLD
                        ObjectWrapper oldObjectWrapper = new ObjectWrapper( );
                        oldObjectWrapper.objecType = oldObjectName; // inserting label to show into the page ( for now is a Object Name )
                        oldObjectWrapper.objectName = oldObjectLabel;
                        oldObjectWrapper.objectId = oldRecord.Id; // NEXI-274 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 27/08/2019
                        //	NEW
                        ObjectWrapper newObjectWrapper = new ObjectWrapper( );

                        newObjectWrapper.objecType = newObjectName;
                        newObjectWrapper.objectName = newObjectLabel;
                        newObjectWrapper.objectId = newRecord.Id; // NEXI-274 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 27/08/2019


                        //NEXI-91 grzegorz.banach@accenture.com 19/06/2019 START
                        Boolean isContact = newRecord.getSObjectType( ) == Schema.Contact.SObjectType;
                        if ( request.OB_Change_of_data_of_beneficial_owners__c )
                        {
                            wrap.logRequestType = LOG_REQUEST_TYPE_MAINTENANCE_OF_DATA_OF_ACTUAL_OWNERS;
                            //NEXI-128 grzegorz.banach@accenture.com 27/06/2019 START
                            oldObjectWrapper.objectName = Label.OB_Contact_Holder;
                            newObjectWrapper.objectName = Label.OB_Contact_Holder;
                            //NEXI-128 grzegorz.banach@accenture.com 27/06/2019 END
                        }
                        else if ( request.OB_ChangeServicePointData__c && request.OB_Change_of_location_referents__c )//NEXI-187 Grzegorz Banach<grzegorz.banach@accenture.com> 16.07.2019
                        {
                            wrap.logRequestType = LOG_REQUEST_TYPE_MAINTENANCE_OF_LOCATION_REFERENTS;
                        }
                        //NEXI-149 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 01/07/2019 Start
                        else if ( request.OB_NewLegalRepresentative__c || request.OB_ChangeLegalRepresentative__c )
                        {
                            wrap.logRequestType = LOG_REQUEST_TYPE_MAINTENANCE_OF_ESECUTORE;
                            oldObjectWrapper.objectName = OB_UtilityConstants.ESECUTORE;
                            newObjectWrapper.objectName = OB_UtilityConstants.ESECUTORE;
                        }
                        //NEXI-149 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 01/07/2019 Stop
                        if ( isContact )
                        {
                            newObjectWrapper.objectId = String.isNotBlank( ( String ) newRecord.getPopulatedFieldsAsMap( ).get( 'Id' ) ) ? ( String ) newRecord.getPopulatedFieldsAsMap( ).get( 'Id' ) : null;
                            oldObjectWrapper.objectId = String.isNotBlank( ( String ) oldRecord.getPopulatedFieldsAsMap( ).get( 'Id' ) ) ? ( String ) oldRecord.getPopulatedFieldsAsMap( ).get( 'Id' ) : null;
                            Id rtId = ( Id ) newRecord.get( 'RecordTypeId' );
                            newObjectWrapper.recordTypeName = String.isBlank( rtId ) ? null : contactRtMap.get( rtId ).getName( );
                            //NEXI-158 Zuzanna Urban<z.urban@accenture.com>, 05/07/2019 Start
                            String newIdContact = ( String ) newRecord.getPopulatedFieldsAsMap( ).get( 'Id' );
                            Id servicePointReferentType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.REFERENTE_PUNTO_VENDITA ).getRecordTypeId( );
                            Id administrativeResponsibleType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.RESPONSABILE_AMMINISTRATIVO ).getRecordTypeId( );
                            Id technicalReferentType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.REFERENTE_TECNICO ).getRecordTypeId( );

                            if( String.isNotBlank( newObjectWrapper.objectId  ) && String.isBlank( newObjectWrapper.recordTypeName  ) && !String.isBlank( newIdContact ) )
                            {
                                List<Contact> contactsId = new List<Contact>();
                                try
                                {
                                    contactsId =
                                    [
                                            SELECT Id,
                                                    RecordTypeId
                                            FROM Contact
                                            WHERE Id = :newIdContact
                                            AND RecordTypeId IN ( :servicePointReferentType, :administrativeResponsibleType, :technicalReferentType )
                                            LIMIT 1
                                    ];
                                    newObjectWrapper.recordTypeName = contactRtMap.get( contactsId.get(0).RecordTypeId ).getName( );
                                }
                                catch (Exception ex)
                                {
                                    System.debug( LoggingLevel.ERROR, '[EXC] Exception ' + ex.getMessage( ) + ' stacktrace ' + ex.getStackTraceString( ) );
                                }

                            }
                            //NEXI-158 Zuzanna Urban<z.urban@accenture.com>, 05/07/2019 Start
                        }
                        //NEXI-91 grzegorz.banach@accenture.com 19/06/2019 END
                        //------------------------------------------------------------------------------------------------------
                        //	START - ONLY IF SERVICE POINT, BECAUSE OF TIME FIELDS
                        //------------------------------------------------------------------------------------------------------
                        if ( oldObjectName == 'NE__Service_Point__c' )
                        {
                            //	OLD---------------
                            // retriving populating object wrapper
                            ObjectWrapper oldObjectWrapperTemp = new ObjectWrapper( );
                            oldObjectWrapperTemp.objecType = oldObjectName; // inserting label to show into the page ( for now is a Object Name )
                            // populating field wrapper
                            oldObjectWrapperTemp.listOfRow = estractRowSpecification ( oldRecord.getPopulatedFieldsAsMap( ), objType2fieldData.get( oldObjectName ) );

                            String objtype = 'NE__Service_Point__c';
                            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe( );
                            Schema.SObjectType leadSchema = schemaMap.get( objtype );
                            Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe( ).fields.getMap( );

                            for ( rowWrapper oldrow : oldObjectWrapperTemp.listOfRow )
                            {
                                if ( oldrow.label == fieldMap.get( 'OB_Opening_Time__c' ).getDescribe( ).getLabel( ) )
                                {
                                    oldrow.value = oldOB_Opening_Time != 'SKIP' ? ParseTime( oldOB_Opening_Time ) : oldrow.value;
                                }
                                if ( oldrow.label == fieldMap.get( 'OB_Ending_Time__c' ).getDescribe( ).getLabel( ) )
                                {
                                    oldrow.value = oldOB_Ending_Time != 'SKIP' ? ParseTime( oldOB_Ending_Time ) : oldrow.value;
                                }
                                if ( oldrow.label == fieldMap.get( 'OB_Break_End_Time__c' ).getDescribe( ).getLabel( ) )
                                {
                                    oldrow.value = oldOB_Break_End_Time != 'SKIP' ? ParseTime( oldOB_Break_End_Time ) : oldrow.value;
                                }
                                if ( oldrow.label == fieldMap.get( 'OB_Break_Start_Time__c' ).getDescribe( ).getLabel( ) )
                                {
                                    oldrow.value = oldOB_Break_Start_Time != 'SKIP' ? ParseTime( oldOB_Break_Start_Time ) : oldrow.value;
                                }
                                oldObjectWrapper.listOfRow.add( oldrow );
                            }

                            //	NEW---------------
                            // retriving populating object wrapper
                            ObjectWrapper newObjectWrapperTemp = new ObjectWrapper( );
                            newObjectWrapperTemp.objecType = newObjectName; // inserting label to show into the page ( for now is a Object Name )
                            // populating field wrapper
                            newObjectWrapperTemp.listOfRow = estractRowSpecification ( newRecord.getPopulatedFieldsAsMap( ), objType2fieldData.get( newObjectName ) );

                            objtype = 'NE__Service_Point__c';
                            Map<String, Schema.SObjectType> newschemaMap = Schema.getGlobalDescribe( );
                            Schema.SObjectType newleadSchema = newschemaMap.get( objtype );
                            Map<String, Schema.SObjectField> newfieldMap = newleadSchema.getDescribe( ).fields.getMap( );

                            for ( rowWrapper newrow : newObjectWrapperTemp.listOfRow )
                            {
                                if ( newrow.label == fieldMap.get( 'OB_Opening_Time__c' ).getDescribe( ).getLabel( ) )
                                {
                                    newrow.value = newOB_Opening_Time != 'SKIP' ? ParseTime( newOB_Opening_Time ) : newrow.value;
                                }
                                if ( newrow.label == fieldMap.get( 'OB_Ending_Time__c' ).getDescribe( ).getLabel( ) )
                                {
                                    newrow.value = newOB_Ending_Time != 'SKIP' ? ParseTime( newOB_Ending_Time ) : newrow.value;
                                }
                                if ( newrow.label == fieldMap.get( 'OB_Break_End_Time__c' ).getDescribe( ).getLabel( ) )
                                {
                                    newrow.value = newOB_Break_End_Time != 'SKIP' ? ParseTime( newOB_Break_End_Time ) : newrow.value;
                                }
                                if ( newrow.label == fieldMap.get( 'OB_Break_Start_Time__c' ).getDescribe( ).getLabel( ) )
                                {
                                    newrow.value = newOB_Break_Start_Time != 'SKIP' ? ParseTime( newOB_Break_Start_Time ) : newrow.value;
                                }
                                newObjectWrapper.listOfRow.add( newrow );
                            }

                        }
                        //------------------------------------------------------------------------------------------------------
                        //	END - ONLY IF SERVICE POINT, BECAUSE OF TIME FIELDS
                        //------------------------------------------------------------------------------------------------------
                        else
                        {

                            //------------------------------------------------------------------------------------------------------
                            //	EVERY OTHER OBJECT EXCEPT SERVICE POINT
                            //------------------------------------------------------------------------------------------------------
                            //	OLD
                            oldObjectWrapper.listOfRow = estractRowSpecification ( oldRecord.getPopulatedFieldsAsMap( ), objType2fieldData.get( oldObjectName ) );
                            //	NEW
                            newObjectWrapper.listOfRow = estractRowSpecification ( newRecord.getPopulatedFieldsAsMap( ), objType2fieldData.get( newObjectName ) );
                        }
                        //	END 	micol.ferrari 18/12/2018
                        // setting object Name field To show into the component.
                        if ( newRecord.getPopulatedFieldsAsMap( ).containsKey( 'Name' ) )
                        {
                            newObjectWrapper.objectLabel = ( String ) newRecord.getPopulatedFieldsAsMap( ).get( 'Name' );
                        }
                        //NEXI-138 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 28/06/2019 Start fix for insert
                        else if ( newRecord.getPopulatedFieldsAsMap( ).containsKey( 'FirstName' ) && newRecord.getPopulatedFieldsAsMap( ).containsKey( 'LastName' ) )
                        {
                            newObjectWrapper.objectLabel = newRecord.getPopulatedFieldsAsMap( ).get( 'FirstName' ) + ' ' + newRecord.getPopulatedFieldsAsMap( ).get( 'LastName' );
                        }
                        //NEXI-138 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 28/06/2019 Stop fix for insert
                        //NEXI-91 grzegorz.banach@accenture.com 24/06/2019 START used 'else-if' to avoid regression, maybe else part in that case may be not necessary
                        else if ( String.isBlank( ( String ) newRecord.getPopulatedFieldsAsMap( ).get( 'Id' ) ) )
                        {
                            newObjectWrapper.objectLabel = newRecord.getSObjectType( ).getDescribe( ).getLabel( );
                        }
                        //NEXI-91 grzegorz.banach@accenture.com 24/06/2019 STOP
                        else
                        {
                            newObjectWrapper.objectLabel = mapOfrecordIdString.get( ( String ) newRecord.getPopulatedFieldsAsMap( ).get( 'Id' ) );
                        }
                        if ( oldRecord.getPopulatedFieldsAsMap( ).containsKey( 'Name' ) )
                        {
                            oldObjectWrapper.objectLabel = ( String ) oldRecord.getPopulatedFieldsAsMap( ).get( 'Name' );
                        }
                        //NEXI-91 grzegorz.banach@accenture.com 24/06/2019 START used 'else-if' to avoid regression, maybe else part in that case may be not necessary
                        else if ( String.isBlank( ( String ) oldRecord.getPopulatedFieldsAsMap( ).get( 'Id' ) ) )
                        {
                            oldObjectWrapper.objectLabel = oldRecord.getSObjectType( ).getDescribe( ).getLabel( );
                        }
                        //NEXI-91 grzegorz.banach@accenture.com 24/06/2019 STOP
                        else
                        {
                            oldObjectWrapper.objectLabel = mapOfrecordIdString.get( ( String ) oldRecord.getPopulatedFieldsAsMap( ).get( 'Id' ) );
                        }
                        // NEXI-274 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 27/08/2019 START setting data to simple record
                        ExternalSourceMapping__c tempExternalSourceMapping = externalSourceMappingsByIds.get( oldRecord.Id );
                        if ( OB_UtilityConstants.ANAGRAFICA.equalsIgnoreCase( request.OB_MaintenanceType__c ) &&
                             EXTERNAL_SOURCE_MAPPING.equalsIgnoreCase ( oldObjectWrapper.objecType ) &&
                             !request.OB_isNotIntegrated__c && ( wrap.changeServicePoint || wrap.changeMerchant ) &&
                             tempExternalSourceMapping != null )
                        {
                            CodesWrapper simpleCodesWrapper = new CodesWrapper( );
                            simpleCodesWrapper.recordId = tempExternalSourceMapping.Id;
                            simpleCodesWrapper.companyCode = tempExternalSourceMapping.OB_CustomerCodeClientCode__c;
                            simpleCodesWrapper.servicePointCode = tempExternalSourceMapping.OB_ServicePointCodeShopCode__c;
                            simpleCodesWrapper.source = tempExternalSourceMapping.OB_Source__c;
                            wrap.codesWrappers.add( simpleCodesWrapper );
                        }
                        // NEXI-274 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 27/08/2019 STOP

                        wrap.oldData.add( oldObjectWrapper );
                        wrap.newData.add( newObjectWrapper );
                    }

                    system.debug( '## wrap.oldData: ' + wrap.oldData );
                    system.debug( '## wrap.newData: ' + wrap.newData );
                }
            } catch ( Exception e )
            {
                system.debug( logginglevel.debug, 'Exception in retrieveLogRequest : ' + e.getStackTraceString( ) );
                wrap.errorOccurred = true;
                wrap.errorMessage = e.getStackTraceString( );
            }
            return JSON.serialize( wrap );
            //START - elena.preteni 21/06/2019 added condition coba
        }
        else
        {

            List<Object> mapReducednewDataList = ( List<Object> ) JSON.deserializeUntyped( request.OB_ReducedNewData__c );
            List<Object> mapReducedOldDataList = ( List<Object> ) JSON.deserializeUntyped( request.OB_ReducedOldData__c );
            List<CobaWrapper> cobaWrapList = new List<CobaWrapper>( );
            CobaWrapper cobaWrap = new CobaWrapper( );
            String iban;
            try
            {
                for ( Object mapReducednewData : mapReducednewDataList )
                {
                    Map<String, Object> mappa = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( mapReducednewData ) );
                    if ( mappa.containsKey( 'iban' ) )
                    {
                        iban = String.valueOf( mappa.get( 'iban' ) );
                        break;
                    }
                }
                cobaWrap.newIban = iban;
                cobaWrap.isCoba = true;
                for ( Object mapReducedOldData : mapReducedOldDataList )
                {
                    Map<String, Object> mappa = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( mapReducedOldData ) );
                    if ( mappa.containsKey( 'iban' ) )
                    {
                        cobaWrap.oldIban = String.valueOf( mappa.get( 'iban' ) );
                    }
                    if ( mappa.containsKey( 'terminalId' ) )
                    {
                        cobaWrap.termId = String.valueOf( mappa.get( 'terminalId' ) );
                    }
                    if ( mappa.containsKey( 'racSia' ) )
                    {
                        cobaWrap.racsia = String.valueOf( mappa.get( 'racSia' ) );
                    }
                    cobaWrapList.add( cobaWrap );
                }
            } catch ( Exception e )
            {
                system.debug( logginglevel.debug, 'Exception in retrieveLogRequest : ' + e.getStackTraceString( ) );
                wrap.errorOccurred = true;
                wrap.errorMessage = e.getStackTraceString( );
            }
            return JSON.serialize( cobaWrapList );
        }
    }
    //15-01-2019--S.P.--CHECK CURRENT PROFILE IS AVAIABLE TO ACCEPT OR REJECT LOG REQUEST--END

    /*****************************************************************
    Purpose: Get Log Request values
    Parameters: String logRequestId
    Returns: OB_LOgRequest__c logRequest

    History
    --------
    VERSION AUTHOR 				DATE 		DETAIL 		Description
    1.0 	Salvatore Pianura 	03/05/2019 	Created 	CSR:
    *****************************************************************/
    @AuraEnabled
    public static OB_LogRequest__c getLogRequest( String logRequestId )
    {
        OB_LogRequest__c logRequest = new OB_LogRequest__c( );
        List<OB_LogRequest__c> listOfLogRequest = new List<OB_LogRequest__c>( );
        listOfLogRequest =
        [
                SELECT Id,
                        OB_SIAToBeApproved__c,
                        OB_EquensMoneticaToBeApproved__c
                FROM OB_LogRequest__c
                WHERE Id = :logRequestId
                LIMIT 1
        ];
        if ( !listOfLogRequest.isEmpty( ) )
        {
            logRequest = listOfLogRequest.get( 0 );
        }
        return logRequest;
    }

    /*****************************************************************
    Purpose: Update log Request and related Object when is confirmed SIA
    Parameters: OB_LogRequest__C logRequest
    Returns: String outcome

    History
    --------
    VERSION AUTHOR 				DATE 		DETAIL 		Description
    1.0 	Salvatore Pianura 	06/05/2019 	Created 	CSR:
    *****************************************************************/
    @AuraEnabled
    public static String updateRequestSia( OB_LogRequest__c logRequest )
    {
        System.debug( '@Into updateRequestSia()' );
        String outcome;
        logRequest.OB_SIAToBeApproved__c = false;
        if ( !logRequest.OB_EquensMoneticaToBeApproved__c )
        {
            logRequest.OB_Status__c = OB_UtilityConstants.CONFERMATO;
            outcome = OB_Maintenance_View_Request_Controller.acceptLogRequestFinal( logRequest.Id );
            OB_Utility.serializeAnagrafica( logRequest.Id );
            System.debug( 'UPDATE OBJECT FROM OB_Maintenance_View_Request: ' + outcome );
        }
        update logRequest;
        return outcome;
    }

    /*****************************************************************
    Purpose: Update log Request and related Object when is confirmed Equens or Monetica
    Parameters: OB_LogRequest__C logRequest
    Returns: String outcome

    History
    --------
    VERSION AUTHOR 				DATE 		DETAIL 		Description
    1.0 	Salvatore Pianura 	06/05/2019 	Created 	CSR:
    *****************************************************************/
    @AuraEnabled
    public static String updateRequestEwMonetica( OB_LogRequest__c logRequest )
    {
        System.debug( '@Into updateRequestEwMonetica()' );
        String outcome;
        logRequest.OB_EquensMoneticaToBeApproved__c = false;
        if ( !logRequest.OB_SIAToBeApproved__c )
        {
            logRequest.OB_Status__c = OB_UtilityConstants.CONFERMATO;
            outcome = OB_Maintenance_View_Request_Controller.acceptLogRequestFinal( logRequest.Id );
            OB_Utility.serializeAnagrafica( logRequest.Id );
            System.debug( 'UPDATE OBJECT FROM OB_Maintenance_View_Request: ' + outcome );
        }
        update logRequest;
        return outcome;
    }

    //END - elena.preteni 21/06/2019 added condition coba
    //  } catch ( Exception e )
    //  {
    //      system.debug( logginglevel.debug, 'Exception in retrieveLogRequest : ' + e.getStackTraceString( ) );
    //      wrap.errorOccurred = true;
    //      wrap.errorMessage = e.getStackTraceString( );
    //  }
    // return '';


    private static final list<string> fieldToSkip = new list<string> {'Id', 'RecordTypeId', 'AccountId', 'OB_BypassValidation__c', 'OB_Bank__c'}; // list of field  name , the field into this list are not showed into the UI

    /*
    *	author : claudio Quaranta
    * 	Date : 28/11/2018
    *	Description : method used to estract fields label and schema
    *	input : fieldsValues : a map of fields Developername --  values,
                fieldsSchema : a map of fields Developername - DescribeFieldResult
        output : ist<rowWrapper> : a list of wrapper describing the single row.
    */
    @testvisible
    private static list<rowWrapper> estractRowSpecification( Map<String, Object> fieldsValues, Map<String, Schema.DescribeFieldResult> fieldsSchema )
    {
        list<rowWrapper> listOfRow = new list<rowWrapper>( );
        Integer startingPoint = 100;
        for ( string fieldname : fieldsValues.keyset( ) )
        {
            if ( !fieldToSkip.contains( fieldname ) )
            {
                rowWrapper wrap = new rowWrapper( );
                wrap.label = fieldsSchema.get( fieldname ).getLabel( );
                wrap.value = fieldsValues.get( fieldname );

                //	START 	micol.ferrari 21/12/2018
                wrap.apiname = fieldname;
                //	END 	micol.ferrari 21/12/2018

                //	START 	micol.ferrari 08/01/2019
                wrap.datatype = OB_UtilityConstants.BOOLEANVALUES_LIST.contains( fieldname ) ? 'BOOLEAN' : 'STRING';
                //	END 	micol.ferrari 08/01/2019
                /*ANDREA START 2019.01.10*/
                wrap.sequence = OB_UtilityConstants.SEQUENCE_SORTING_MAP.containsKey( fieldname ) ? OB_UtilityConstants.SEQUENCE_SORTING_MAP.get( fieldName ) : startingPoint;

                startingPoint += 1;
                listOfRow.add( wrap );
            }
        }
        List<rowWrapper> listOfRowToReturn = new List<rowWrapper>( );
        listOfRowToReturn = OB_Maintenance_View_Request_Controller.sequenceRowWrapper( listOfRow );
        return listOfRowToReturn;
        /*ANDREA END 2019.01.10*/
        //return listOfRow;
    }

    //	START 	micol.ferrari 17/12/2018
    public static Time ParseTime( String timeString )
    {
        if ( timeString != null && timeString != '' && timeString != 'SKIP' )
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

    @AuraEnabled
    public static List<String> getBooleanValueToCheck( )
    {
        return OB_UtilityConstants.BOOLEANVALUES_LIST;
    }

    /*ANDREA START 2019.01.10*/
    private static list<rowWrapper> sequenceRowWrapper( list<rowWrapper> rowWrapperList )
    {
        List<rowWrapper> rwrap = new List<rowWrapper>( );
        List<Integer> listSequence = new List<Integer>( );

        Map<Integer, rowWrapper> mapForSequence = new Map<Integer, rowWrapper>( );

        for ( rowWrapper row : rowWrapperList )
        {
            mapForSequence.put( row.sequence, row );
        }
        listSequence.addAll( mapForSequence.keySet( ) );
        listSequence.sort( );

        for ( Integer i = 0; i < listSequence.size( ); i++ )
        {
            rwrap.add( mapForSequence.get( listSequence[ i ] ) );
        }
        return rwrap;
        //OB_UtilityConstants.sequenceSortingField
    }
    /*ANDREA END 2019.01.10*/

    //15-01-2019--S.P.--CHECK CURRENT PROFILE IS AVAIABLE TO ACCEPT OR REJECT LOG REQUEST--START
    @AuraEnabled
    public static Boolean checkProfile( String logrequestId )
    {
        Boolean toReturn = false;
        String userId = UserInfo.getUserId( );
        list<User> listOfUsers =
        [
                SELECT Id, Profile.Name, Profile.UserLicense.Name
                FROM User
                WHERE Id = :userId
                LIMIT 1
        ];
        if ( !listOfUsers.isEmpty( ) )
        {
            User user = listOfUsers.get( 0 );
            String profile = user.Profile.Name;
            System.debug( 'profile:  ' + profile );
            String confInfProfiles;
            Boolean profileIsInConfInf = false;
            OB_ConfigurationInformation__mdt configurationInformation = new OB_ConfigurationInformation__mdt( );
            OB_ConfigurationInformation__mdt[] listOfConfigurationInformations =
            [
                    SELECT Id,MasterLabel,Label,QualifiedApiName,OB_String_Value__c
                    FROM OB_ConfigurationInformation__mdt
                    WHERE QualifiedApiName = :System.Label.OB_CheckProfilesAcceptRejectLogRequest
            ];
            if ( !listOfConfigurationInformations.isEmpty( ) )
            {
                configurationInformation = listOfConfigurationInformations.get( 0 );
                confInfProfiles = configurationInformation.OB_String_Value__c;
                System.debug( '@confInfProfiles : ' + confInfProfiles );
                profileIsInConfInf = confInfProfiles.contains( profile );
                System.debug( '@profileIsInConfInf : ' + profileIsInConfInf );
            }

            if ( profileIsInConfInf == true )
            {
                toReturn = true;
            }
        }

        return toReturn;
    }
    //15-01-2019--S.P.--CHECK CURRENT PROFILE IS AVAIABLE TO ACCEPT OR REJECT LOG REQUEST--END

    /***********************************************************************************
    Purpose: Method to get External Source Mapping objects
    Parameters: Set<Id> inExternalSourceMappingsIds
    Returns: Map<Id, ExternalSourceMapping__c>

    History
    --------
    VERSION      AUTHOR 				        DATE 		    DETAIL 		Description
    1.0 	     Marlena Lukomska-Rogala 	    30/07/2019 	    Created     NEXI-240
    1.1	         Joanna Mielczarek        	    27/08/2019 	    Modified    NEXI-274 changed returned object
    ***********************************************************************************/
    private static Map<Id, ExternalSourceMapping__c> getExternalSourceMappings( Set<Id> inExternalSourceMappingsIds )
    {
        Map<Id, ExternalSourceMapping__c> outESMsByIds = new Map<Id, ExternalSourceMapping__c>( );
        for ( ExternalSourceMapping__c loopEsm :
        [
                SELECT OB_CustomerCodeClientCode__c,
                        OB_ServicePointCodeShopCode__c,
                        OB_Source__c    //19/08/19 francesca.ribezzi - F2WAVE2-176 - adding source field
                FROM ExternalSourceMapping__c
                WHERE Id IN :inExternalSourceMappingsIds
        ] )
        {
            outESMsByIds.put( loopEsm.Id, loopEsm );
        }
        return outESMsByIds;
    }
}