public without sharing class OB_OrderTriggerHandler
{
    public OB_OrderTriggerHandler( )
    {

    }

    //	START	micol.ferrari 15/02/2019
    public void createLogRequestAfterPricing( Map<Id, NE__Order__c> oldOrds, Map<Id, NE__Order__c> newOrds )
    {
        System.debug( 'INSIDE OB_OrderTriggerHandler.createLogRequestAfterPricing' );
        Map<Id, NE__Order__c> mapToUpdate = new Map<Id, NE__Order__c>( );
        Map<Id, OB_LogRequest__c> mapOfLR = new Map<Id, OB_LogRequest__c>( );
        Id rtPricing = Schema.SObjectType.OB_LogRequest__c.getRecordTypeInfosByDeveloperName( ).get( 'OB_Pricing' ).getRecordTypeId( );
        System.debug( 'oldOrds are : ' + oldOrds );
        System.debug( 'newOrds are : ' + newOrds );
        String orderHeaderId ;//Simone Misani 09/07/2019 WN-59-58
        Map<Id, Boolean> mapPOS = new Map<Id, Boolean>( );
        Map<Id, Boolean> mapACQ = new Map<Id, Boolean>( );
        Map<Id, Boolean> mapLRExisting = new Map<Id, Boolean>( );

        if ( oldOrds.size( ) > 0 && newOrds.size( ) > 0 )
        {           
            for ( NE__Order__c conf : newOrds.values( ) )
            {
                System.debug( 'INSIDE CONGFIGURATION ITERATION' );
                System.debug( 'newOrds.values are : ' + newOrds.values( ) );
                System.debug( 'newOrds.keySet() are : ' + newOrds.keySet( ) );
                orderHeaderId= conf.NE__Order_Header__c;//Simone Misani 09/07/2019 WN-59-58
                if ( conf.OB_createLogRequestFromPricing__c &&
                     ( conf.OB_BankApprovalStatus__c == OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_APPROVATO ||
                       conf.OB_BankApprovalStatus__c == OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_RIGETTATO )
                   )
                {
                    System.debug( 'conf are : ' + conf );
                    mapToUpdate.put( conf.Id, conf );
                    mapPOS.put( conf.Id, false );
                    mapACQ.put( conf.Id, false );
                    mapLRExisting.put( conf.Id, false );
                    System.debug( 'mapPOS is : ' + mapPOS );
                    System.debug( 'mapACQ is  : ' + mapACQ );
                    System.debug( 'mapLRExisting is  : ' + mapLRExisting );
                }
            }
            if ( !mapToUpdate.keySet( ).isEmpty( ) )
            {
                List<Id> listOfConfId = new List<Id>( );
                listOfConfId.addAll( mapToUpdate.keySet( ) );
                System.debug( 'listOfConfId are : ' + listOfConfId );

                List<OB_LogRequest__c> existinglogRequests =
                [
                        SELECT Id, Name, OB_OrderId__c
                        FROM OB_LogRequest__c
                        WHERE OB_OrderId__c IN :listOfConfId
                ];
                System.debug( 'existinglogRequests is : ' + existinglogRequests );
                if ( !existinglogRequests.isEmpty( ) )
                {
                    for ( OB_LogRequest__c logreq : existinglogRequests )
                    {
                        if ( mapLRExisting.containsKey( logreq.OB_OrderId__c ) )
                        {
                            mapLRExisting.put( logreq.OB_OrderId__c, true );
                            System.debug( 'mapLRExisting is : ' + mapLRExisting );
                        }
                    }
                }

                Boolean hasAcquiring = false;
                Boolean hasPOS = false;                
                List<NE__OrderItem__c> orderItemPOS =
                [
                        SELECT id,OB_VariationPOSPB__c,NE__OrderId__r.OB_BankApprovalStatus__c, NE__OrderId__r.NE__AccountId__c, NE__OrderId__r.OB_Service_Point__c, NE__OrderId__r.OB_ABI__c, NE__OrderId__r.OB_CAB__c
                        FROM NE__OrderItem__c
                        WHERE
                        NE__OrderId__c IN:listOfConfId
                        AND NE__ProdId__r.RecordType.DeveloperName = 'Pricing'
                        AND NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName IN ('Terminali', 'Pagobancomat')
                        AND ( NE__Action__c = 'Add' OR NE__Action__c = 'Change')
                ];

                System.debug( 'orderItemPOS are : ' + orderItemPOS );
                if ( orderItemPOS != null && !orderItemPOS.isEmpty( ) )
                {                   
                   
                    for ( NE__OrderItem__c singleOI : orderItemPOS )
                    {
                        mapPOS.put( singleOI.NE__OrderId__c, true );
                        System.debug( 'mapACQ.put(singleOI.NE__OrderId__c,true); is: ' + mapPOS );
                    }
                }
                List<NE__OrderItem__c> orderItemAcqVAS =
                [
                        SELECT id,OB_VariationPOSPB__c,NE__OrderId__r.OB_BankApprovalStatus__c, NE__OrderId__r.NE__AccountId__c, NE__OrderId__r.OB_Service_Point__c, NE__OrderId__r.OB_ABI__c, NE__OrderId__r.OB_CAB__c
                        FROM NE__OrderItem__c
                        WHERE
                        NE__OrderId__c IN:listOfConfId
                        AND NE__ProdId__r.RecordType.DeveloperName = 'Pricing'
                        AND NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName IN ('VAS', 'Acquiring')
                        AND ( NE__Action__c = 'Add' OR NE__Action__c = 'Change')
                ];
                System.debug( 'orderItemAcqVAS is  ' + orderItemAcqVAS );
                if ( orderItemAcqVAS != null && !orderItemAcqVAS.isEmpty( ) )
                {
                    for ( NE__OrderItem__c singleOI : orderItemAcqVAS )
                    {
                        mapACQ.put( singleOI.NE__OrderId__c, true );
                        System.debug( 'mapACQ.put(singleOI.NE__OrderId__c,true is: ' + mapACQ );
                    }
                }
            }

            // <daniele.gandini@ccenture.com> - 02/07/2019 - WN-9 - changed code moved below
            String error; //Simone Misani 04/10/2019 WN-558 
            if ( !mapToUpdate.keySet( ).isEmpty( ) )
            {
                for ( Id ordId : mapToUpdate.keySet( ) )
                {
                    if ( mapLRExisting.containsKey( ordId ) && mapLRExisting.get( ordId ) == false )
                    {
                        OB_LogRequest__c logRequest = new OB_LogRequest__c( );
                        logRequest.OB_Status__c = mapToUpdate.get( ordId ).OB_BankApprovalStatus__c == OB_UtilityConstants.ORDER_BANKAPPROVALSTATUS_APPROVATO ? OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT : OB_UtilityConstants.RIFIUTATO;
                        logRequest.OB_AccountId__c = mapToUpdate.get( ordId ).NE__AccountId__c;
                        logRequest.OB_ServicePointId__c = mapToUpdate.get( ordId ).OB_Service_Point__c;
                        logRequest.OB_OrderId__c = ordId;
                        logRequest.OB_ABI__c = mapToUpdate.get( ordId ).OB_ABI__c;
                        logRequest.OB_CAB__c = mapToUpdate.get( ordId ).OB_CAB__c;
                        logRequest.OB_MaintenanceType__c = OB_UtilityConstants.PRICING;
                        logRequest.RecordTypeId = rtPricing;
                        logRequest.OB_HasAcquiring__c = mapACQ.containsKey( ordId ) ? mapACQ.get( ordId ) : false;
                        logRequest.OB_HasPos__c = mapPOS.containsKey( ordId ) ? mapPOS.get( ordId ) : false;
                        logRequest.OB_RequestDate__c = Date.today( );
                        error=  logRequest.OB_Status__c; //Simone Misani 04/10/2019 WN-558 
                        // <daniele.gandini@ccenture.com> - 02/07/2019 - WN-9 - start
                        Boolean isPartnerCommunityLogged = OB_Utility.isPartnerCommunity(UserInfo.getUserId());
                        if(isPartnerCommunityLogged){
                            logRequest.OB_Requestor__c = OB_UtilityConstants.Banca;
                        }
                        // <daniele.gandini@ccenture.com> - 02/07/2019 - WN-9 - stop
                        
                        mapOfLR.put( ordId, logRequest );
                    }
                }
            }

           

            System.debug( 'mapOfLR is   ' + mapOfLR );
            if ( !mapOfLR.keySet( ).isEmpty( ) )
            {
                
                List<OB_LogRequest__c> listOfLogRequest = new List<OB_LogRequest__c>( );
                listOfLogRequest.addAll( mapOfLR.values( ) );
                System.debug( 'listOfLogRequest inside if is:  ' + listOfLogRequest );                
                insert listOfLogRequest;

                OB_OrderItemCheckerDate.orderItemCheckerDateServer(newOrds.values()); //enrico.purificato WN-190
                system.debug('@@@ linea 160');
                //Simone Misani 04/10/2019 WN-558 START
                if(error != OB_UtilityConstants.RIFIUTATO){
                    System.enqueueJob( new OB_QueueableClass( orderHeaderId ) );//Simone Misani 09/07/2019 WN-59-58
                }
                 //Simone Misani 04/10/2019 WN-558 END
                
            }
        }
    }
    //	END		micol.ferrari 15/02/2019

    //12-02-2019-S.P.-METHOD TO CHANGE LOG REQUEST AFTER APPROVE ON BIO APPROVAL PROCESS-START
    public void changeLogRequestStatusAfterBio( Map<Id, NE__Order__c> oldOrds, Map<Id, NE__Order__c> newOrds )
    {

        String confid;//Simone Misani WN-511 28/09/2019
        if ( oldOrds.size( ) > 0 && newOrds.size( ) > 0 )
        {
            Map<Id, NE__Order__c> mapToUse = new Map<Id, NE__Order__c>( );

            for ( NE__Order__c configuration : newOrds.values( ) )
            {
                if ( configuration.OB_CheckIfOrderIsApprovedRejectedBio__c && configuration.OB_ApprovalType__c == OB_UtilityConstants.APPROV_TYPE_BIO )
                {
                    mapToUse.put( configuration.Id, configuration );
                }
            }
			//francesca.ribezzi 30/04/19 adding new List of Approvato Bio configurations
			List<NE__Order__c> bioApprovedOrders = new List<NE__Order__c>();
            //elena.preteni 25/02/19	
            for ( NE__Order__c configuration : oldOrds.values( ) )
            {
                if ( configuration.OB_ApprovalType__c == OB_UtilityConstants.APPROV_TYPE_BIO && mapToUse.containsKey( configuration.Id )
                        //elena.preteni 26/02/19
                        && configuration.OB_ApprovalStatus__c != 'Approvato BIO' )
                //elena.preteni 26/02/19
                {
                    NE__Order__c ord = mapToUse.remove( configuration.Id );
                }
                //START francesca.ribezzi 30/04/19 adding approved orders to list
                else if(configuration.OB_ApprovalStatus__c =='Approvato BIO'){
                    bioApprovedOrders.add(configuration);
                }
            }
            system.debug( 'mapToUse ' + mapToUse );
            //elena.preteni 25/02/19
            if ( !mapToUse.keySet( ).isEmpty( ) )
            {
                List<Id> listOfId = new List<Id>( );
                listOfId.addAll( mapToUse.keySet( ) );
                system.debug( 'listOfId in mapToUse' + listOfId );
                //19-02-2019-S.P.-CHECK APPROVAL PROCESS ACQUIRING AFTER APPROVE ON BIO APPROVAL PROCESS-START
                Boolean checkAcquiring = false;

                NE__Order__c currentOrder = mapToUse.values( ).get( 0 );
                String orderHeaderId = currentOrder.NE__Order_Header__c;
                confid = currentOrder.id;
                NE__Order_Header__c currentOrderHeader = new NE__Order_Header__c( );
                List<NE__Order_Header__c> listOfHeaders =
                [
                        SELECT Id,OB_Main_Process__c,OB_StartApprovalProcess__c
                        FROM NE__Order_Header__c
                        WHERE Id = :orderHeaderId
                        LIMIT 1
                ];
                if ( !listOfHeaders.isEmpty( ) )
                {
                    currentOrderHeader = listOfHeaders.get( 0 );
                    
                }
                Id rtEsecutore = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( 'Esecutore' ).getRecordTypeId( );
                List<Contact> listOfEsecutore =
                [
                        SELECT Id,OB_Fiscal_Code__c,OB_Bank__r.OB_ABI__c
                        FROM Contact
                        WHERE AccountId = :currentOrder.NE__AccountId__c
                        AND RecordTypeId = :rtEsecutore
                        AND OB_Bank__r.OB_ABI__c = :currentOrder.OB_ABI__c
                        LIMIT 1
                ];
                String esecFiscalCode;
                if ( !listOfEsecutore.isEmpty( ) )
                {
                    Contact esecutore = listOfEsecutore.get( 0 );
                    if ( esecutore != null && orderHeaderId != null )
                    {
                        System.debug( '@Into if of check acquiring in order trigger' );
                        esecFiscalCode = esecutore.OB_Fiscal_Code__c;
                        checkAcquiring = currentOrder.OB_StartApprovalProcessAcquiring__c;
                        System.debug( '@checkAcquiring : ' + checkAcquiring );
                        if ( checkAcquiring )
                        {
                            OB_Utility.submitApprovalProcess( orderHeaderId, Label.OB_ApprovalProcessAcquiring );
                        }
                    }
                }
                //19-02-2019-S.P.-CHECK APPROVAL PROCESS ACQUIRING AFTER APPROVE ON BIO APPROVAL PROCESS-END
                List<OB_LogRequest__c> listOfLogRequest =
                [
                        SELECT Id,OB_Status__c, OB_SIAToBeApproved__c,OB_Mixed_Maintenance__c,OB_isNotIntegrated__c // 01/07/19 francesca.ribezzi adding OB_SIAToBeApproved__c - F2WAVE2-53 //Simone Misani 22/07/2019 fix Tracking//Simone Misani 19/09/2019 WN-320-adding OB_isNotIntegrated__c
                        FROM OB_LogRequest__c
                        WHERE OB_OrderId__c IN:listOfId
                        AND OB_Status__c = :OB_UtilityConstants.BOZZA
                ];
                System.debug( '@Log request before update : ' + JSON.serialize( listOfLogRequest ) );
                if ( !listOfLogRequest.isEmpty( ) )
                {
                    Map<Id, OB_LogRequest__c> logRequestsToUpdateByIds = new Map<Id, OB_LogRequest__c>( ); // NEXI-253 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 07/08/2019
                    for ( OB_LogRequest__c logReq : listOfLogRequest )
                    {
                        for ( NE__Order__c ord : mapToUse.values( ) )
                        {
                            Boolean confTech = OB_Maintenance_Consistenza_LogRequest_CC.compatibilityTechnicalConfigurator( confid );//Simone Misani WN-511 28/09/2019
                            system.debug( 'ord.OB_BankApprovalStatus__c  ' + ord.OB_BankApprovalStatus__c );
                            system.debug( 'ord.OB_ApprovalStatus__c  ' + ord.OB_ApprovalStatus__c );
                            if ( ( ord.OB_BankApprovalStatus__c == 'Approvato' ) &&
                                    checkAcquiring == false && !confTech )//Simone Misani WN-511 28/09/2019
                            {
                                logReq.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT;
                                System.debug( '@change status on log request : ' + JSON.serialize( logReq ) );
                            }
                            else if ( ord.OB_BankApprovalStatus__c == 'Rigettato' &&
                                    checkAcquiring == false )
                            {
                                logReq.OB_Status__c = OB_UtilityConstants.BOZZA;
                                System.debug( '@change status on log request : ' + JSON.serialize( logReq ) );
                            }
                           
                            //START francesca.ribezzi 01/07/19 - F2WAVE2-53   //Simone Misani 19/09/2019 - adding !checkAcquiring condition 
                            if((!checkAcquiring && logReq.OB_SIAToBeApproved__c && ord.OB_BankApprovalStatus__c == 'Approvato')||logReq.OB_Mixed_Maintenance__c==true || logReq.OB_isNotIntegrated__c== true || confTech ){//Simone Misani 19/09/2019 WN-320//Simone Misani 22/07/2019 fix Tracking//Simone Misani WN-511 28/09/2019
                                 logReq.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA;
                            }
                            //START francesca.ribezzi 01/07/19 - F2WAVE2-53
                            // NEXI-253 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 07/08/2019 START avoiding duplicates
                            logRequestsToUpdateByIds.put( logReq.Id, logReq );
                        }
                    }

                    if ( !logRequestsToUpdateByIds.values( ).isEmpty( ) )
                    {
                        update logRequestsToUpdateByIds.values( );
                        System.debug( LoggingLevel.INFO, 'OB_OrderTriggerHandler.changeLogRequestStatusAfterBio Log requests after update : ' + JSON.serialize( logRequestsToUpdateByIds.values( ) ) );
                        // NEXI-253 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 07/08/2019 STOP
                    }
                }
            }
            // 23/02/2018-S.P.-CHECK ACQUIRING AFTER BIO IN SETUP-START
            else
            {
                for ( NE__Order__c ord : newOrds.values( ) )
                {
                    if ( oldOrds.get( ord.Id ).OB_ApprovalBIO__c == false && ord.OB_ApprovalBIO__c == true && ord.OB_ApprovalStatus__c == OB_UtilityConstants.ORDER_APPROVALSTATUS_APPROVATOBIO )
                    {
                        System.debug( '@Into order trigger after final approval BIO in setup' );
                        NE__Order_Header__c orderHeader = new NE__Order_Header__c( );
                        Contact executor = new Contact( );

                        List<NE__Order_Header__c> listOfOrderHeaders =
                        [
                                SELECT  Id,NE__AccountId__c,OB_StartApprovalProcess__c, 
                                        OB_Sub_Process__c, // <daniele.gandini@ccenture.com> - 03/07/2019 - WN-28 - OB_Sub_Process__c added - start
                                        Name,OB_Main_Process__c
                                FROM NE__Order_Header__c
                                WHERE Id = :ord.NE__Order_Header__c
                        ];
                        if ( !listOfOrderHeaders.isEmpty( ) )
                        {
                            orderHeader = listOfOrderHeaders.get( 0 );
                            System.debug( 'OB_OrderTriggerHandler - changeLogRequestStatusAfterBio() - orderHeader : ' + orderHeader );

                            Id recordTypeIdEsec = Schema.SObjectType.Contact.getRecordTypeInfosByName( ).get( OB_UtilityConstants.ESECUTORE ).getRecordTypeId( );

                            List<Contact> listOfExecutors =
                            [
                                    SELECT Id,OB_Fiscal_Code__c
                                    FROM Contact
                                    WHERE AccountId = :orderHeader.NE__AccountId__c
                                    AND RecordTypeId = :recordTypeIdEsec
                            ];

                            if ( !listOfExecutors.isEmpty( ) )
                            {
                                executor = listOfExecutors.get( 0 );
                                System.debug( 'OB_OrderTriggerHandler - changeLogRequestStatusAfterBio() - executor : ' + executor );
                            }

                            List<NE__Order__c> configList =
                            [
                                    SELECT Id,OB_ApprovalStatus__c
                                    FROM NE__Order__c
                                    WHERE NE__Order_Header__c = :orderHeader.Id
                                    AND OB_ApprovalType__c = :OB_UtilityConstants.APPROV_TYPE_BIO
                            ];
                            if ( !configList.isEmpty( ) )
                            {
                                 
                                List<NE__Order__c> ordersToUpdate = new List<NE__Order__c>();
                                System.debug( 'OB_OrderTriggerHandler - changeLogRequestStatusAfterBio() - configList : ' + configList );
                                for ( NE__Order__c conf : configList )
                                {
                                    if ( conf.OB_ApprovalStatus__c == OB_UtilityConstants.ORDER_APPROVALSTATUS_APPROVATOBIO )
                                    {
                                        System.debug( '@Go on OB_Utility.retrieveSpecialCategoryConfigurations(' + orderHeader.Id + ' , ' + executor.OB_Fiscal_Code__c + ');' );
                                        Boolean isEnriched = OB_EnrichOrder.setConfigurationInformation( conf.id );
                                        if ( orderHeader != null )
                                        {
                                            Boolean checkAcquiring = orderHeader.OB_StartApprovalProcess__c;
                                            if ( checkAcquiring ) 
                                            {
                                                OB_Utility.submitApprovalProcess( orderHeader.Id, Label.OB_ApprovalProcessAcquiring );
                                            }
                                            else if ( orderHeader.OB_Main_Process__c != 'Maintenance' && checkAcquiring == false )
                                            {
                                                System.debug( 'OB_OrderTriggerHandler ---> OB_UtilityCallingServices.callSubmit(Id: ' + orderHeader.Id + 'name: ' + orderHeader.Name + ');' );
                                                system.debug('@@@ linea 364');
                                                System.enqueueJob( new OB_QueueableClass( orderHeader.Id ) );
                                            //michele.lubrano@accenture.com calling MIP START
                                            }
                                            else if ( orderHeader.OB_Main_Process__c == 'Maintenance' )
                                            {
                                                List<OB_LogRequest__c> logRequest =
                                                [
                                                        SELECT Id,
                                                                OB_Status__c,
                                                                OB_SIAToBeApproved__c,
                                                                OB_OrderId__c,
                                                                OB_MaintenanceType__c//Simone Misani 27/08/2019 WN-287
                                                        FROM OB_LogRequest__c
                                                        WHERE OB_OrderId__c = :conf.Id
                                                        AND OB_Status__c != :OB_UtilityConstants.CONFERMATO // NEXI-268 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 09/08/2019
                                                ];
                                                List<NE__OrderItem__c> listOfItems = [ SELECT Id,NE__ProdId__r.Name,NE__Action__c,NE__Parent_Order_Item__c FROM NE__OrderItem__c WHERE NE__OrderId__c = :logRequest[0].OB_OrderId__c ];
                                                logRequest[0].OB_SIAToBeApproved__c = OB_UtilityCallingServices.checkOperation( conf, listOfItems );

                                                if ( !logRequest[0].OB_SIAToBeApproved__c &&  logRequest[0].OB_MaintenanceType__c != OB_UtilityConstants.CONFIGURATORETECNICO )
                                                {
                                                    // <daniele.gandini@ccenture.com> - 03/07/2019 - WN-28 - start  //francesca.ribezzi 27/09/19 - changing it to AND condition! WN-511   
                                                    if(orderHeader.OB_Sub_Process__c != OB_UtilityConstants.HEADER_SUBPROCESS_TERMINAOFFERTA && logRequest[0].OB_MaintenanceType__c != OB_UtilityConstants.CONFIGURATORETECNICO){//Simone Misani 27/08/2019 WN-287
                                                        system.debug('@@@ linea 380');
                                                        System.enqueueJob( new OB_QueueableClass( orderHeader.Id ) );
                                                    }
                                                    // <daniele.gandini@ccenture.com> - 03/07/2019 - WN-28 - start
                                                    // FRANCESCA RIBEZZI START 27-Jun-19 - F2WAVE2- 39 SET TO 'BOZZA' THE LOG REQUEST STATUS
                                                    logRequest[0].OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT;
                                                    // FRANCESCA RIBEZZI END 27-Jun-19 - F2WAVE2- 39 SET TO 'BOZZA' THE LOG REQUEST STATUS
                                                    OB_OrderItemCheckerDate.orderItemCheckerDateServer(configList); //enrico.purificato WN-190
                            					}else{
                                                    logRequest[0].OB_Status__c = OB_UtilityConstants.INATTESA;
                                                }
                                                update logRequest;
                                                //michele.lubrano 21/05/19 adding conf to list:
                                                ordersToUpdate.add(conf);
                                            }
                                            //michele.lubrano@accenture.com END
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    public void fulfilmentStatusAfterUpdate( Map<Id, NE__Order__c> oldOrds, Map<Id, NE__Order__c> newOrds )
    {
        system.debug( 'fulfilmentStatusAfterUpdate inside method' );
        List<NE__Order_Header__c> headersToUpdate = new List<NE__Order_Header__c>( );
        for( NE__Order__c ord : newOrds.values( ) )
        {
            system.debug( 'ord -->' + ord );
            system.debug( 'oldOrds.get(ord.Id).OB_FulfilmentStatus__c -->' + oldOrds.get( ord.Id ).OB_FulfilmentStatus__c );
            system.debug( 'ord.OB_FulfilmentStatus__c -->' + ord.OB_FulfilmentStatus__c );
            if(String.isNotBlank( ord.NE__Order_Header__c ) && oldOrds.get( ord.Id ).OB_FulfilmentStatus__c != ord.OB_FulfilmentStatus__c && (ord.OB_FulfilmentStatus__c != 'Draft' && oldOrds.get( ord.Id ).OB_FulfilmentStatus__c != 'Draft' ) )
            {
                NE__Order_Header__c orderHeader = new NE__Order_Header__c( Id = ord.NE__Order_Header__c, OB_FulfilmentStatus__c = ord.OB_FulfilmentStatus__c );
                system.debug('orderHeader -->' + orderHeader);
                headersToUpdate.add(orderHeader);
                system.debug('headersToUpdate -->' + headersToUpdate);
            }
        }
        system.debug('headersToUpdate out of for -->' + headersToUpdate);
        update headersToUpdate;
    }

    /*******************************************************************************
    Purpose:  Method calls OB_Order_ChangeStatus.setOrderStatus after order update
    Parameters: Map<Id, NE__Order__c> newMap, Map<Id, NE__Order__c> oldMap
    Returns: -

    History
    --------
    VERSION        AUTHOR              DATE            DETAIL          Description
    1.0            Marta Stempien      13/05/2019      Created         NEXI-46
    ********************************************************************************/
    public static void setOrderNexiOrBankStatus ( Map<Id, NE__Order__c> newMap, Map<Id, NE__Order__c> oldMap )
    {
        OB_Order_ChangeStatus.setOrderStatus( newMap, oldMap );
    }
    /*
	* Author : Giovanni Spinelli
	* Date : 23/07/2019
	* Description : Method to convert some fields to uppercase.
	*   Input : list new objects and old object
	*   Output : -
	*   Note: 	this method is called from triggers class
	*/
	public static void uppercaseFieldsConversion(List<NE__Order__c> newOrder, List<NE__Order__c> oldOrder){
		try{
			System.debug('update order uppercase');
			
			System.debug('oldOrder: ' + oldOrder);
			for(NE__Order__c order : newOrder){
                if(String.isNotBlank( String.valueOf( order.OB_ReceiptHeader__c ) )  ){
                    String uppercaseRecHeader = order.OB_ReceiptHeader__c.toUpperCase();
                    //giovanni spinelli start 21/08/2019 replace à,ò,ù,è,é with a,o,u,e
                    uppercaseRecHeader = uppercaseRecHeader.replace('à' , 'a\'').replace('ò','o\'').replace('ù','u\'').replace('è','e\'').replace('é','e\'').replace('ì' , 'i\'');
                    //giovanni spinelli end  21/08/2019 replace à,ò,ù,è,é with a,o,u,e
                    order.OB_ReceiptHeader__c = uppercaseRecHeader;
                }
                if(String.isNotBlank( String.valueOf( order.OB_ShopSign__c ) ) ){
                    String uppercaseShopSign = order.OB_ShopSign__c.toUpperCase();
                    //giovanni spinelli start 21/08/2019 replace à,ò,ù,è,é with a,o,u,e
                    uppercaseShopSign = uppercaseShopSign.replace('à' , 'a\'').replace('ò','o\'').replace('ù','u\'').replace('è','e\'').replace('é','e\'').replace('ì' , 'i\'');
                    //giovanni spinelli end  21/08/2019 replace à,ò,ù,è,é with a,o,u,e
                    order.OB_ShopSign__c = uppercaseShopSign;
                }
            }
            System.debug('newOrder after: ' + newOrder);
			
		}catch(Exception ecc){
			System.debug(logginglevel.ERROR , 'Generic Error order trigger handler: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
		}
	}

}