public with sharing class OB_Maintenance_AttachedDocs_CC
{
    @AuraEnabled
    public static Map<String, String> retrieveInfos( String logRequestId )
    {
        System.debug( 'INTO RETRIEVE INFO' );
        System.debug( 'LOG REQUEST ID: ' + logRequestId );
        Map<String, String> infoToReturn = new Map<String, String>( );
        //  RETRIEVE THE CURRENT PROFILE NAME
        List<User> listOfUsers =
        [
                SELECT Id, Profile.UserLicense.Name, Profile.Name
                FROM User
                WHERE Id = :UserInfo.getUserId( )
                LIMIT 1
        ];
        System.debug( 'LIST OF USER: ' + listOfUsers );
        //  RETRIEVE THE CURRENT RECORD OF LOG REQUEST
        List<OB_LogRequest__c> listOfLogRequest = new List<OB_LogRequest__c>( );
        listOfLogRequest = OB_Maintenance_AttachedDocs_CC.retrieveLogRequests( logRequestId );
        System.debug( 'listOfLogRequest: ' + listOfLogRequest );
        if ( !listOfUsers.isEmpty( ) && !listOfLogRequest.isEmpty( ) )
        {
            OB_LogRequest__c logRequest = listOfLogRequest.get( 0 );
            infoToReturn.put( 'LICENSE', listOfUsers.get( 0 ).Profile.UserLicense.Name );
            infoToReturn.put( 'MERCHANT', logRequest.OB_AccountId__c );
            infoToReturn.put( 'SERVICEPOINT', logRequest.OB_ServicePointId__c );
            infoToReturn.put( 'EDITSERVICEPOINT', String.valueOf( logRequest.OB_ChangeServicePointData__c ) );
            infoToReturn.put( 'STATUS', logRequest.OB_Status__c );
            infoToReturn.put( 'REJECTREASON', logRequest.OB_RejectReason__c );
            infoToReturn.put( 'PROFILE', listOfUsers.get( 0 ).Profile.Name );
            infoToReturn.put( 'OWNER', logRequest.Owner.Profile.name );
            infoToReturn.put( 'SAVEASDRAFT', String.valueOf( logRequest.OB_Save_as_Draft__c ) ); //NEXI-259 Marta Stempien <marta.stempien@accenture.com> 08/08/2019 Added param to map
            //NEXI-131 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 27/06/2019 Start
            infoToReturn.putAll( checkIfTEChanged( logRequest ) );
            if ( listOfLogRequest.get( 0 ).OB_ChangeCompanyData__c )
            {
                infoToReturn.put( 'isSaeAtecoChanged', 'true' );
            }
            //NEXI-131 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 27/06/2019 Stop
        }
        System.debug( 'RETURN: ' + infoToReturn );
        return infoToReturn;
    }

    /*******************************************************************************
    Purpose:  Method check if it is update insert or delete scenario for TE
    Parameters: OB_LogRequest__c inLogRequest
    Returns: Map<String, String>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       27/06/2019      Created         NEXI-131
    ********************************************************************************/
    private static Map<String, String> checkIfTEChanged( OB_LogRequest__c inLogRequest )
    {
        Map<String, String> result = new Map<String, String>( );
        Boolean isTEEDIT = false;
        if ( !inLogRequest.OB_Change_of_data_of_beneficial_owners__c )
        {
            result.put( 'isTEEDIT', 'false' );
            result.put( 'showComponent', 'true' );
            return result;
        }
        OB_Util006_MaintenanceAnagrafica.DeserializedLogRequestContent dDeserializedLogRequestContent = new OB_Util006_MaintenanceAnagrafica.DeserializedLogRequestContent( inLogRequest );
        Boolean isInsert = false;
        for ( Integer i = 0; i < dDeserializedLogRequestContent.newContactLists.size( ); i++ )
        {
            if ( String.isBlank( dDeserializedLogRequestContent.newContactLists.get( i ).Id ) )
            {
                if ( String.isBlank( dDeserializedLogRequestContent.oldContactLists.get( i ).Id ) )
                {
                    isInsert = true;
                }
            }
            else
            {
                if ( OB_Util006_MaintenanceAnagrafica.checkContactIsAfterModification( dDeserializedLogRequestContent.oldContactLists.get( i ), dDeserializedLogRequestContent.newContactLists.get( i ) ) )
                {
                    result.put( 'isTEEDIT', 'true' );
                    result.put( 'showComponent', 'true' );
                    return result;
                }
            }
        }

        if ( isInsert )
        {
            result.put( 'isTEEDIT', 'false' );
            result.put( 'showComponent', 'true' );
        }
        else
        {
            result.put( 'isTEEDIT', 'false' );
            result.put( 'showComponent', 'false' );
        }
        return result;
    }

    /*******************************************************************************
    Purpose:  Facade for old signature of function getProductDocumentsServer
    Parameters: String logRequestId
    Returns: Map<String, String>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       10/06/2019      Created         NEXI-97
    ********************************************************************************/
    @AuraEnabled
    public static Map<String, String> getProductDocumentsServer( String logRequestId )
    {
        return getProductDocumentsServer( logRequestId, false, false );
    }

    @AuraEnabled
    public static Map<String, String> getProductDocumentsServer( String logRequestId, Boolean isSaeAtecoChanged, Boolean isTEEdit ) //NEXI-97 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 10/06/2019 add isSaeAtecoChanged
    {
        //NEXI-97 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 10/06/2019 Start
        isSaeAtecoChanged = isSaeAtecoChanged == null ? false : isSaeAtecoChanged;
        //NEXI-97 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 10/06/2019 Stop
        //NEXI-60 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 19/06/2019 Start
        isTEEdit = isTEEdit == null ? false : isTEEdit;
        //NEXI-60 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 19/06/2019 Stop
        Map<String, String> documentsMap = new Map<String, String>( );
        try
        {
            //  RETRIEVE THE LIST OF SPECIAL CATEGORY CONFIGURATIONS
            List<OB_Special_Category_Configuration__c> listToFilter = new List<OB_Special_Category_Configuration__c>( );
            listToFilter =
            [
                    SELECT Name,OB_ATECO__c,OB_Commercial_Product__c,
                            OB_DocRequired__c,OB_isCrowdfunding__c,OB_DescriptionNoVat__c,
                            OB_Legal_Form__c,OB_MCC__c,RecordType.DeveloperName,OB_EngineCodeCommercialProduct__c,OB_RequestType__c
                    FROM OB_Special_Category_Configuration__c
                    WHERE OB_DocRequired__c = true
                    AND OB_RequestType__c = 'Maintenance'
            ];

            //  RETRIEVE THE LIST OF PRODUCT DOCUMENTS
            List<OB_Product_Document__c> documents = new List<OB_Product_Document__c>( );
            documents =
            [
                    SELECT Name, OB_Description__c, OB_Commercial_Product__r.Name,
                            OB_Commercial_Product__c,OB_DocumentCode__c,OB_Start_Date__c,
                            OB_End_Date__c,OB_Client_Type__c,OB_Request_Typology__c,
                            OB_Document_Typology__c,OB_Multiple_upload__c,OB_Business_Model__c
                    FROM OB_Product_Document__c
                    WHERE OB_Request_Typology__c = 'Maintenance'
            ];


            system.debug( 'documents -->' + documents );
            //  RETRIEVE THE CURRENT RECORD OF LOG REQUEST
            List<OB_LogRequest__c> listOfLogRequest = new List<OB_LogRequest__c>( );
            listOfLogRequest = OB_Maintenance_AttachedDocs_CC.retrieveLogRequests( logRequestId );
            //elena.preteni 20/02/19 legal form new upload docs
            List<Map<String, Object>> newlistOfMaps = new List<Map<String, Object>>( );
            String legalFormNew = '';
            String MCCNew = null;                     //NEXI-65 Wojciech Kucharek <wojciech.kucharek@accenture.com> 13/06/2019
            Map<String, Object> mapReducednewData = ( Map<String, Object> ) JSON.deserializeUntyped( listOfLogRequest.get( 0 ).OB_ReducedNewData__c );
            system.debug( '## mapReducednewData: ' + mapReducednewData );
            system.debug( '## obj: ' + mapReducednewData.get( 'obj' ) );
            List<Object> newlistOfObjs = ( List<Object> ) JSON.deserializeUntyped( JSON.serialize( mapReducednewData.get( 'obj' ) ) );
            system.debug( '## newlistOfObjs: ' + newlistOfObjs );
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

                    if ( attributesmap.containsKey( 'type' ) && attributesmap.get( 'type' ) == 'Account' )
                    {
                        if ( singlemap.containsKey( 'OB_Legal_Form__c' ) )
                        {
                            legalFormNew = ( String ) singlemap.get( 'OB_Legal_Form__c' );
                        }
                    }

                }
                //NEXI-65 Wojciech Kucharek <wojciech.kucharek@accenture.com> 13/06/2019 START
                if ( singlemap.containsKey( 'OB_MCC__c' ) )
                {
                    MCCNew = String.valueOf( singlemap.get( 'OB_MCC__c' ) );
                }
                //NEXI-65 Wojciech Kucharek <wojciech.kucharek@accenture.com> 13/06/2019 STOP
            }
            //elena.preteni 20/02/19 legal form new upload docs
            //  DO EVERYTHING ONLY IF THE LOG REQUEST HAS BEEN RETRIEVED
            List<String> clientTypes;//NEXI-97 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 10/06/2019 Move variable to have wider presence
            if ( !listOfLogRequest.isEmpty( ) )
            {
                //  GET THE VALUES IN ORDER TO GET CLIENT TYPE SET
                String servicePointId = listOfLogRequest.get( 0 ).OB_ServicePointId__c;
                String accountId = listOfLogRequest.get( 0 ).OB_AccountId__c;
                //String vatNotPresent              = listOfLogRequest.get(0).OB_AccountId__r.OB_DescriptionVATNotPresent__c;
                String ateco = listOfLogRequest.get( 0 ).OB_AccountId__r.OB_ATECO__c;
                // String legalForm                    = listOfLogRequest.get(0).OB_AccountId__r.OB_Legal_Form__c;
                String legalForm = (legalFormNew =='') ? listOfLogRequest.get(0).OB_AccountId__r.OB_Legal_Form__c : legalFormNew; //antonio.vatrano wn_109 16/07/2019
                //Boolean isCrowdfunding            = listOfLogRequest.get(0).OB_AccountId__r.OB_IsCrowdfunding__c;
                String mcc = MCCNew;           //NEXI-65 Wojciech Kucharek <wojciech.kucharek@accenture.com> 13/06/2019

                List<NE__OrderItem__c> orderItems = null;
                //NEXI-97 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 07/06/2019 Start
                orderItems =
                [
                        SELECT id,
                                NE__ProdId__r.Id,
                                NE__Parent_Order_Item__c,
                                NE__Parent_Order_Item__r.Id,
                                NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName,
                                NE__ProdId__r.OB_Codice_sfdc__c,
                                NE__Action__c,
                                NE__OrderId__c,
                                NE__ProdId__r.NE__Engine_Code__c
                        FROM NE__OrderItem__c
                        WHERE NE__Account__c = :listOfLogRequest.get( 0 ).OB_AccountId__c
                ];
                //NEXI-97 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 07/06/2019 Stop
                //  RETRIEVE BUSINESS MODEL FROM BANK PROFILE OF THE BANK TAKEN FROM THE ABI OF THE LOG REQUEST
                System.debug( 'listOfLogRequest.get(0).OB_ABI__c: ' + listOfLogRequest.get( 0 ).OB_ABI__c );
                List<OB_Bank_Profile__c> listOfBankProfiles = new List<OB_Bank_Profile__c>( );
                listOfBankProfiles =
                [
                        SELECT Id,OB_Business_Model_Acquiring__c,OB_Business_Model_POS__c
                        FROM OB_Bank_Profile__c
                        WHERE OB_Bank__r.OB_ABI__c = :listOfLogRequest.get( 0 ).OB_ABI__c
                ];
                System.debug( 'listOfBankProfiles: ' + listOfBankProfiles );
                Set<String> businessModel = new Set<String>( );
                if ( !listOfBankProfiles.isEmpty( ) )
                {
                    businessModel.add( listOfBankProfiles.get( 0 ).OB_Business_Model_Acquiring__c );
                    businessModel.add( listOfBankProfiles.get( 0 ).OB_Business_Model_POS__c );
                }
                System.debug( 'businessModel: ' + businessModel );
                //  GET THE CLIENT TYPE SET

                //  START   micol.ferrari 13/12/2018 - PASSING TO GETCLIENTTYPESET THE LIST OF LOG TYPE
                List<String> listOfLogTypes = new List<String>( );
                if ( listOfLogRequest.get( 0 ).OB_ChangeMerchantName__c )
                    listOfLogTypes.add( Label.OB_MAINTENANCE_CHANGEMERCHANTNAME );
                if ( listOfLogRequest.get( 0 ).OB_ChangeCompanyData__c )
                    listOfLogTypes.add( Label.OB_MAINTENANCE_CHANGECOMPANYDATA );
                if ( listOfLogRequest.get( 0 ).OB_ChangeLegalForm__c )
                    listOfLogTypes.add( Label.OB_MAINTENANCE_CHANGELEGALFORM );
                if ( listOfLogRequest.get( 0 ).OB_NewLegalRepresentative__c )
                    listOfLogTypes.add( Label.OB_MAINTENANCE_NEWLEGAL );
                if ( listOfLogRequest.get( 0 ).OB_ChangeLegalRepresentative__c )
                    listOfLogTypes.add( Label.OB_MAINTENANCE_CHANGELEGAL );
                if ( listOfLogRequest.get( 0 ).OB_ChangeServicePointData__c )
                    listOfLogTypes.add( Label.OB_MAINTENANCE_CHANGESERVICEPOINT );
                if ( listOfLogTypes.isEmpty( ) )
                    listOfLogTypes = null;
                //  END     micol.ferrari 13/12/2018 - PASSING TO GETCLIENTTYPESET THE LIST OF LOG TYPE

                system.debug( 'listOfLogTypes: ' + listOfLogTypes );
                // e.p 06/03/19 gambling per maintenance
                Set<String> clientTypeSet = OB_UtilityCallingServices.getClientTypeSet( listToFilter, orderItems, mcc, ateco, legalForm, accountId, listOfLogTypes, listOfLogRequest.get( 0 ).OB_ABI__c, 'Maintenance', false );//NEXI-32 Customer DS-4 & FG-4 grzegorz.banach@accenture.com 13/05/2019
                clientTypes = new List<String>( );
                clientTypes.addAll( clientTypeSet );
                system.debug( 'clientTypes: ' + clientTypes );

                // start antonio.vatrano 03/05/2019 R1F2-82 SHORTCUT MAINTENANCE skip businessModel for Operation
                string nameProfile = '';
                if ( businessModel.isEmpty( ) )
                {
                    List<User> listOfUsers =
                    [
                            SELECT Id, Profile.UserLicense.Name, Profile.Name
                            FROM User
                            WHERE Id = :UserInfo.getUserId( )
                            LIMIT 1
                    ];
                    nameProfile = listOfUsers.get( 0 ).Profile.Name;
                    System.debug( 'LIST OF USER: ' + listOfUsers + '   Profile: ' + nameProfile );
                }
                // end antonio.vatrano 03/05/2019 SHORTCUT R1F2-82 MAINTENANCE skip businessModel for Operation

                //  LOOP ON THE PRODUCT DOCUMENTS MATCHING WITH THE CURRENT BUSINESS MODEL AND THE REQUEST TYPOLOGY
                List<OB_Product_Document__c> filteredDocuments = new List<OB_Product_Document__c>( );
                if ( !documents.isEmpty( ) )
                {
                    for ( OB_Product_Document__c mydoc : documents )
                    {
                        system.debug( 'mydoc: ' + mydoc );
                        system.debug( 'mydoc.OB_Client_Type__c: ' + mydoc.OB_Client_Type__c );
                        system.debug( 'clientTypes.contains(mydoc.OB_Client_Type__c)' + clientTypes.contains( mydoc.OB_Client_Type__c ) );

                        if ( clientTypes.contains( mydoc.OB_Client_Type__c ) ) // && mydoc.OB_Request_Typology__c=='Maintenance')
                        {
                            // start antonio.vatrano 03/05/2019 R1F2-82 SHORTCUT MAINTENANCE skip businessModel for Operation
                            if ( nameProfile != 'Operation' )
                            {
                                for ( String bm : businessModel )
                                {
                                    if ( mydoc.OB_Business_Model__c.contains( bm ) )
                                    {
                                        filteredDocuments.add( mydoc );
                                    }
                                }
                            }
                            else
                            {
                                filteredDocuments.add( mydoc );
                            }
                            // end antonio.vatrano 03/05/2019 R1F2-82 SHORTCUT MAINTENANCE skip businessModel for Operation
                        }
                    }
                }

                system.debug( 'filteredDocuments: ' + filteredDocuments );

                //  POPULATE THE DOCUMENTS MAP
                Set<String> documentsNameUtility = new Set<String>( );
                List<String> documentsName = new List<String>( );

                Map<String, String> innerDocumentsMap = new Map<String, String>( );
                for ( OB_Product_Document__c docElement : filteredDocuments )
                {
                    innerDocumentsMap.put( docElement.OB_Description__c, docElement.OB_Document_Typology__c + ':' + docElement.OB_Multiple_upload__c );
                }
                documentsName.addAll( documentsNameUtility );

                documentsMap = innerDocumentsMap;
            }

            system.debug( 'documentsMap ' + documentsMap );
            //NEXI-97 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 10/06/2019 Start
            if ( isSaeAtecoChanged )
            {
                Map<String, List<OB_Product_Document__c>> productDocumentsByName = OB_Util006_MaintenanceAnagrafica.prepareDocumentMapByNames
                        (
                                OB_Util006_MaintenanceAnagrafica.DOCUMENT_SAE_ATECO,
                                OB_Util006_MaintenanceAnagrafica.DOCUMENT_SAE_ATECO_DESCRIPTIONS
                        );
                for ( String loopDocumentName : OB_Util006_MaintenanceAnagrafica.DOCUMENT_SAE_ATECO )
                {
                    OB_Util006_MaintenanceAnagrafica.addDocument( loopDocumentName, productDocumentsByName, documentsMap, clientTypes );
                }
            }
            //NEXI-97 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 10/06/2019 Stop
            if ( listOfLogRequest.get( 0 ).OB_Change_of_data_of_beneficial_owners__c )
            {
                List<String> teDocumentsNames;
                List<String> teDocumentsTypology; 
                if ( isTEEdit )
                {
                    teDocumentsNames = OB_Util006_MaintenanceAnagrafica.DOCUMENT_TE;
                    teDocumentsTypology = OB_Util006_MaintenanceAnagrafica.DOCUMENT_TE_DESCRIPTIONS;
                }
                else
                {
                    teDocumentsNames = OB_Util006_MaintenanceAnagrafica.DOCUMENT_TE_ADD;
                    teDocumentsTypology = OB_Util006_MaintenanceAnagrafica.DOCUMENT_TE_DESCRIPTIONS_ADD;
                }
                Map<String, List<OB_Product_Document__c>> productDocumentsByName = OB_Util006_MaintenanceAnagrafica.prepareDocumentMapByNames( teDocumentsNames, teDocumentsTypology );
                //NEXI-135 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 28/06/2019 Start
                Map<String, String> documentMapForTEUpdate = new Map<String, String>( );
                //NEXI-153 Wojciech Kucharek<wojciech.kucharek@accenture.com>, 04/07/2019 - deleted if/else for condition isTEEdit
                for ( String loopDocumentName : teDocumentsNames )
                {
                    //elena.preteni missing code
                     //NEXI-407 Marta Stempien <marta.stempien@accenture.com> 07/11/2019 Start
                    if ( productDocumentsByName.get( loopDocumentName ) == null )
                    {
                        continue;
                    }
                   
                    //NEXI-407 Marta Stempien <marta.stempien@accenture.com> 07/11/2019 Stop
                    //elena.preteni missing code
                    for ( OB_Product_Document__c loopProductDocument : productDocumentsByName.get( loopDocumentName ) )
                    {
                        documentMapForTEUpdate.put( loopProductDocument.OB_Description__c, loopProductDocument.OB_Document_Typology__c + ':' + loopProductDocument.OB_Multiple_upload__c );
                    }
                }
                documentsMap = documentMapForTEUpdate;
                //NEXI-135 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 28/06/2019 Stop
            }
        } catch ( Exception ecc )
        {
            System.debug( 'Generic Error: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
        }
        return documentsMap;
    }

    @AuraEnabled
    public static String serverGetDocumentListId( String logRequestId )
    {
        //  START   micol.ferrari 17/01/2019 - GET CURRENT ORG NAME
        //String environment = !Test.isRunningTest() ? system.Label.OB_Environment : 'DEV1';
        String environment = !Test.isRunningTest( ) ? OB_UtilityCallingServices.returnCurrentOrg( ) : 'DEV1';
        //  END     micol.ferrari 17/01/2019 - GET CURRENT ORG NAME

        OB_Integration_Configuration__c intConfig = OB_Integration_Configuration__c.getValues( environment );

        //  RETRIEVE THE CURRENT RECORD OF LOG REQUEST
        List<OB_LogRequest__c> listOfLogRequest = new List<OB_LogRequest__c>( );
        listOfLogRequest = OB_Maintenance_AttachedDocs_CC.retrieveLogRequests( logRequestId );

        String mapDocId = null;

        //  DO EVERYTHING ONLY IF THE LOG REQUEST HAS BEEN RETRIEVED
        if ( !listOfLogRequest.isEmpty( ) )
        {
            String merchantId       = listOfLogRequest.get(0).OB_AccountId__c;
            String salesPointId     = listOfLogRequest.get(0).OB_ServicePointId__c;
            String traceIdHeader    = String.valueof(DateTime.now()).replaceAll(' ','T')+'M'+merchantId;//+'S'+salesPointId+'C'+orderId;
            String url          = 'callout:OB_callService/api/merchants/'+merchantId+'/requests/'+logRequestId+'/documents?documentStatus=ACTIVE';//giovanni spinelli 26/06/2019 retrieve only active docs to improve efficiency 
            if (salesPointId!=null && salesPointId!='')
            {
                traceIdHeader   += 'S'+salesPointId;
                url             = 'callout:OB_callService/api/merchants/'+merchantId+'/sales-points/'+salesPointId+'/requests/'+logRequestId+'/documents?documentStatus=ACTIVE';//giovanni spinelli 26/06/2019 retrieve only active docs to improve efficiency
            }

            HttpRequest req = new HttpRequest( );
            req.setEndpoint( url );
            req.setMethod( 'GET' );
            String token = OB_UtilityCallingServices.checkToken( );
            req.setHeader( OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX + token );
            req.setHeader( 'Content-Type', 'application/json' );
            req.setHeader( OB_UtilityConstants.TRACE_ID_HEADER, traceIdHeader );
            // start spinelli.giovanni 05/05/2019  increase timeout from 30 sec to 60 sec
            req.setTimeout( 60000 );
            // end spinelli.giovanni 05/05/2019  increase timeout from 30 sec to 60 sec
            if ( intConfig.OB_CAsigned_name__c != null )
            {
                req.setClientCertificateName( intConfig.OB_CAsigned_name__c );
            }
            Http http           = new Http();
            HTTPResponse res    = http.send(req);
            //GIOVANNI SPINELLI 10/07/2019 - catch error - start
           try{
                System.debug('STATUS CODE: ' + res.getStatusCode());
                if(res.getStatusCode()!= 200){
                    mapDocId ='ERROR';
                }else{
                    mapDocId = res.getBody();
                }
            }catch(CalloutException e){
                System.debug('CalloutException: ' + e.getMessage());
                mapDocId ='ERROR';
            }
            //GIOVANNI SPINELLI 10/07/2019 - catch error - end
        }
        return mapDocId;
    }

    @AuraEnabled
    public static List<OB_LogRequest__c> retrieveLogRequests( String logRequestId )
    {
        List<OB_LogRequest__c> listOfLogRequest = new List<OB_LogRequest__c>( );
        //NEXI-259 Marta Stempien <marta.stempien@accenture.com> 08/08/2019 Added OB_Save_as_Draft__c to QUERY
        listOfLogRequest = 
        [
                SELECT Id,Name,OB_ABI__c,OB_AccountId__c,OB_ApprovalProcess__c,OB_CAB__c,
                        OB_ChangeCompanyData__c,OB_ChangeLegalForm__c,
                        OB_ChangeLegalRepresentative__c,OB_ChangeMerchantName__c,
                        OB_ChangeServicePointData__c,OB_CheckDate__c,OB_MaintenanceType__c,
                        OB_NewLegalRepresentative__c,OB_ReducedNewData__c,
                        OB_ReducedOldData__c,OB_RejectReason__c,OB_RequestDate__c,
                        OB_Requestor__c,OB_ServicePointId__c,OB_Status__c,
                        OB_Save_as_Draft__c,
                        OB_AccountId__r.OB_ATECO__c,OB_AccountId__r.OB_Legal_Form__c,
                        OB_AccountId__r.OB_IsCrowdfunding__c,OB_AccountId__r.OB_DescriptionVATNotPresent__c,
                        OB_AccountId__r.OB_Bank_Owner__c,OB_LogType__c, Owner.Profile.name,OB_Change_of_data_of_beneficial_owners__c
                FROM OB_LogRequest__c
                WHERE Id = :logRequestId
        ];
        System.debug( '@@logrequest' + listOfLogRequest );
        return listOfLogRequest;
    }
}