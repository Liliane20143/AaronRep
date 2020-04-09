global without sharing class OB_AttachedDocumentationsController 
{
    //  START   micol.ferrari 18/11/2018
    @AuraEnabled
    public static String retrieveOrderHeaderId(String configurationId)
    {
        String orderHeaderId = null;
        List<NE__Order__c> listOfOrders =
        [
                SELECT Id,Name,NE__Order_Header__c
        FROM NE__Order__c 
        WHERE Id =: configurationId 
                LIMIT 1
        ];
        if (!listOfOrders.isEmpty())
        {
            orderHeaderId = listOfOrders.get(0).NE__Order_Header__c;
        }

        return orderHeaderId;
    }
    @AuraEnabled
    public static String retrieveUserLicense()
    {
        String licenseToReturn = null;
        List<User> listOfUsers =
        [
                SELECT Id, Profile.UserLicense.Name
        FROM User 
        WHERE Id =: UserInfo.getUserId() 
                LIMIT 1
        ];
        if (!listOfUsers.isEmpty())
        {
            licenseToReturn = listOfUsers.get(0).Profile.UserLicense.Name;
        }

        return licenseToReturn;
    }
    //  END     micol.ferrari 18/11/2018

    // Start AV 21/02/2019 dont show buttons CARICA and RIMUOVI if ADMIN  [Schema STEFANO MONTORI]
	@AuraEnabled
    public static String retrieveUserProfile()
    {
        String profileToReturn = null;
        List<User> listOfUsers =
        [
                SELECT Id, Profile.Name
        FROM User 
        WHERE Id =: UserInfo.getUserId() 
                LIMIT 1
        ];
        if (!listOfUsers.isEmpty())
        {
            profileToReturn = listOfUsers.get(0).Profile.Name;
        }

        return profileToReturn;
    }
	// End AV 21/02/2019 dont show buttons CARICA and RIMUOVI if ADMIN  [Schema STEFANO MONTORI]

    //public static final List<String> SERVER2SERVER = new List<String> {'SERVER2SERVER','SERVER2SERVER + FRONT_OFFICE'}; //start antonio.vatrano 13/07/2019 wn-53
    @AuraEnabled
    public static Map<String,Map<String,String>> getProductDocumentsServer(String orderHeaderId)
    {
        Map<String,Map<String,String>> documentsMap = new Map<String,Map<String,String>>();
        try
        {
            //List<String> allprodSFDC = new list<String>(); // antonio.vatrano 13/07/2019 wn-53
            //  add field to query antonio.vatrano wn-308 30/08/2019
            List<OB_Special_Category_Configuration__c> listToFilter =
            [
                    SELECT Name,OB_ATECO__c,OB_Commercial_Product__c,
            OB_DocRequired__c,OB_isCrowdfunding__c,OB_DescriptionNoVat__c,
                            OB_Legal_Form__c,OB_MCC__c,RecordType.DeveloperName,
                            OB_EngineCodeCommercialProduct__c,OB_RequestType__c,
                            OB_Attribute_Name__c, OB_Attribute_Value__c
            FROM OB_Special_Category_Configuration__c
                    WHERE OB_DocRequired__c = true
            ];

            List<OB_Product_Document__c> documents =
            [
                    SELECT Name, OB_Description__c, OB_Commercial_Product__r.Name,
            OB_Commercial_Product__c,OB_DocumentCode__c,OB_Start_Date__c, 
            OB_End_Date__c,OB_Client_Type__c,OB_Request_Typology__c,
            OB_Document_Typology__c,OB_Multiple_upload__c,OB_Business_Model__c  
                    FROM OB_Product_Document__c
            ];
                // remove part of query antonio.vatrano wn-308 30/08/2019
            List<NE__Order__c> orders =
            [
                    SELECT Id,OB_Service_Point__c, NE__Order_Header__r.NE__AccountId__c,
            NE__Order_Header__r.NE__AccountId__r.OB_ATECO__c,
            NE__Order_Header__r.OB_ABI__c,  
            NE__Order_Header__r.NE__AccountId__r.OB_IsCrowdfunding__c,
            NE__Order_Header__r.NE__AccountId__r.OB_DescriptionVATNotPresent__c,
            NE__Order_Header__r.NE__AccountId__r.OB_Legal_Form__c,OB_MCC__c,
            NE__Order_Header__r.OB_StartApprovalProcess__c, 
            NE__Order_Header__r.OB_In_Approvazione_a__c , 
            NE__Order_Header__r.OB_Rejection_Reason__c
            FROM NE__Order__c 
            WHERE NE__Order_Header__c=:orderHeaderId
            ];
            system.debug('orders: ' + orders);

            if (!orders.isEmpty())
            {
                NE__Order__c order = orders.get(0);  //antonio.vatrano wn-308 30/08/2019
                    String orderId = order.Id;
                    String servicePointId = order.OB_Service_Point__c;
                    String accountId = order.NE__Order_Header__r.NE__AccountId__c;
                    String vatNotPresent = order.NE__Order_Header__r.NE__AccountId__r.OB_DescriptionVATNotPresent__c;
                    String mcc = order.OB_MCC__c;
                    String ateco = order.NE__Order_Header__r.NE__AccountId__r.OB_ATECO__c;
                    String legalForm = order.NE__Order_Header__r.NE__AccountId__r.OB_Legal_Form__c;
                    Boolean startApprovalProcess = order.NE__Order_Header__r.OB_StartApprovalProcess__c;
                    String faseControlli = order.NE__Order_Header__r.OB_In_Approvazione_a__c;
                    String rejectionReason = order.NE__Order_Header__r.OB_Rejection_Reason__c;
                    Boolean isCrowdfunding = order.NE__Order_Header__r.NE__AccountId__r.OB_IsCrowdfunding__c;
                    String abi = order.NE__Order_Header__r.OB_ABI__c;
                    
                    String myKey = orderId + '||'
                            + servicePointId + '||'
                            + accountId + '||'
                            + startApprovalProcess + '||'
                            + faseControlli + '||'
                            + rejectionReason;
                    System.debug('***myKey: '+ myKey);
                // Start antonio.vatrano wn-308 30/08/2019
                List<NE__OrderItem__c> orderItems = [SELECT id, NE__Parent_Order_Item__c, NE__ProdId__c,NE__ProdId__r.OB_Codice_sfdc__c,
                                                    NE__ProdId__r.Name,  NE__Parent_Order_Item__r.NE__ProdId__r.Id,
                                                    NE__ProdId__r.NE__Engine_Code__c,NE__ProdId__r.RecordType.DeveloperName,
                                                    NE__ProdName__c,NE__OrderId__r.NE__Order_Header__c,NE__Action__c,
                                                    NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName,
                                                    NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c,
                                                    NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_Acquiring__c,
                                                    NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_POS__c,
                                                    (SELECT Id, Name, NE__Value__c FROM NE__Order_Item_Attributes__r)
                                            from   NE__OrderItem__c
                                            where NE__OrderId__c =  :orderId];
                    system.debug('orderItems: ' + orderItems);
                // End antonio.vatrano wn-308 30/08/2019
                    if (!orderItems.isEmpty())
                    {
                        String mainProcess = '';
                        Set<String> businessModel = new Set<String>();
                        for(NE__OrderItem__c orderItem: orderItems)
                        {
                            if(mainProcess=='')
                            {
                                mainProcess = orderItem.NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c;
                            }
                            businessModel.add(orderItem.NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_Acquiring__c);
                            businessModel.add(orderItem.NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_POS__c);
                        //allprodSFDC.add(orderItem.NE__ProdId__r.OB_Codice_sfdc__c); // antonio.vatrano 13/07/2019 wn-53
                        }
                        system.debug('mainProcess: '+mainProcess);
                        system.debug('businessModel: '+businessModel);
                        //  micol.ferrari 13/12/2018 - ADD null
                        // e.p 06/03/19 gambling per maintenance
                        Set<String> clientTypeSet = OB_UtilityCallingServices.getClientTypeSet( listToFilter,
                                orderItems, mcc, ateco, legalForm, accountId,
                                null, abi, mainProcess );
                        system.debug('clientTypeSet: '+clientTypeSet);
                        List<String> clientTypes = new List<String>(); 
                        clientTypes.addAll(clientTypeSet);

                        List<OB_Product_Document__c> filteredDocuments = new List<OB_Product_Document__c>();
                        if (!documents.isEmpty())
                        {
                            for (OB_Product_Document__c mydoc : documents)
                            {   
                                system.debug('mydoc: '+mydoc);
                                system.debug('mydoc.OB_Client_Type__c: '+mydoc.OB_Client_Type__c);

                                if (clientTypes.contains(mydoc.OB_Client_Type__c) && mydoc.OB_Request_Typology__c==mainProcess)
                                {
                                    for(String bm : businessModel)
                                    {
                                        if(mydoc.OB_Business_Model__c.contains(bm))
                                        {
                                            filteredDocuments.add(mydoc);
                                        }
                                    }
                                }                           
                            }
                        }
                        system.debug('filteredDocuments: ' + filteredDocuments);
                    // //start antonio.vatrano 13/07/2019 wn-53
                    // Start antonio.vatrano wn-308 30/08/2019
                    // if(clientTypes.contains('eCommerce') || clientTypes.contains('MOTO')){ // antonio.vatrano fewave2-146 18/07/2019
                    //     Boolean isServer2Server = false;
                    //     for(String str : allprodSFDC){
                    //         if (SERVER2SERVER.contains(str)){
                    //             isServer2Server = true;
                    //         }
                    //     }
                    //     for (Integer i = 0; i<filteredDocuments.size() ; i++){
                    //         if(filteredDocuments[i].OB_Document_Typology__c == 'ATTESTATION OF COMPLIANCE'){
                    //             if(!isServer2Server){
                    //                 filteredDocuments.remove(i);
                    //             }
                    //         }
                    //     }
                    // }
                    // End antonio.vatrano wn-308 30/08/2019
                        //end antonio.vatrano 13/07/2019 wn-53
                        //start  antonio.vatrano 13/07/2019 wn-97-104-105
                        if(clientTypes.contains('Upload document Stazioni Di Servizio')){
                            for (Integer i = 0; i<filteredDocuments.size() ; i++){
                                if(filteredDocuments[i].OB_Client_Type__c == 'Upload document Stazioni Di Servizio'){
                                    filteredDocuments.remove(i);
                                }
                            }
                        }
                        //end antonio.vatrano 13/07/2019 wn-97-104-105

                        Set<String> documentsNameUtility = new Set<String>();
                        List<String> documentsName = new List<String>();  

                        Map<String,String> innerDocumentsMap = new Map<String,String>();
                        for(OB_Product_Document__c docElement : filteredDocuments)
                        {
                            innerDocumentsMap.put(docElement.OB_Description__c,docElement.OB_Document_Typology__c+':'+docElement.OB_Multiple_upload__c);
                            
                        }
                        documentsName.addAll(documentsNameUtility);

                        documentsMap.put(myKey,innerDocumentsMap);
                        system.debug(order.NE__Order_Header__r.id+'     '+innerDocumentsMap);
                    }
                }
            system.debug('documentsMap '+documentsMap);
        } catch ( Exception ecc )
        {
            System.debug('Generic Error: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
        } 
        return documentsMap;
    }

    @AuraEnabled
    public static String serverGetDocumentListId (String orderHeaderId)
    {   
        //  START   micol.ferrari 17/01/2019 - GET CURRENT ORG NAME
        String environment = !Test.isRunningTest() ? OB_UtilityCallingServices.returnCurrentOrg() : 'DEV1';
        //  END     micol.ferrari 17/01/2019 - GET CURRENT ORG NAME
        
        OB_Integration_Configuration__c intConfig = OB_Integration_Configuration__c.getValues(environment);

        system.debug('### environment: '+environment);

        List<NE__Order__c> orders =
        [
                SELECT Id,
                        OB_Service_Point__c,
                        NE__Order_Header__r.NE__AccountId__c
                FROM NE__Order__c
                where NE__Order_Header__c = :orderHeaderId
        ];
        String mapDocId=null;
        if (!orders.isEmpty())
        {
            NE__Order__c order = new NE__Order__c();
            order = orders.get(0);
                

                String merchantId = order.NE__Order_Header__r.NE__AccountId__c;
                String salesPointId = order.OB_Service_Point__c;
                String orderId = order.Id;
            String traceIdHeader = String.valueof( DateTime.now( ) ).replaceAll( ' ', 'T' )
                    + 'M'
                    + merchantId
                    + 'S'
                    + salesPointId
                    + 'C'
                    + orderId;
                HttpRequest req = new HttpRequest();
            String url = 'callout:OB_callService/api/merchants/'
                    + merchantId
                    + '/sales-points/'
                    + salesPointId
                    + '/orders/'
                    + orderId
                    + '/documents?documentStatus=ACTIVE';//giovanni spinelli 27/06/2019 get only active documente to improve efficiency
                req.setEndpoint(url);
                req.setMethod('GET');
                String token = OB_UtilityCallingServices.checkToken();
                system.debug('Service message: '+token);

                req.setHeader( OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX+token);
                req.setHeader('Content-Type','application/json');
                req.setHeader(OB_UtilityConstants.TRACE_ID_HEADER,traceIdHeader);
                // start spinelli.giovanni 05/05/2019  increase timeout from 30 sec to 60 sec
                req.setTimeout(60000);
                // start spinelli.giovanni 05/05/2019  increase timeout from 30 sec to 60 sec
            if ( intConfig.OB_CAsigned_name__c != null )
            {
                    req.setClientCertificateName(intConfig.OB_CAsigned_name__c); 
                }
                // req.setBody(body);
                System.debug('Request to service contract: ' + req);

                Http http = new Http();
                HTTPResponse res = http.send(req);
                System.debug('Response body: '+res.getBody());
                //giovanni spinelli - 10707/2019 - catch error from filenet - start
                try{
                    System.debug('STATUS CODE: ' + res.getStatusCode());
                    if(res.getStatusCode()!= 200){
                        mapDocId ='ERROR';
                    }else{
                        mapDocId            = res.getBody();
                    }
                }catch(CalloutException e){
                    System.debug('CalloutException: ' + e.getMessage());
                    mapDocId ='ERROR';
                }
                //giovanni spinelli - 10707/2019 - catch error from filenet - end
                System.debug('mapDocId: '+mapDocId);
        }
        
        return mapDocId;
    }

    @AuraEnabled
    public static void submitApprovalProcess( String orderHeaderId )
    {
        try
        {
            // NEXI-353 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 01/10/2019 START moved before avr sos callout
            System.debug( LoggingLevel.INFO, 'SubmitApprovalProcess - resubmitting : ' + orderHeaderId );

            Boolean checkAcquiring = OB_Utility.retrieveSpecialCategoryConfigurations( orderHeaderId );
            if ( checkAcquiring )
            {
                OB_Utility.submitApprovalProcess( orderHeaderId, Label.OB_ApprovalProcessAcquiring );
            }
            // NEXI-353 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 01/10/2019 STOP

            //Start Antonio.vatrano r1f3-117 27/09/2019
            List<NE__Order_Header__c> listHeader = [ SELECT Id, OB_In_Approvazione_a__c, NE__AccountId__c FROM NE__Order_Header__c where id = :orderHeaderId LIMIT 1 ];
            if ( !listHeader.isEmpty( ) )
            {
                NE__Order_Header__c oHeader = listHeader.get( 0 );
                if ( OB_UtilityConstants.FASECONTROL_CONTROLS_AML.equalsIgnoreCase( oHeader.OB_In_Approvazione_a__c ) )
                {
                    OB_Util009_AVRSOS.calloutAVRSOS( oHeader.NE__AccountId__c, oHeader.Id, OB_UtilityConstants.SETUP );
                }
            }
            //End Antonio.vatrano r1f3-117 27/09/2019
        } catch ( Exception ecc )
        {
            System.debug( LoggingLevel.ERROR, '[EXCE] OB_Utility.submitApprovalProcess ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
        }
    }


    global static String docId {get;set;}
    global static  Map <String,String> docIds = new Map <String,String>();

    @AuraEnabled
    public static String getMapDocId( )
    {
        system.debug('getMapDocId docIds: '+docId);
        return docId;        
    }

    // Start AV 21/02/2019 retrieve field of configuration OB_ShowAttachedDocumentations__c to show or not to show Documents in CONTAINER
    // Start antonio.vatrano r1f3-54 13/09/2019
	@AuraEnabled
    public static map<string, string> showCmpDocs( string orderId )
    {
		map<string, string> toReturn = new map<string, string>();
        List<NE__Order__c> orders =
        [
                SELECT id,
                        OB_ShowAttachedDocs__c,
                        NE__Order_Header__r.OB_Rejection_Reason__c
                FROM NE__Order__c
                WHERE id = :orderId
                LIMIT 1
        ];
        if ( !orders.isEmpty( ) )
        {
			toReturn.put('ShowDoc',orders.get(0).OB_ShowAttachedDocs__c);
			toReturn.put('Rejection_Reason',orders.get(0).NE__Order_Header__r.OB_Rejection_Reason__c);
        }
        // END antonio.vatrano r1f3-54 13/09/2019
        else
        {
            system.debug( '@@No ORDER' );
        }
		system.debug('@@toReturn: '+ toReturn);
		return toReturn;
	}  

    @AuraEnabled
    global static map<string, string> retrieveContracts( )
    {
        map<string, string> toReturn = new map<string, string>();
        list<OB_Contract__c> contracts =
        [
                SELECT OB_Contract_Code__c,OB_Template_Name__c
                FROM OB_Contract__c
        ];
        if(!contracts.isEmpty())
        {
            for(OB_Contract__c con : contracts)
            {
                toReturn.put(con.OB_Contract_Code__c, con.OB_Template_Name__c);
            }
        }
        system.debug(toReturn);
        return toReturn;
    }
    //Start antonio.vatrano 24/09/2019 R1F3-97 
    @AuraEnabled
	public static Map<String , String> getTokenJWE(String documentName){
		return OB_UtilityCallingServices.getTokenJWEMethod(documentName);
	}
    //End antonio.vatrano 24/09/2019 R1F3-97
    //Start antonio.vatrano 28/09/2019 R1F3-97
    @AuraEnabled
	public static Map<String , String> retrieveInfoRiskEvaluation(String orderId){
        Map<String , String> toReturn = new Map<String , String>();
		List<NE__Order__c> oList = [SELECT id, NE__AccountId__c, OB_Service_Point__c FROM NE__Order__c WHERE Id =:orderId];
        if (!oList.isEmpty()){
            NE__Order__c o = oList.get(0);
            toReturn.put('MERCHANT', String.valueof(o.NE__AccountId__c));
            toReturn.put('PV', String.valueof(o.OB_Service_Point__c));
        }
        return toReturn;
	}
    //End antonio.vatrano 28/09/2019 R1F3-97


}