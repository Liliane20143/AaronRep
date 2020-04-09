public without sharing class StampaDocumentiController
{
    private static final String APPROVATORE_RISK_EVALUATION = 'Approvatore Risk Evaluation'; // NEXI-286 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 06/09/2019
    // public static final List<String> SERVER2SERVER = new List<String> {'SERVER2SERVER','SERVER2SERVER + FRONT_OFFICE'}; //start antonio.vatrano 13/07/2019 wn-53

    //NEXI-211 and 218 Wojciech Kucharek wojciech.kucharek@accenture.com 26.07.2019 START
    @AuraEnabled
    public static Map<String, String> getProductDocumentsServer( String orderId, String orderHeaderId, String mcc, String ateco, String legalForm, String merchantId, string abi, Boolean isCompanyDataModified )
    {
        return getProductDocumentsServer( orderId, orderHeaderId, mcc, ateco, legalForm, merchantId, abi, isCompanyDataModified, false );
    }
    //NEXI-211 and 218 Wojciech Kucharek wojciech.kucharek@accenture.com 26.07.2019 START

    @AuraEnabled // elena.preteni 19/07/2019 no BIO triggered F3 abi cab selection added isSetupFromOp
    public static Map<String,String> getProductDocumentsServer( String orderId,String orderHeaderId, String mcc, String ateco, String legalForm, String merchantId, string abi, Boolean isCompanyDataModified, Boolean isSetupFromOp ){
        //NEXI-32 Customer DS-4 & FG-4 grzegorz.banach@accenture.com 20/05/2019 added "isCompanyDataModified" Boolean parameter
        Map<String,String> documentsMap = new Map<String,String>();
        system.debug('orderId --> '+orderId);
        system.debug('orderHeaderId --> '+orderHeaderId);
        system.debug('mcc --> '+mcc);
        system.debug('ateco --> '+ateco);
        system.debug('legalForm --> '+legalForm);
        system.debug('merchantId --> '+merchantId);
        system.debug('abi --> '+abi);
        // Start AV DEFECT 1614 right mcc for docs
        List<NE__Order__c> orders =
        [
                SELECT id,
                        OB_MCC__c,
                        OB_ABI__c,
                        NE__Order_Header__r.OB_In_Approvazione_a__c // NEXI-261 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 23/08/2019
                FROM NE__Order__c
                WHERE Id = :orderId
                LIMIT 1
        ]; //  R1F2 Micol Ferrari <micol.ferrari@accenture.com>, 09/05/2019
        List<String> allprodSFDC = new list<String>(); // antonio.vatrano 13/07/2019 wn-53

        //  R1F2 Micol Ferrari <micol.ferrari@accenture.com>, 09/05/2019 - START
        String setupABI = null;
        //  R1F2 Micol Ferrari <micol.ferrari@accenture.com>, 09/05/2019 - STOP

        if(!orders.isEmpty()){
            mcc =  orders.get(0).OB_MCC__c;
            
            //  R1F2 Micol Ferrari <micol.ferrari@accenture.com>, 09/05/2019 - START
            setupABI = String.isBlank(abi) ? orders.get(0).OB_ABI__c : abi;
            //  R1F2 Micol Ferrari <micol.ferrari@accenture.com>, 09/05/2019 - STOP
        } 
        system.debug('MCC RIGHT --> '+mcc);

        List<NE__OrderItem__c> orderItems = [select id, NE__Parent_Order_Item__c, NE__ProdId__c,NE__ProdId__r.OB_Codice_sfdc__c,
                                                    NE__ProdId__r.Name,  NE__Parent_Order_Item__r.NE__ProdId__r.Id,
                                                    NE__ProdId__r.NE__Engine_Code__c,NE__ProdId__r.RecordType.DeveloperName, 
                                                    NE__ProdName__c,NE__OrderId__r.NE__Order_Header__c,NE__Action__c,
                                                    NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName,
                                                    NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c,
                                                    NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_Acquiring__c,
                                                    NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_POS__c,
                                                    //START [27-03-2019 No Card Present] Andrea Saracini
                                                    (SELECT Id, Name, NE__Value__c FROM NE__Order_Item_Attributes__r)
                                                    //STOP [27-03-2019 No Card Present] Andrea Saracini 
                                            from   NE__OrderItem__c    
                                            where NE__OrderId__c =  :orderId];

        system.debug('orderItems: ' + orderItems);      
        List<String> products = new List<String>();
        String mainProcess = '';
        Set<String> businessModel = new Set<String>();
        for(NE__OrderItem__c orderItem: orderItems){
            if(mainProcess==''){
                mainProcess = orderItem.NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c;
            }
            businessModel.add(orderItem.NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_Acquiring__c);
            businessModel.add(orderItem.NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_POS__c);
            allprodSFDC.add(orderItem.NE__ProdId__r.OB_Codice_sfdc__c); // antonio.vatrano 13/07/2019 wn-53
        }
        system.debug('mainProcess: '+mainProcess);
        //START [06-05-2019 No Card Present] Andrea Saracini
        List<OB_Special_Category_Configuration__c> listToFilter = [SELECT Name,
                                                                        OB_ATECO__c,
                                                                        OB_Commercial_Product__c,
                                                                        OB_DocRequired__c,
                                                                        OB_DescriptionNoVat__c,
                                                                        OB_isCrowdfunding__c,
                                                                        OB_Legal_Form__c,
                                                                        OB_MCC__c,
                                                                        RecordType.DeveloperName,
                                                                        OB_EngineCodeCommercialProduct__c,
                                                                        OB_RequestType__c,
                                                                        OB_Attribute_Name__c,
                                                                        OB_Attribute_Value__c    
                                                                    FROM OB_Special_Category_Configuration__c 
                                                                    WHERE OB_DocRequired__c = true
                                                                ];
        //STOP [06-05-2019 No Card Present] Andrea Saracini
        system.debug('listToFilter: '+listToFilter);
        //Elena Preteni 10/01/2019 Added parameter abi in getClientTypeSet method signature
        // e.p 06/03/19 gambling per maintenance
        Set<String> clientTypeSet = OB_UtilityCallingServices.getClientTypeSet(listToFilter,orderItems,mcc,ateco,legalForm,merchantId,null,setupABI,mainProcess, isCompanyDataModified); //  R1F2 Micol Ferrari <micol.ferrari@accenture.com>, 09/05/2019
        //NEXI-32 Customer DS-4 & FG-4 grzegorz.banach@accenture.com 13/05/2019
        //Elena Preteni 10/01/2019 Added parameter abi in getClientTypeSet method signature
        //Set<String> clientTypeSet = StampaDocumentiController.getClientTypeSet(listToFilter,orderItems,products,mcc,ateco,legalForm,merchantId);

        List<String> clientTypes = new List<String>(); 
        clientTypes.addAll(clientTypeSet);
        system.debug('clientTypes: '+clientTypes);
        List<OB_Product_Document__c> documents = new List<OB_Product_Document__c>();
        List<OB_Product_Document__c> allDocuments = [SELECT Name, OB_Description__c, OB_Commercial_Product__r.Name, OB_Commercial_Product__c,OB_DocumentCode__c,OB_Start_Date__c, OB_End_Date__c,OB_Client_Type__c,OB_Request_Typology__c,OB_Document_Typology__c,OB_Multiple_upload__c,OB_Business_Model__c FROM OB_Product_Document__c WHERE OB_Client_Type__c in :clientTypes  AND OB_Request_Typology__c = :mainProcess ];
        for(OB_Product_Document__c doc :allDocuments){
            for(String b :businessModel){
                system.debug('businessModel: ' +b);
                if(doc.OB_Business_Model__c.contains(b)){
                    documents.add(doc);
                }
            }
        }
        System.debug('documents  ' + documents);

        // NEXI-261 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 23/08/2019 START create special category map
        Map<String, String> specialCategoryDocuments = new Map<String, String>( );
        // NEXI-211 Wojciech Kucharek wojciech.kucharek@accenture.com 18.07.2019 START
        if ( !String.isBlank( orderHeaderId ) )
        {
            specialCategoryDocuments = OB_Util000_DocumentUpload.documentsWhenSpecialCategory( orderHeaderId );
            System.debug( LoggingLevel.FINE, 'StampaDocumentiController.getProductDocumentsServer : Documents returned - IF - special categories ' + documentsMap );
            // NEXI-261 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 23/08/2019 STOP
        }
        //NEXI-211 Wojciech Kucharek wojciech.kucharek@accenture.com 22.07.2019 STOP

        // NEXI-261 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 23/08/2019 START check if user has access
        //NEXI-218 Wojciech Kucharek wojciech.kucharek@accenture.com 18.07.2019 START
        if ( !String.isBlank( orderId ) && userIsApprovatoreRiskEvaluation( ) && // NEXI-286 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 06/09/2019 new check for profile
                ( isSetupFromOp == null || isSetupFromOp == false ) &&
                OB_UtilityConstants.FASECONTROL_SECURITY_CHECKS.equalsIgnoreCase( orders.get( 0 ).NE__Order_Header__r.OB_In_Approvazione_a__c ) )
        {
            documentsMap = setDocumentsToUpload( OB_Util000_DocumentUpload.DOCUMENT_VR, OB_Util000_DocumentUpload.DOCUMENT_VR_DESCRIPTION );
            System.debug( LoggingLevel.FINE, 'StampaDocumentiController.getProductDocumentsServer : Documents returned - user is in queue ' + documentsMap );
            return documentsMap;
        }
        // NEXI-261 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 23/08/2019 STOP
        // NEXI-218 Wojciech Kucharek wojciech.kucharek@accenture.com 22.07.2019 STOP

        //start antonio.vatrano 13/07/2019 wn-53
        // Start antonio.vatrano wn-308 30/08/2019
        // if(clientTypes.contains('eCommerce') || clientTypes.contains('MOTO')){ // antonio.vatrano fewave2-146 18/07/2019
        //     Boolean isServer2Server = false;
        //     for(String str : allprodSFDC){
        //         if (SERVER2SERVER.contains(str)){
        //             isServer2Server = true;
        //         }
        //     }
        //     for (Integer i = 0; i<documents.size() ; i++){
        //         if(documents[i].OB_Document_Typology__c == 'ATTESTATION OF COMPLIANCE'){
        //             if(!isServer2Server){
        //                 documents.remove(i);
        //             }
        //         }
        //     }
        // }
        // End antonio.vatrano wn-308 30/08/2019
        //end antonio.vatrano 13/07/2019 wn-53
        //start antonio.vatrano 13/07/2019 wn-97-104-105
        if(clientTypes.contains('Upload document Stazioni Di Servizio')){
            for (Integer i = 0; i<documents.size() ; i++){
                if(documents[i].OB_Client_Type__c == 'Upload document Stazioni Di Servizio'){
                    documents.remove(i);
                }
            }
        }
        //end antonio.vatrano 13/07/2019 wn-97-104-105

        Set<String> documentsNameUtility = new Set<String>();
        List<String> documentsName = new List<String>();  
        for(OB_Product_Document__c docElement : documents){
            documentsMap.put(docElement.OB_Description__c,docElement.OB_Document_Typology__c+':'+docElement.OB_Multiple_upload__c);
            system.debug('documentsMap'+documentsMap);
        }

        documentsName.addAll(documentsNameUtility);
        documentsMap.putAll( specialCategoryDocuments ); // NEXI-261 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 23/08/2019
        //Start antonio.vatrano wn-427 19/09/2019
        System.debug('@@documentsMap: '+documentsMap);
        List<String> documentMapToList = new List<String>();
        documentMapToList.addAll(documentsMap.keySet());
        List<OB_Bank_Profile__c> listBankProfile = [SELECT Id, OB_NeedBIO__c FROM OB_Bank_Profile__c WHERE OB_Bank__r.OB_ABI__c =: setupABI limit 1]; //  R1F2 Micol Ferrari <micol.ferrari@accenture.com>, 09/05/2019
        //antonio.vatrano r1f3-131 02/10/2019
        if (!listBankProfile.isEmpty())
        {
            Boolean needBio = listBankProfile.get(0).OB_NeedBIO__c;
            system.debug('@@OB_NeedBIO__c: '+needBio);
            if(needBio && !documentMapToList.isEmpty()){
                NE__Order__c o = [SELECT id, OB_AdditionalDocumentationRequired__c, OB_CheckApprovalProcessAcquiring__c  
                                    FROM NE__Order__c 
                                    WHERE Id = :orderId limit 1];
                system.debug('Order in BIO : '+o);
                if(documentMapToList.size()==1 && documentMapToList[0].equalsIgnoreCase('CONTRATTO FIRMATO')){
                    o.OB_CheckApprovalProcessAcquiring__c = true;
                }
                o.OB_AdditionalDocumentationRequired__c = true;
                upsert o;   
            }
        }
        //End antonio.vatrano wn-427 19/09/2019
        return documentsMap;
    }
    
    @AuraEnabled
    public static List<NE__Product__c> getCommercialProductsServer(){
        List<NE__Product__c> products = [Select name from NE__Product__c where id in (select OB_Commercial_Product__c from OB_Product_document__c )];
        return products;
    }

    @AuraEnabled
    public static void updateDocReqTrue (String orderHeaderId, Boolean isToTriggered){
        NE__Order_Header__c oh = [SELECT Id,OB_AdditionalDocumentationRequired__c FROM NE__Order_Header__c WHERE Id =:orderHeaderId];

        System.debug('OB_AdditionalDocumentationRequired__c first: ' +oh.OB_AdditionalDocumentationRequired__c);
        System.debug('OH: ' +oh);
        System.debug('isToTriggered; '+isToTriggered);
        if(isToTriggered){
            oh.OB_AdditionalDocumentationRequired__c = true;
            System.debug('OB_AdditionalDocumentationRequired__c is true: ' +oh.OB_AdditionalDocumentationRequired__c);
        }
        else{
            oh.OB_AdditionalDocumentationRequired__c = false;
        }
        upsert oh;
    }
        /*
        * Author : Giovanni Spinelli
        * Date : 10/05/2019
        * Description : return all saved doc with status == active.
        */
        @AuraEnabled
        public static String retrieveSavedDocs (String merchantId , String servicePointId, String orderId ){
            System.debug('into retrieve save docs');
            String response = null;
            String url = 'callout:OB_callService/api/merchants/'+ merchantId+ '/sales-points/'+ servicePointId+ '/orders/'+ orderId+ '/documents?documentStatus=ACTIVE';
            HttpRequest req     = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('GET');
            req.setTimeOut(60000);
            String token        = OB_UtilityCallingServices.checkToken();
            req.setHeader( OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX+token);
            req.setHeader('Content-Type','application/json');
            Http http           = new Http();
            HTTPResponse res    = http.send(req);
            system.debug('###MY RES BODY:  '+res.getBody());
            system.debug('###MY RES :  '+res);
            return res.getBody();
        }
        /*
        * Author : Giovanni Spinelli
        * Date : 10/05/2019
        * Description : deprecate all 'contratti firmati'.
        */
        @AuraEnabled
        public static String deprecateDocs (String merchantId,String servicePointId,String orderId,List<String> contractsIdList){
            System.debug('into deprecateDocs');
            String response = null;
            try{
                //for each id make an http call and deprecate single contract
                HTTPResponse res = new  HTTPResponse();
                for(String ids : contractsIdList)
                {
                    String url = 'callout:OB_callService/api/merchants/'+merchantId+'/sales-points/'+servicePointId+'/orders/'+orderId+'/documents/'+ids;
                    String body = '{"documentStatus":"DEPRECATED"}';
                    String traceIdHeader =  String.valueof(DateTime.now()).replaceAll(' ','T');
                    String environment = !Test.isRunningTest() ? OB_UtilityCallingServices.returnCurrentOrg() : 'DEV1';
                    OB_Integration_Configuration__c intConfig = OB_Integration_Configuration__c.getValues(environment);
                    HttpRequest  req = new HttpRequest();
                    String token = OB_UtilityCallingServices.checkToken();
                    req.setEndpoint(url);
                    req.setMethod('POST');
                    system.debug('Service message: '+token);
                    req.setHeader( OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX+token);
                    req.setHeader(OB_UtilityConstants.TRACE_ID_HEADER,traceIdHeader);
                    req.setTimeOut(60000);
                    if(intConfig.OB_CAsigned_name__c != null)
                    {
                        req.setClientCertificateName(intConfig.OB_CAsigned_name__c);
                    }
                    req.setHeader('Content-Type','application/json');
                    req.setBody(body);
                    System.debug('RESPONSE: '+req);
                    Http http = new Http();
                    res = http.send(req);
                    System.debug('Response body deprecateDocument: '+ res.getBody() + ' ,Status code: ' +res.getStatusCode());
                }
                return String.valueof(res.getStatusCode());
            }catch(CalloutException e){
                System.debug('CALLOUT EXCEPTION: '+e.getMessage());
                response='ERROR';
                return response;
            }

        }
        /*
        * Author : Giovanni Spinelli
        * Date : 16/05/2019
        * Description : get token and callout.
        */
        @AuraEnabled
        public static Map<String , String> getTokenJWE(string documentName){
            //get current user
            Map<String , String> returnMap = New Map<String , String>();
            String userId = UserInfo.getUserId();
            System.debug('userId is: ' + userId);
            //I need user Id
            User currentUser = [SELECT id, name
                                FROM user
                                WHERE  id =: userId
                                LIMIT 1];

            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:OB_GetTokenJWE');
            req.setMethod('POST');
            req.setBody('{"documentFileName":"'+documentName+'","username":"'+currentUser.name+'"}');
            String token = OB_UtilityCallingServices.checkToken();
            System.debug('OAUTH: '+OB_UtilityConstants.AUTH );
            System.debug('PREFIX: '+OB_UtilityConstants.PREFIX );
            System.debug('Token: '+token );
            req.setHeader( OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX+token);
            req.setHeader('Content-Type','application/json');
            System.debug('Request to service contract: ' + req);
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug('RESPONSE BODY: '+res.getBody());
            String jewToken = res.getBody();
            String convertedToken =    jewToken.split(':')[1].replace('"','').replace('}' , '') ;
            System.debug('BODY RESPONSE: ' +   convertedToken );
            //get FEurl
            String FEurl = StampaDocumentiController.getFEurl();
            System.debug('feURL: ' +FEurl );
            returnMap.put('jewToken' , convertedToken);
            returnMap.put('FEurl' , FEurl);
            return returnMap;
        }
        /*
        * Author : Giovanni Spinelli
        * Date : 16/05/2019
        * Description : get feurl from custom setting.
        */
        private static String getFEurl (){
        String environment  =   null;
        String FEurl        =   null;
        OB_Integration_Configuration__c intConfig = new OB_Integration_Configuration__c();
        try{
            environment = !Test.isRunningTest() ? OB_UtilityCallingServices.returnCurrentOrg() : 'DEV1';
            intConfig = OB_Integration_Configuration__c.getValues(environment);
            FEurl = intConfig.OB_FEUrl__c;
        }
        catch(Exception ecc){
            System.debug('Generic Error: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
        }

        return FEurl ;
      }
    /*
	* Author : Giovanni Spinelli
	* Date : 06/05/2019
	* Description : Method fire a future method to deprecate all contrat generated.
	*/
    @AuraEnabled
	public static void deprecateContracts(String merchantId,String servicePointId,String orderId,List<String> contractsIdList){
		System.debug('DEPRECATING ALL CONTRACTS');
		System.debug('merchantId: ' + merchantId);
		System.debug('servicePointId: ' + servicePointId);
		System.debug('orderId: ' + orderId);
		System.debug('contractsIdList: ' + contractsIdList);
		StampaDocumentiController.asyncCall( merchantId, servicePointId, orderId, contractsIdList);
	}
	/*
	* Author : Giovanni Spinelli
	* Date : 06/05/2019
	* Description : future method to deprecate all contrat generated.
	*/	
	@future(callout=true)
	private static void asyncCall (String merchantId,String servicePointId,String orderId,List<String> contractsIdList){

		//for each id make an http call and deprecate single contract
		for(String ids : contractsIdList){
			String url = 'callout:OB_callService/api/merchants/'+merchantId+'/sales-points/'+servicePointId+'/orders/'+orderId+'/documents/'+ids;
			String body = '{"documentStatus":"DEPRECATED"}';
			String traceIdHeader =  String.valueof(DateTime.now()).replaceAll(' ','T');
			String environment = !Test.isRunningTest() ? OB_UtilityCallingServices.returnCurrentOrg() : 'DEV1';
			OB_Integration_Configuration__c intConfig = OB_Integration_Configuration__c.getValues(environment);
			HttpRequest  req = new HttpRequest();
			String token = OB_UtilityCallingServices.checkToken();
			req.setEndpoint(url);
			req.setMethod('POST');
			system.debug('Service message: '+token);
			req.setHeader( OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX+token);
			req.setHeader(OB_UtilityConstants.TRACE_ID_HEADER,traceIdHeader);
			if(intConfig.OB_CAsigned_name__c != null)
			{
				req.setClientCertificateName(intConfig.OB_CAsigned_name__c);
			}
			req.setHeader('Content-Type','application/json');
			req.setBody(body);
			System.debug('RESPONSE: '+req);
			HTTPResponse httpResponse = new  HTTPResponse();
			Http http = new Http();
			httpResponse = http.send(req);
			System.debug('Response body deprecateDocument: '+ httpResponse.getBody());
        }
	}

    /*******************************************************************************
    Purpose:  Method searched for and set documents to upload
    Parameters: List<String> inDocumentsName, List<String> inDocumentsTypology
    Returns: Map<String, String>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek     	 23/08/2019      Created         NEXI-261
    1.1         Joanna Mielczarek     	 02/09/2019      Modified        NEXI-286 refactor - performance
    ********************************************************************************/
    private static Map<String, String> setDocumentsToUpload( List<String> inDocumentsName, List<String> inDocumentsTypology )
    {
        System.debug( LoggingLevel.FINE, 'StampaDocumentiController.setDocumentsToUpload Into method : names: ' + inDocumentsName + ' / typologies: ' + inDocumentsTypology );
        Map<String, String> documentsToUpload = new Map<String, String>( );
        for ( List<OB_Product_Document__c> productDocumentsList :
        [
                SELECT Name,
                        OB_Description__c,
                        OB_Document_Typology__c,
                        OB_Multiple_upload__c
                FROM OB_Product_Document__c
                WHERE Name IN :inDocumentsName
                AND OB_Document_Typology__c IN :inDocumentsTypology
                Limit 50000
        ] )
        {
            for ( OB_Product_Document__c singleProductDocument : productDocumentsList )
            {
                documentsToUpload.put( singleProductDocument.OB_Description__c, singleProductDocument.OB_Document_Typology__c + ':' + singleProductDocument.OB_Multiple_upload__c );
            }
        }
        System.debug( LoggingLevel.FINE, 'StampaDocumentiController.setDocumentsToUpload : Documents to return : ' + documentsToUpload );
        return documentsToUpload;
    }

    /*******************************************************************************
    Purpose:  Method checks if user has profile Approvatore Risk Evaluation
    Parameters: -
    Returns: Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       06/09/2019      Created         NEXI-286
    ********************************************************************************/
    private static Boolean userIsApprovatoreRiskEvaluation( )
    {
        List<User> userInfos =
        [
                SELECT Profile.Name
                FROM User
                WHERE Id = :UserInfo.getUserId( )
        ];
        return userInfos.isEmpty( ) ? false : APPROVATORE_RISK_EVALUATION.equalsIgnoreCase( userInfos.get( 0 ).Profile.Name );
    }
}