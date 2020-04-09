global without sharing class OB_ContinuationController {

	//	START	micol.ferrari 13/02/2019 - TEST CLASS
	global static String requestBodyFromTestClass {get;set;}
	//	END	 	micol.ferrari 13/02/2019 - TEST CLASS

    global OB_ContinuationController() {
		String hostname = URL.getSalesforceBaseUrl().getHost();
		//System.debug(('hostname: '+ hostname);
		Integer position = hostname.indexOf('--c');
		String mydomain='';
		String endUrl = '';
		//System.debug(('position --> '+position);
        if (position != -1) {
			mydomain = hostname.substring(0, position);
			endUrl = '.lightning.force.com'; 
        } else {
				mydomain = hostname;
			}
			//System.debug(('MYDOMAIN OB_ContinuationController: ' + mydomain);
			String lcBaseURL = 'https://' + mydomain + endUrl;
			//System.debug(('lcBaseURL --> '+lcBaseURL);
			Map<String, String> headers = Apexpages.currentPage().getHeaders(); 
			headers.put('X-Frame-Options', 'ALLOW-FROM ' + lcBaseURL);
			headers.put('Content-Security-Policy', 'frame-ancestors ' + lcBaseURL);
		}

		@AuraEnabled
    global static String getVFBaseURL() {
			User user = [SELECT fullPhotoUrl FROM User WHERE Id = : UserInfo.getUserID()]; // enrico.purfificato  - 04/07/2019 - performance 
			String hostname = URL.getSalesforceBaseUrl().getHost();
			//System.debug(('hostname --> '+hostname);
			//System.debug(('base url: ' +URL.getSalesforceBaseUrl().toExternalForm());
			// The above query returns a URL like https://my-domain-dev-ed--c.na50.content.force.com/profilephoto/001/A
			// Let's use the two first fragments of that URL to create the VF base URL 
			//System.debug(('fullPhotoUrl --> '+user.fullPhotoUrl);
			List<String> fragments = user.fullPhotoUrl.split('\\.');

			//	START 	micol.ferrari 10/12/2018
			List<String> photourl = user.fullPhotoUrl.split('/');
        if (!photourl.isEmpty() && photourl.get(1) != 'profilephoto') {
				hostname += '/'+photourl.get(1);
			}
			//	END 	micol.ferrari 10/12/2018 
			//	START 	micol.ferrari 17/01/2019 - GET CURRENT ORG NAME
			String environment = !Test.isRunningTest() ? OB_UtilityCallingServices.returnCurrentOrg() : 'DEV1';
			//	END 	micol.ferrari 17/01/2019 - GET CURRENT ORG NAME
			OB_Integration_Configuration__c intConfig = OB_Integration_Configuration__c.getValues(environment);
			//System.debug(('intConfig.OB_Domain__c --> '+intConfig.OB_Domain__c);
        if (fragments[0].toLowerCase().contains(intConfig.OB_Domain__c)) {
				//System.debug(('fragments[0]' + fragments[0].toLowerCase());
				//System.debug(('fragments[1]' + fragments[1].toLowerCase());    
				//System.debug(('fragments[0].toLowerCase().contains(intConfig.OB_Domain__c) --> '+fragments[0].toLowerCase() + '.' + fragments[1].toLowerCase() + '.visual.force.com');          
				return fragments[0].toLowerCase() + '.' + fragments[1].toLowerCase() + '.visual.force.com';
        } else {
				//System.debug(('hostname getVFBaseURL !contains(intConfig.OB_Domain__c) --> '+hostname);

				//if(Test.isRunningTest()){
					return 'https://'+hostname;
				//} else {
				//	//System.debug((Network.getLoginUrl(Network.getNetworkId()).split('login').get(0));
				//	return Network.getLoginUrl(Network.getNetworkId()).split('login').get(0);
				//}
			}
		}
		
	// Called via JavaScript Remoting
	@RemoteAction
    global static Object invoke(String methodName, String[] params) {
		//System.debug(('methodName'+methodName);
		//	START 	micol.ferrari 17/01/2019 - GET CURRENT ORG NAME
		String environment = !Test.isRunningTest() ? OB_UtilityCallingServices.returnCurrentOrg() : 'DEV1';
		//	END 	micol.ferrari 17/01/2019 - GET CURRENT ORG NAME
		OB_Integration_Configuration__c intConfig = OB_Integration_Configuration__c.getValues(environment);
        if (methodName == 'getPostel') {
			// Make an HTTPRequest as we normally would
			// Remember to configure a Remote Site Setting for the service!
            //System.debug(('Class:OB_ContinuationController, Method: invoke --> parameters field: ' + params[0] + 'input chars: ' + params[1] + 'id previuos input' + params[2]);
			String url = OB_ContinuationController.getIndirizzo(params[0],params[1],params[2]);
			HttpRequest req = new HttpRequest();
			req.setEndpoint(url);
			req.setMethod('GET');
            if (intConfig.OB_CAsigned_name__c != null) {
				req.setClientCertificateName(intConfig.OB_CAsigned_name__c); 
			}
			String token = OB_UtilityCallingServices.checkToken();
			req.setHeader( OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX+token);
			//System.debug(('Request to service contract: ' + req);
			// Create a Continuation for the HTTPRequest        
			Continuation con = new Continuation(Integer.valueOf(intConfig.OB_Timeout_Continuation__c));
			//System.debug(('start continuation'+ con);
			con.state = con.addHttpRequest(req);//new StateInfo('Some state data', listField);
			con.continuationMethod = 'callback';        
			//System.debug(('continuation'+ con);
			// Return it to the system for processing
			return con;
        } else if (methodName == 'retriveServicePoint') {
				//System.debug(('Siamo ne invoke: '+methodName);
				String url = 'callout:OB_callService/api/merchant-registry/sale-points/search';
				HttpRequest req = new HttpRequest();
				req.setEndpoint(url);
				req.setMethod('POST');
				String token = OB_UtilityCallingServices.checkToken();
				//System.debug(('Service message: '+token);
            if (token != 'Error') {
					req.setHeader( OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX+token);
					req.setHeader('Content-Type','application/json');
                if (intConfig.OB_CAsigned_name__c != null) {
						req.setClientCertificateName(intConfig.OB_CAsigned_name__c); 
					}
					req.setBody('{"acquiringCompanies": [{"companyCode": "'+params[0]+'","processor": "'+params[1]+'"}],"POSCompanies":[{"gtCompanyCode":"'+params[2]+'","gtCode": "'+params[3]+'"}],"merchantCategoryCode": "'+params[4]+'","postalCode": "'+params[5]+'","isEcommerce": "'+params[6]+'"}');
					//System.debug(('Request to service contract: ' + req);
				// Create a Continuation for the HTTPRequest   
				Continuation con = new Continuation(Integer.valueOf(intConfig.OB_Timeout_Continuation__c));
				//System.debug(('start continuation'+ con);
				con.state = con.addHttpRequest(req);
				con.continuationMethod = 'callback';        
				//System.debug(('continuation'+ con);
				return con;
            } else {
					return 'Error';
				}
        } else if (methodName == 'retriveMerchant') {
					//System.debug(('Siamo ne invoke: '+methodName);
					String url = 'callout:OB_callService/api/merchant-registry/merchants/search';
					HttpRequest req = new HttpRequest();
					req.setEndpoint(url);
					req.setMethod('POST');
					String token = OB_UtilityCallingServices.checkToken();
					//System.debug(('Service message: '+token);
            if (token != 'Error') {
						req.setHeader( OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX+token);
						req.setHeader('Content-Type','application/json');
						req.setBody('{"fiscalCode": \"'+params[0]+'\","vatCode": \"'+params[1]+'\"}');
                if (intConfig.OB_CAsigned_name__c != null) {
							req.setClientCertificateName(intConfig.OB_CAsigned_name__c); 
						} 
						//System.debug(('Request to service contract: ' + req);

		  // Create a Continuation for the HTTPRequest   

		  Continuation con = new Continuation(Integer.valueOf(intConfig.OB_Timeout_Continuation__c));
		  //System.debug(('start continuation'+ con);
		  con.state = con.addHttpRequest(req);
		  con.continuationMethod = 'callback';        
		  //System.debug(('continuation'+ con);
		  return con;
            } else {
		  	return 'Error parsing';
		  }

        } else if (methodName == 'getBase64DocID') {
			/*
				params[0] : merchantId  String  Id del Merchant associate all’ordine
				params[1] : servicePointId String Id del service point legato all’ordine
				params[2] : orderHeaderId String Id dell’ordine per cui si sta caicando il doc
				params[3] : configurationItem
				params[4] : recordId String 
				params[5] : isNewUpload Boolean is first upload or a new upload after edit
				params[6] : documentId String documentId salvato in pagina per il documento precedentemente caricato
				oarams[7] : description document type
				*/
				//System.debug(('Siamo ne invoke: '+methodName);
				//System.debug(('Siamo ne invoke params[0]: '+params[0]);
				//System.debug(('Siamo ne invoke params[1]: '+params[1]);
				//System.debug(('Siamo ne invoke params[2]: '+params[2]);
				//System.debug(('Siamo ne invoke params[3]: '+params[3]);
				//System.debug(('Siamo ne invoke params[4]: '+params[4]);
				//System.debug(('Siamo ne invoke params[5]: '+params[5]);
				//System.debug(('Siamo ne invoke params[6]: '+params[6]); 
				//System.debug(('Siamo ne invoke params[7]: '+params[7]);
            OB_Contract__c contract = [
                    SELECT id,OB_Contract_Code__c,OB_Contract_Version__c,
                            OB_Template_Name__c,OB_Commercial_Product__r.OB_Codice_sfdc__c,
                            OB_Typology__c
                    FROM OB_Contract__c
                    WHERE id = :params[4]
            ];
				String base = '';	
				String url=''; 
				String body = '';
				Map <String,String> docInfo = new Map<String,String>();
				OB_ContinuationController.ResponseGenerate res = new OB_ContinuationController.ResponseGenerate();
				String docId = '';
			 //System.debug(('new: '+!params[5].equalsIgnoreCase('true'));
			 OB_ContinuationController.ResponseGenerate response = new OB_ContinuationController.ResponseGenerate(); 
            if (!params[5].equalsIgnoreCase('true')) {
			 	res = OB_ContinuationController.generateDocument(params[0],params[1],params[2],params[3],contract,params[7]); 
			 	//System.debug(('res generate new: '+res);
            } else {
			 		res = OB_ContinuationController.deprecateDocument(params[0],params[1],params[3],params[6]);	
			 		OB_ContinuationController.responseGenerate isDeprecated = res;
			 		//System.debug(('After service deprecated call: '+ isDeprecated);
			 		res = OB_ContinuationController.generateDocument(params[0],params[1],params[2],params[3],contract,params[7]);
			 		//System.debug(('res regenerate: '+res);
			 	}
			 	String docStream = res.documentStream; 
			 	docId = res.documentId;
			 	docInfo.put(docId,docStream);
            if (docStream == null || docStream == '' || response.error.code == 'KO') {
			 		docInfo.put('status code','KO');
			 	}
			 	//System.debug(('doc: '+docId);
			 	OB_UtilityCallingServices.saveToken(OB_UtilityCallingServices.tokenGlobalVar,String.valueof(OB_UtilityCallingServices.timestamp));
			 	return docInfo;
        } else if (methodName == 'filenetUpload') {
  			//System.debug(('Siamo ne invoke params[0]: '+params[0]); 	// merchantId
  			//System.debug(('Siamo ne invoke params[1]: '+params[1]);	// servicePointId
  			//System.debug(('Siamo ne invoke params[2]: '+params[2]);	// logRequestId/configurationId 
  			//System.debug(('Siamo ne invoke params[3]: '+params[3]);	// documentType
  			//System.debug(('Siamo ne invoke params[4]: '+params[4]); 	// base64
  			//System.debug(('Siamo ne invoke params[5]: '+params[5]);	// true/ false
  			//System.debug(('Siamo ne invoke params[6]: '+params[6]); 	// documentId
  			//System.debug(('Siamo ne invoke params[7]: '+params[7]);	// file name
  			OB_ContinuationController.ResponseGenerate res = new OB_ContinuationController.ResponseGenerate();
  			HttpRequest  req = new HttpRequest();
  			//HttpRequest  req = OB_ContinuationController.createRequest(params[0],params[1],'',params[2],'',contract,'false',params[3]);					
            if (!params[5].equalsIgnoreCase('true')) {
  				req = OB_ContinuationController.createRequest(params[0],params[1],'',params[2],params[6],null,params[5],'true',params[4],params[3],params[7]);
  				//(String merchant,String salePoint,String orderHeader,String configurationItemId,String docId, OB_Contract__c contract,String isToRegenerate, String isUpload,String  file, String documentType,String description)
  				//System.debug(('Request to service contract: ' + req);
  				Continuation con = new Continuation(Integer.valueOf(intConfig.OB_Timeout_Continuation__c));
  				//System.debug(('start continuation'+ con);
  				con.state = con.addHttpRequest(req);
  				con.continuationMethod = 'callback';        
  				//System.debug(('continuation'+ con);
  				return con;
            } else {
  					res = OB_ContinuationController.deprecateDocument(params[0],params[1],params[2],params[6]);	
  					OB_ContinuationController.responseGenerate isDeprecated = res;
  					//System.debug(('After service deprecated call: '+ isDeprecated);
  					req = OB_ContinuationController.createRequest(params[0],params[1],'',params[2],params[6],null,params[5],'true',params[4],params[3],params[7]);
  					return res.documentId;
  				}
        } else if (methodName == 'visualizeDocLoad') {
			/*
				params[0] : MerchantId
				params[1] : SalesPointId
				params[2] : OrderId
				params[3] : DocumentId
				*/
				//System.debug(('Siamo ne invoke: '+methodName);
				//System.debug(('Siamo ne invoke params[0]: '+params[0]);
				//System.debug(('Siamo ne invoke params[1]: '+params[1]);
				//System.debug(('Siamo ne invoke params[2]: '+params[2]);
				//System.debug(('Siamo ne invoke params[3]: '+params[3]);
				String url = 'callout:OB_callService/api/merchants/'+params[0]+'/sales-points/'+params[1]+'/orders/'+params[2]+'/documents/'+params[3];
				//System.debug(('URL: '+url);
				String body = '';
				Http http = new Http();
				HttpRequest req = new HttpRequest();
				String token = OB_UtilityCallingServices.checkToken();
				req.setEndpoint(url);
				req.setMethod('GET');
				//System.debug(('Service message: '+token);
				req.setHeader( OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX+token);
			// start spinelli.giovanni 05/05/2019  increase timeout from 30 sec to 60 sec
			req.setTimeout(60000);
			// end spinelli.giovanni 26/03/2019 increase timeout from 30 sec to 60 sec
				HTTPResponse res = new HTTPResponse();
				if(!Test.isRunningTest()){
					res = new HTTPResponse();
					res = http.send(req);
				} else {
					res.setBody('{"documentStream" : "qwertyui23456789cvbn","documentFileName":"test"}');
				}
					//System.debug(('Response body: '+res.getBody());
					Map <String,String> docInfo = new Map<String,String>();
					OB_ContinuationController.ResponseGenerate response = new OB_ContinuationController.ResponseGenerate();  
					response = (OB_ContinuationController.ResponseGenerate) System.JSON.deserialize(res.getBody(), OB_ContinuationController.ResponseGenerate.class);
					String docStream = response.documentStream; 
					String docId = response.documentFileName;
					docInfo.put(docId,docStream);
					//System.debug((docInfo);
					return docInfo;
				}
			//	START 	micol.ferrari 03/12/2018
        else if (methodName == 'visualizeDocLoadLogRequest') {
			/*
				params[0] : MerchantId
				params[1] : SalesPointId
				params[2] : Log Request Id
				params[3] : DocumentId
				*/
				//System.debug(('Siamo ne invoke: '+methodName);
				//System.debug(('Siamo ne invoke params[0]: '+params[0]);
				//System.debug(('Siamo ne invoke params[1]: '+params[1]);
				//System.debug(('Siamo ne invoke params[2]: '+params[2]);
				//System.debug(('Siamo ne invoke params[3]: '+params[3]);

				String url 			= 'callout:OB_callService/api/merchants/'+params[0]+'/requests/'+params[2]+'/documents/'+params[3];
            if (params[1] != null && params[1] != '') {
					url 		 	= 'callout:OB_callService/api/merchants/'+params[0]+'/sales-points/'+params[1]+'/requests/'+params[2]+'/documents/'+params[3];
				}
				//System.debug(('URL: '+url);

				String body 	= '';
				Http http 		= new Http();
				HttpRequest req = new HttpRequest();
				String token 	= OB_UtilityCallingServices.checkToken();
				req.setEndpoint(url);
				req.setMethod('GET');
				//System.debug(('Service message: '+token);
				req.setHeader( OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX+token);
			//req.setHeader('Content-Type','application/json');
			// start spinelli.giovanni 05/05/2019  increase timeout from 30 sec to 60 sec
			req.setTimeout(60000);
			// end spinelli.giovanni 05/05/2019  increase timeout from 30 sec to 60 sec
			HTTPResponse res = new HTTPResponse();
			if(!Test.isRunningTest()){
				res = new HTTPResponse();
				res = http.send(req);
            } else {
					res.setBody('{"documentStream" : "qwertyui23456789cvbn","documentFileName":"test"}');
				}
				//System.debug(('Response body: '+res.getBody());
				Map <String,String> docInfo = new Map<String,String>();
				OB_ContinuationController.ResponseGenerate response = new OB_ContinuationController.ResponseGenerate();  
				response = (OB_ContinuationController.ResponseGenerate) System.JSON.deserialize(res.getBody(), OB_ContinuationController.ResponseGenerate.class);
				String docStream 	= response.documentStream; 
				String docId 		= response.documentFileName;
				docInfo.put(docId,docStream);
				//System.debug((docInfo);
				return docInfo;
			}
  		//	END 	micol.ferrari 03/12/2018
        else {
  			return null;
  		}
  	}

    global static Object callback(Object state) {
  		String field = '';
  		//System.debug(('state del continuation '+state);
  		HttpResponse response = new HttpResponse();
        if (!Test.isRunningTest()) {
  			response = Continuation.getResponse((String)state); 
        } else {
  				response.setStatusCode(200);
				//	START	micol.ferrari 13/02/2019 - TEST CLASS
				response.setBody(requestBodyFromTestClass);
				//	END		micol.ferrari 13/02/2019 - TEST CLASS
  			}
  			//System.debug(('LA RISPOSTA DEL CONTINUATION'+response);
  			Integer statusCode = response.getStatusCode();
  			//System.debug(('//System.debug((statusCode);'+statusCode);
  			//System.debug(('error parsing'+response.getBody().contains('<html><body><h1>Whitelabel Error Page</h1>'));
        if (statusCode > 200) {
  				//System.debug(('Continuation error: ' + statusCode);
  				return 'Error';
			//return 'Continuation error: ' + statusCode;
		}
        if (response.getBody().contains('xml')) {
			Map<String,String> responseMap = new Map<String,String>();
			field = OB_ContinuationController.getField(response.getBody());
			responseMap = AutoCompleteComponentController.getResult(response.getBody(),field);
			OB_UtilityCallingServices.saveToken(OB_UtilityCallingServices.tokenGlobalVar,String.valueof(OB_UtilityCallingServices.timestamp));
			return responseMap;
        } else if (response.getBody().contains('documentStream')) {
				OB_ContinuationController.ResponseGenerate res =  (OB_ContinuationController.ResponseGenerate) System.JSON.deserialize(response.getBody(), OB_ContinuationController.ResponseGenerate.class);
				OB_UtilityCallingServices.saveToken(OB_UtilityCallingServices.tokenGlobalVar,String.valueof(OB_UtilityCallingServices.timestamp));
				return   res.documentId;     
        } else {
					OB_UtilityCallingServices.saveToken(OB_UtilityCallingServices.tokenGlobalVar,String.valueof(OB_UtilityCallingServices.timestamp));
					//System.debug(('response.getBody() retrieveMErchant --> '+response.getBody());
					return response.getBody();
				}
			}

    private static String getIndirizzo(String inputField, String input, String idField) {
				//System.debug(('inputField'+inputField+'input'+input+'idField'+idField);
				String url = '';
        if (!String.IsBlank(inputField)) {
					if(inputField.contains('provincia')) 
					url = 'callout:OB_Postel_Autocomplete/province';
					if(inputField.contains('comune'))
					url = 'callout:OB_Postel_Autocomplete/comuni?in='+input+'&prov='+idField;
					if(inputField.contains('frazione'))
					url = 'callout:OB_Postel_Autocomplete/frazioni?in='+input+'&com='+idField;
					if(inputField.contains('strada'))
					url = 'callout:OB_Postel_Autocomplete/strade?in='+input+'&loc='+idField;

				}
				//System.debug(('url'+url);
				return url;
			}


    private static String getField(String response) {
				Dom.Document doc = new Dom.Document();
				doc.load(response);
				String field = '';
				String caseField='';
				Dom.XmlNode rootNode = doc.getRootElement();
        for (Dom.XMLNode child : rootNode.getChildren()) {
					caseField =child.getText();
            if (caseField != '') {
						switch on (caseField) { 
							when 'PROVINCE'{
								field = 'provincia';
							}
							when 'COMUNE'{
								field = 'comune';
							}
							when 'FRAZIONE'{
								field= 'frazione'; 
							}
							when 'STRADA' {
								field= 'strada'; 
							}
						}
					}
            if (field != '') {
                break;
            }
					//System.debug(('field '+field);
				}
				return field;
			}

    private static OB_ContinuationController.responseGenerate generateDocument(String merchant, String salePoint, String orderHeader, String configurationItemId, OB_Contract__c contract, String descriptionDocType) {
							HttpRequest  req = new HttpRequest();
							req = OB_ContinuationController.createRequest(merchant,salePoint,orderHeader,configurationItemId,'',contract,'false','false',null,'',descriptionDocType);					
							//System.debug(('req body: '+ req.getBody());
							Http http = new Http();
							OB_ContinuationController.ResponseGenerate response = new OB_ContinuationController.ResponseGenerate(); 
							HTTPResponse res = new HTTPResponse();
							try{
								res = http.send(req);
								//System.debug(('Response body: '+res.getBody());
        } catch (Exception e) {
									response.error.message='Servizio in eccezione: '+ e; 
									response.error.code='KO';
									return response;
								}
        if (!res.getBody().contains('<html>')) {
									response = (OB_ContinuationController.ResponseGenerate) System.JSON.deserialize(res.getBody(), OB_ContinuationController.ResponseGenerate.class);
									//System.debug(('OB_ContinuationController.ResponseGenerate: '+ response);
        } else {
										response.error.message='Servizio in eccezione'; 
										response.error.code='KO';
									}
									return response;
								}

    private static OB_ContinuationController.ResponseGenerate deprecateDocument(String merchant, String salePoint, String configurationItemIdOrLogRequest, String docId) {
		//System.debug(('docId deprecate: '+docId);
		HttpRequest  req = OB_ContinuationController.createRequest(merchant,salePoint,'',configurationItemIdOrLogRequest,docId,null,'true','true',null,'','');
		OB_ContinuationController.ResponseGenerate response = new OB_ContinuationController.ResponseGenerate();  
		HTTPResponse httpResponse = new  HTTPResponse();
		try{
			Http http = new Http();
			httpResponse = http.send(req);
			//System.debug(('Response body: '+ httpResponse.getBody());
        } catch (Exception e) {
				response.error.message='Servizio deprecate file in eccezione: '+ e; 
				response.error.code='KO';
				System.debug('Response KO Servizio deprecate file: ' + response);
				return response;
			}
			response = (OB_ContinuationController.ResponseGenerate) System.JSON.deserialize(httpResponse.getBody(), OB_ContinuationController.ResponseGenerate.class);
			//System.debug(('deprecate response: '+response);
			return response; 
		}

    /***********************************************************
     Purpose: ?
     Parameters: String merchant, String salePoint, String orderHeader, String configurationIdOrLogRequest,String docId, OB_Contract__c contract, String isToRegenerate, String isUploade, String file, String documentType, String descriptionSFDC
     Returns: HttpRequest

     History:
     -------
     VERSION AUTHOR         DATE         DETAIL      DESCRIPTION:
     1.0        ?             ?          CREATE      METHOD CREATED
     1.1     LUBRANO M.    10/04/2019    MODIFY      SETUP-251 FIX
     ***********************************************************/
    private static HttpRequest createRequest(String merchant, String salePoint, String orderHeader, String configurationIdOrLogRequest, String docId, OB_Contract__c contract, String isToRegenerate, String isUpload, String file, String documentType, String descriptionSFDC) {
			//	START 	micol.ferrari 17/01/2019 - GET CURRENT ORG NAME
			//String environment = !Test.isRunningTest() ? system.Label.OB_Environment : 'DEV1';
        //LUBRANO 2019-04-09 -- SETUP-251-setting variable description without sdcd code
        String description = descriptionSFDC;
        String posType = '';
        if (descriptionSFDC.contains('__')) {
            description = descriptionSFDC.split('__')[0];
            posType = descriptionSFDC.split('__')[1];
        }
        //LUBRANO 2019-04-09 -- SETUP-251  -   END
			String environment = !Test.isRunningTest() ? OB_UtilityCallingServices.returnCurrentOrg() : 'DEV1';
			//	END 	micol.ferrari 17/01/2019 - GET CURRENT ORG NAME
			OB_Integration_Configuration__c intConfig = OB_Integration_Configuration__c.getValues(environment);
			String url = '';
			String body = '';
			HttpRequest req = new HttpRequest();
			//System.debug(('file: '+file);
			//System.debug(('contract createRequest: '+contract);
			String traceIdHeader =  String.valueof(DateTime.now()).replaceAll(' ','T');
			//  START   micol.ferrari 03/12/2018
			Id configurationIdOrLogRequestId = Id.valueOf(configurationIdOrLogRequest);
			//System.debug(('****condition: '+(configurationIdOrLogRequestId.getsobjecttype()==Schema.NE__Order__c.getSObjectType()));
			//System.debug(('****configurationIdOrLogRequest: '+configurationIdOrLogRequest);
			//System.debug(('****Id configurationIdOrLogRequestId: '+configurationIdOrLogRequestId);
			//System.debug(('****Schema.NE__Order__c.getSObjectType(): '+Schema.NE__Order__c.getSObjectType());
        if (configurationIdOrLogRequestId.getsobjecttype() == Schema.NE__Order__c.getSObjectType()) {
            if (!isToRegenerate.equalsIgnoreCase('true')) {
					url = 'callout:OB_callService/api/merchants/'+merchant+'/sales-points/'+salePoint+'/orders/'+configurationIdOrLogRequest+'/documents';
                if (!isUpload.equalsIgnoreCase('true')) {
						OB_Serialize_Order t = new OB_Serialize_Order();
						//System.debug(('orderHeader createRequest: '+orderHeader);
						//System.debug(('posType createRequest: '+contract.OB_Contract_Code__c);
						//System.debug(('posType createRequest: '+contract.OB_Typology__c);
                    body = '{"documentType":"CONTRATTO","templateName":"' + contract.OB_Contract_Code__c + '","templateVersion":"' + contract.OB_Contract_Version__c + '","documentStream":"","documentStatus":"ACTIVE","posType":"' + posType + '","documentBody":' + t.serializeOrder(orderHeader) + ',"callbackUrl":""}';
						//System.debug(('createRequest body createRequest' + body ); 
						traceIdHeader +=orderHeader+contract.OB_Contract_Code__c+contract.OB_Contract_Version__c;         
                } else {
						//System.debug((documentType);
						body = '{"documentType":"'+documentType+'","templateName":"","templateVersion":"","documentStream":"'+file+
						'","documentStatus":"ACTIVE","posType":"","Campi_Setup_Contratto":"","documentFileName":"'+description+'","callbackUrl":""}';
						traceIdHeader += configurationIdOrLogRequest+documentType+description.replaceAll(' ','%20');
					}
            } else {
					url = 'callout:OB_callService/api/merchants/'+merchant+'/sales-points/'+salePoint+'/orders/'+configurationIdOrLogRequest+'/documents/'+docId;
					body = '{"documentStatus":"DEPRECATED"}';
				}
			}
			//  LOG REQUEST
        else {
            if (!isToRegenerate.equalsIgnoreCase('true')) {
					//System.debug(('## INSIDE isToRegenerate FALSE');
					url       = 'callout:OB_callService/api/merchants/'+merchant+'/requests/'+configurationIdOrLogRequest+'/documents';
                if (salePoint != null && salePoint != '') {
						url     = 'callout:OB_callService/api/merchants/'+merchant+'/sales-points/'+salePoint+'/requests/'+configurationIdOrLogRequest+'/documents';
						//System.debug(('@@@@ We have a SalesPointId');
                } else {
                    //System.debug(('@@@@ We  haven t a SalesPointId');
                }
						//System.debug(('## INSIDE url '+url);
                if (!isUpload.equalsIgnoreCase('true')) {
                    //do something
                } else {
						//System.debug(('## documenttype '+documentType);
						body = '{"documentType":"'+documentType+'","templateName":"","templateVersion":"","documentStream":"'+file+
						'","documentStatus":"ACTIVE","posType":"","Campi_Setup_Contratto":"","documentFileName":"'+description+'","callbackUrl":""}';
						//System.debug(('## body '+body);
						traceIdHeader += configurationIdOrLogRequest+documentType+description.replaceAll(' ','%20');
					}
            } else {
					//url = 'callout:OB_callService/api/merchants/'+merchant+'/sales-points/'+salePoint+'/orders/'+configurationIdOrLogRequest+'/documents/'+docId;
					url = 'callout:OB_callService/api/merchants/'+merchant+'/requests/'+configurationIdOrLogRequest+'/documents/'+docId;
                if (salePoint != null && salePoint != '') {
						url     = 'callout:OB_callService/api/merchants/'+merchant+'/sales-points/'+salePoint+'/requests/'+configurationIdOrLogRequest+'/documents/'+docId;
					}
					body = '{"documentStatus":"DEPRECATED"}';
					//System.debug(('## INSIDE url '+url);
				}
			}
			//  END   micol.ferrari 03/12/2018
			String token = OB_UtilityCallingServices.checkToken();
			req.setEndpoint(url);
			req.setMethod('POST');
			//System.debug(('Service message: '+token);
			req.setHeader( OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX+token);
			req.setHeader(OB_UtilityConstants.TRACE_ID_HEADER,traceIdHeader);
		// start spinelli.giovanni 05/05/2019  increase timeout from 30 sec to 60 sec
		req.setTimeout(60000);
		// end spinelli.giovanni 05/05/2019  increase timeout from 30 sec to 60 sec
        if (intConfig.OB_CAsigned_name__c != null) {
				req.setClientCertificateName(intConfig.OB_CAsigned_name__c); 
			}
			req.setHeader('Content-Type','application/json');
			req.setBody(body);
			//System.debug(('Request to service contract createRequest: ' + req);
			//System.debug(('Request to service contract createRequest: ' + req.getBody());
			return req;
		}
    // wrapper class response filenet
    public class ResponseGenerate {
		public String documentId 			{get;set;}
		public String fileName 			{get;set;}
		public String documentStream  	{get;set;}
		public String documentFileName 	{get;set;}
		public Error error = new Error();
	}
	public class Error
	{
		public String code 		{get;set;}
		public String message 	{get;set;}
	}

	@AuraEnabled
    global static Map<String, String> getFileName(String merchantId, String salespointsId, String configurationIdOrLogRequest, String docId, Boolean isLogRequest) {
		String url='';
		if (isLogRequest){
            if (salespointsId != '' && salespointsId != null) {
				url = 'callout:OB_callService/api/merchants/'+merchantId+'/sales-points/'+salespointsId+'/requests/'+configurationIdOrLogRequest+'/documents/'+docId;
            } else {
				url = 'callout:OB_callService/api/merchants/'+merchantId+'/requests/'+configurationIdOrLogRequest+'/documents/'+docId;			
			}
        } else {
			url = 'callout:OB_callService/api/merchants/'+merchantId+'/sales-points/'+salespointsId+'/orders/'+configurationIdOrLogRequest+'/documents/'+docId;
		}

		//System.debug(('URL: '+url);
		String body = '';
		Http http = new Http();
		HttpRequest req = new HttpRequest();
		String token = OB_UtilityCallingServices.checkToken();
		req.setEndpoint(url);
		req.setMethod('GET');
		//System.debug(('Service message: '+token);
		req.setHeader( OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX+token);
		// start spinelli.giovanni 05/05/2019  increase timeout from 30 sec to 60 sec
		req.setTimeout(60000);
		// end spinelli.giovanni 05/05/2019  increase timeout from 30 sec to 60 sec
		HTTPResponse res = new HTTPResponse();
		res = http.send(req);
		//System.debug(('Response body: '+res.getBody());
		Map <String,String> docInfo = new Map<String,String>();
		OB_ContinuationController.ResponseGenerate response = new OB_ContinuationController.ResponseGenerate();  
		response = (OB_ContinuationController.ResponseGenerate) System.JSON.deserialize(res.getBody(), OB_ContinuationController.ResponseGenerate.class);
		String docStream = response.documentStream; 
		String name = response.fileName;
		docInfo.put('BASE64',docStream);
		docInfo.put('DOCID',docId);
		docInfo.put('FILENAME',name);
		//System.debug((docInfo);
		return docInfo;
	}

	@AuraEnabled
	public static string getStateLogRequest (string logRequestId){
		List<OB_LogRequest__c> listLog = [select id, OB_Status__c from OB_LogRequest__c where id =: logRequestId];
		String status = '';
		if(!listLog.isEmpty()){
			status = listLog.get(0).OB_Status__c;
		}
		//System.debug(('###Status logRequest: '+status);
		return status;
	}
	/*******************************************************************************
    Purpose: Method calls getTokenJWE with null inLogRequestId
    Parameters: String String documentName
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Giovanni Spinelli      	30/05/2019      Created         	?
    2.0 		Marta Stempien			10/09/2019		Modified		NEXI-298
    ********************************************************************************/
	@AuraEnabled
    public static Map<String , String> getTokenJWE(String documentName){
		return getTokenJWE(documentName, null);
	}

	/*******************************************************************************
    Purpose: Method get token valid 5 min
    Parameters: String inLogRequestId, String documentName
    Returns: Map<String , String>

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Giovanni Spinelli      	30/05/2019      Created         	?
    2.0 		Marta Stempien			10/09/2019		Modified		NEXI-298
    ********************************************************************************/
	@AuraEnabled
	public static Map<String , String> getTokenJWE(String documentName, String inLogRequestId){
		Map<String , String> returnMap = new Map<String , String>();
		returnMap = OB_UtilityCallingServices.getTokenJWEMethod(documentName);
		returnMap.put('logRequestId', inLogRequestId);
		return returnMap;
	}
	/*******************************************************************************
	Purpose:  method to retrieve template for quote
    Parameters: Name template
    Returns: Id template

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         gianluigi.virga         19/09/2019      Created         Retrieve template to print quote
	
 	********************************************************************************/
    @AuraEnabled
    public static String retrieveQuoteTemplate(String templateName){
		String template;
		List<OB_Contract__c> templates = [SELECT Id FROM OB_Contract__c WHERE OB_Template_Name__c = :templateName LIMIT 1];
		System.debug('List templates: ' + templates);
		if(!templates.isEmpty()){
			template = templates[0].Id;
		}
		return template;
	}
}