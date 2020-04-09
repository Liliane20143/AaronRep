({

	logInit : function(component, event, helper){
		_utils.logInit(component.getName()); 
	},

	doInit : function(component, event, helper)
	{
		var docList= component.get("v.documentsList");
		
		// _utils.info("++++"+JSON.stringify(docList));
		var mapMultiple= component.get("v.mapMultiple");
		var docType = component.get("v.documentType");
		for(var i=0; i<docList.length; i++)
		{
			var isMultiple=docType[docList[i]].split(':')[1];
			mapMultiple[docList[i]]= isMultiple;
		}
		component.set("v.mapMultiple",mapMultiple);
		// _utils.info("****map isMultiple"+JSON.stringify(mapMultiple));
		var singledoc=component.get("v.singleDoc");
		var idDoc = singledoc.replace(/ /gi, "_");
		var idview= "view__"+idDoc;
		component.set("v.idView", idview);
		var idload= "load__"+idDoc;
		component.set("v.idLoad", idload);
		// var listFields = component.get("v.listFields");
		var license = component.get("v.license");
	//	console.log("license: "+ license);
		var isAdmin = component.get("v.isAdmin");
	//	console.log("isAdmin: "+ isAdmin);
		var rejectReasonBool = component.get("v.rejectReasonBool");
	//	console.log("rejectReasonBool: "+ rejectReasonBool);
		var fromItemsApprovalStatus = component.get("v.fromItemsApprovalStatus");
	//	console.log("fromItemsApprovalStatus: "+ fromItemsApprovalStatus);
		//Start antonio.vatrano 07/05/2019 r1f2-82
		var isOperation = component.get("v.isOperation");
		console.log("isOperation: "+ isOperation);
		if ((!isAdmin && license == $A.get("$Label.c.OB_License_PartnerCommunity")) || isOperation )
		{
				component.set("v.canUpload", true);
		}
		//start antonio.vatrano ri-76 22/05/2019 
		var inModal = component.get('v.isDraftModal');
		if(rejectReasonBool || isOperation || inModal){
			component.set("v.readonly", false);
		}
		//End antonio.vatrano ri-76 22/05/2019 
		else{
			component.set("v.readonly", true);
		}
		//End antonio.vatrano 07/05/2019 r1f2-82
		console.log("@@canUpload: "+component.get("v.canUpload"));
		console.log("@@readonly: "+component.get("v.readonly"));
		console.log("@@rejectReasonBool: "+rejectReasonBool);


		
	
	},




	onRender : function (component, event, helper)
	{
		if (component.get("v.doneRender")==false)
		{
			component.set("v.doneRender",true);//giovanni spinelli 27/06/2019 move here this setting to fire once only onRender method
			var singledoc=component.get("v.singleDoc");
			var idView = component.get("v.idView");
			var buttonView =document.getElementById(idView);
			var compareMap=component.get("v.compareMap");
			var mapMultiple = component.get("v.mapMultiple");
			var isMultiple = mapMultiple[singledoc];
			if(typeof compareMap[singledoc] != 'undefined' && compareMap[singledoc]!=null)
			{
				if(compareMap[singledoc].length>0)
				{
					//_utils.info('****done render second');
					var listId = compareMap[singledoc];
					var listFields = component.get("v.listFields");
					var merchantId = listFields[2];
					var salespointsId = listFields[1];
					var configurationIdOrLogRequest = listFields[0];
					var listId = compareMap[singledoc];
					if( typeof(salespointsId) == 'undefined' || salespointsId=='' || salespointsId==null )
					{
						salespointsId= '';
					}
					if (listFields.length>6)
					{
						/*
						* Author : Giovanni Spinelli
						* Date : 24/06/2019
						* Description : get single base64 from js - logRrequest page
						*/
						configurationIdOrLogRequest = listFields[6];
						for(var i =0 ; i<listId.length; i++){
							var docId = listId[i];
							//giovanni spinelli
							component.set('v.showSpinner', true);
							helper.getDocsfromJS(component , docId , merchantId ,salespointsId ,configurationIdOrLogRequest , true ,isMultiple);
							
						
						}
					}
					else
					{
						/*
						* Author : Giovanni Spinelli
						* Date : 03/06/2019
						* Description : get single base64 from js in Configuration or Order Header page
						*/
						for(var i =0 ; i<listId.length; i++){
							var docId = listId[i];
							console.log('list id: ', listId);
							component.set('v.showSpinner', true);//giovanni spinelli 27/06/2019 fire spinner
							console.log('ID DOCS IN FOR LOOP: ' + docId);
							var action = component.get("c.getFileName");
							
							try{
								var action2 = component.get("c.getTokenJWE");
								action2.setParams({   documentName     :  docId});
								action2.setCallback(this, function(response){
									var state = response.getState();
									console.log('state getToken is: ' + state);
									console.log('response is: ' +JSON.stringify(response.getReturnValue()) );
									var response = response.getReturnValue();
									
									if (state === "SUCCESS") {
										var buttonView =document.getElementById(idView);
										//buttonView.classList.add("slds-hide");	
										var token 		= response['jewToken'];
										var documentId 	= response['documentId'];
										console.log('document id from server: ' + documentId);
										//var url   			= response['FEurl'] + '/api/merchants/'+merchant+'/sales-points/'+salePoint+'/orders/'+orderId+'/documents';
										var url = response['FEurl'] + '/api/merchants/'+merchantId+'/sales-points/'+salespointsId+'/orders/'+configurationIdOrLogRequest+'/documents/'+documentId;
										console.log('TOKEN: ' + token);
										console.log('FE URL: '+ url);
										// component.set("v.uploadFileUrl" , url);
										// component.set("v.jweToken"		, token);
										//helper.callBackJWE(component, token, url);
										var request = new XMLHttpRequest();
										
										request.open("GET", url, true);
										request.setRequestHeader("Content-Type", "application/json");
										request.setRequestHeader("token", token);
										request.onreadystatechange = function () {
											if (request.readyState === 4 && request.status === 200)
												{
													component.set('v.showSpinner' ,  false);
													// buttonView.classList.remove("slds-hide");
													// buttonView.classList.add("slds-show");
													var res = JSON.parse(request.responseText);
													console.log('RESPONSE HTTP: '+JSON.stringify(res) );
													var filename = res['filename'];
													var idDoc =documentId ;
													console.log('ID DOCS IN IF: ' + idDoc);
													// var idDoc = res['DOCID'];
													var b64 = res['documentStream'];
													console.log('BASE64: '+ b64);
													var mapValueDocs = component.get('v.mapValueDocs');
													var innerMap = {};
													innerMap['filename'] 	= filename;
													innerMap['b64'] 		= b64;
													mapValueDocs[idDoc] 	= innerMap;
													component.set('v.mapValueDocs',mapValueDocs);
													component.set('v.idDocJS', idDoc);//store file name
													component.set('v.fileNameJS' , filename);
													console.log('### file id: ' + component.get('v.idDocJS'));
													var listFields = component.get("v.listFields");
													var orderHeaderId = component.get("v.orderHeaderId");
													if(isMultiple=="true")
													{
														console.log('multiple map: ' , component.get("v.multipleMapId"));
														console.log('### id contratto firmato: ' + component.get('v.idDocJS'));
														var canUpload = component.get("v.canUpload");
														var readOnly = component.get("v.readonly");
														var condition = canUpload && !readOnly;
												//		console.log("@@@con: "+condition+ "    canUpload: "+canUpload+'			readonly: '+readOnly);
												//		console.log("@@@inModal: "+component.get("v.isDraftModal"));
														var idView = component.get("v.idView");
														var buttonView =document.getElementById(idView);
														buttonView.classList.add("slds-hide");
														console.log('file name: ' + filename);
														console.log('listFields: ' + listFields);
														component.set('v.fireDynamicComponent' , true);
														component.set('v.fireDynamicComponent' , false);
														// $A.createComponent("c:OB_AttachedDocumentationsDynamic", 
														// {
														// 	"Id" : "id_"+documentId,
														// 	"IdFilenet" :  documentId,
														// 	"inputText" : filename,  
														// 	"listFields" : listFields,
														// 	"documentType" : component.get("v.documentType"),
														// 	"singleDoc" : component.get("v.singleDoc"),
														// 	"multipleMapId": component.get("v.multipleMapId"),
														// 	"orderHeaderId": orderHeaderId,
														// 	"IdMap" : compareMap,
														// 	"license" : component.get("v.license"),
														// 	"isAdmin" : component.get("v.isAdmin"),
														// 	"canRemove" : condition,
														// 	"fromItemsApprovalStatus" : component.get("v.fromItemsApprovalStatus"),
														// 	"inModal" : component.get("v.isDraftModal")
														// }, 
														// function (newContent, status, error)
														// {
														// 	if (status === "SUCCESS") {
														// 		var body = component.get("v.body");
														// 		_utils.info("***new component Success" + status);
														// 		body.push(newContent);
														// 		component.set("v.body", body);
														// 	} else {
														// 		console.log('ERROR: ' + error);
														// 		throw new Error(error);
														// 	}
															
															
														// });
														/*START AV 25_01_2019**********MAIN102*/
														var mapAllLoad= component.get("v.mapAllLoad");
														mapAllLoad[singledoc]=true;
														component.set("v.mapAllLoad", mapAllLoad);
														// //_utils.info('***MAPALLLOAD'+JSON.stringify(component.get("v.mapAllLoad")));
														/*END AV 25_01_2019**********MAIN102*/
													}
													else
													{
														component.set('v.idFromFilenet', idDoc);
														component.set('v.retrieveName', filename);
														component.set('v.isSingle', true);
														/*START AV 25_01_2019**********MAIN102*/
														var mapAllLoad= component.get("v.mapAllLoad");
														mapAllLoad[singledoc]=true;
														component.set("v.mapAllLoad", mapAllLoad);
														// _utils.info('***MAPALLLOAD'+JSON.stringify(component.get("v.mapAllLoad")));
														/*END AV 25_01_2019**********MAIN102*/
													}
												}
										};
										request.send(  );
										
									}
								});
								$A.enqueueAction(action2);
							}catch(err){
								console.log('ON RENDER ERROR: '+err.message);//giovanni spinelli 27/06/2019 change alert with console.log
							}
							
							// action.setParams({
							// 	'merchantId' :  merchantId,
							// 	'salespointsId' : salespointsId,
							// 	'configurationIdOrLogRequest' : configurationIdOrLogRequest,
							// 	'docId' : docId,
							// 	'isLogRequest' : false
							// });
						// 	action.setCallback(this, function(response){
						// 		var state = response.getState();
						// 		if (state === "SUCCESS") 
						// 		{
						// 			//_utils.info(response.getReturnValue());
						// 			var res = response.getReturnValue();
						// 			var filename = res['FILENAME'];
						// 			var idDoc = res['DOCID'];
						// 			var b64 = res['BASE64'];
						// 			//giovanni spinelli 03/04/2019 save docs informations in a map to pass in parent component - start
						// 			var mapValueDocs = component.get('v.mapValueDocs');
						// 			var innerMap = {};
						// 			innerMap['filename'] 	= filename;
						// 			innerMap['b64'] 		= b64;
						// 			mapValueDocs[idDoc] 	= innerMap;
						// 			component.set('v.mapValueDocs',mapValueDocs);
						// 			//giovanni spinelli 03/04/2019 save docs informations in a map to pass in parent component - end
						// 			// //_utils.info('key: '+ key);
						// 			// //_utils.info("Stream: "+nameStream[key]);
						// 			var listFields = component.get("v.listFields");
						// 			var orderHeaderId = component.get("v.orderHeaderId");
						// 			if(isMultiple=="true")
						// 			{
						// 				var canUpload = component.get("v.canUpload");
						// 				var readOnly = component.get("v.readonly");
						// 				var condition = canUpload && !readOnly;
						// 		//		console.log("@@@con: "+condition+ "    canUpload: "+canUpload+'			readonly: '+readOnly);
						// 		//		console.log("@@@inModal: "+component.get("v.isDraftModal"));
						// 				buttonView.classList.add("slds-hide");
						// 				$A.createComponent("c:OB_AttachedDocumentationsDynamic", 
						// 				{
						// 					"Id" : "idDocument",
						// 					"IdFilenet" :  idDoc,
						// 					"inputText" : filename,  
						// 					"listFields" : listFields,
						// 					"documentType" : component.get("v.documentType"),
						// 					"singleDoc" : component.get("v.singleDoc"),
						// 					"multipleMapId": component.get("v.multipleMapId"),
						// 					"orderHeaderId": orderHeaderId,
						// 					"IdMap" : compareMap,
						// 					"license" : component.get("v.license"),
						// 					"isAdmin" : component.get("v.isAdmin"),
						// 					"canRemove" : condition,
						// 					"fromItemsApprovalStatus" : component.get("v.fromItemsApprovalStatus"),
						// 					"inModal" : component.get("v.isDraftModal")
						// 				}, 
						// 				function (cmp)
						// 				{
						// 					//_utils.info("***new component Success");
						// 					var body = component.get("v.body");
						// 					body.push(cmp);
						// 					component.set("v.body", body);
						// 				});
						// 				/*START AV 25_01_2019**********MAIN102*/
						// 				var mapAllLoad= component.get("v.mapAllLoad");
						// 				mapAllLoad[singledoc]=true;
						// 				component.set("v.mapAllLoad", mapAllLoad);
						// 				// //_utils.info('***MAPALLLOAD'+JSON.stringify(component.get("v.mapAllLoad")));
						// 				/*END AV 25_01_2019**********MAIN102*/
						// 			}
						// 			else
						// 			{
						// 				component.set('v.idFromFilenet', idDoc);
						// 				component.set('v.retrieveName', filename);
						// 				component.set('v.isSingle', true);
						// 				/*START AV 25_01_2019**********MAIN102*/
						// 				var mapAllLoad= component.get("v.mapAllLoad");
						// 				mapAllLoad[singledoc]=true;
						// 				component.set("v.mapAllLoad", mapAllLoad);
						// 				// _utils.info('***MAPALLLOAD'+JSON.stringify(component.get("v.mapAllLoad")));
						// 				/*END AV 25_01_2019**********MAIN102*/
						// 			}
								
						// 	}
						// });

						// $A.enqueueAction(action);
						}
						console.log('AFTER FOR');
					}
				}
				else
				{
					// _utils.info("@@@ don't show visualizza");
					component.set('v.showSpinner' ,  false);//giovanni spinelli 27/06/2019  stop spinner
					buttonView.classList.add("slds-hide");
				}
			}
			else
			{
				// _utils.info("@@@ don't show visualizza");
				buttonView.classList.add("slds-hide");
			}
			
		}
	},


	loadDoc : function(component, event, helper){
		_utils.info("*******loadDoc ****************");
		var docIdsMap = component.get("v.compareMap");
		var singledoc = component.get("v.singleDoc");
		var mapMultiple = component.get("v.mapMultiple");
		var isMultiple = mapMultiple[singledoc];
		// var docId= docIdsMap[singledoc][0];
		var fileInput = component.find("inputFile").getElement();
		if('files' in fileInput){
			var file = fileInput.files[0];
			var reader = new FileReader();
			reader.readAsDataURL(file);
			reader.onload=function(){
				_utils.info("****type of result: "+typeof reader.result);
				var strin = reader.result;
				// _utils.info("****result: "+ JSON.stringify(strin));
				var b64pure = strin.split(",")[1];
				var typeDoc = strin.split(",")[0];
				component.set("v.fileName", file.name);
				_utils.info("***fileName: "+file.name);
				_utils.info("***TYPE file: "+typeDoc);
				// _utils.info("***fileB64: "+b64pure);
				if(typeDoc == "data:application/pdf;base64"){    //NEW 2019 01 31 only PDF 
					component.set("v.base64", b64pure);
/*if we want to rollback the controll if the document is *.pdf,
 have to comment if(){} & else{}, and  leave only: "component.set("v.base64", b64pure);" */
				}
				else{
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						title: $A.get("$Label.c.OB_MAINTENANCE_OPERATION_FAILED"),
						message: $A.get("$Label.c.OB_onlyPDF"),
						duration: '5000',
						type: 'error',
						mode: 'dismissible'
					});
					toastEvent.fire();
				}
			}
		}
	},

	/*saveBase64 : function (component, event, helper){
		_utils.info("INSIDE saveBase64");
		var b64 = component.get("v.base64");
		if(b64 != ""){
			helper.saveDoc(component, event, helper);
		}
	},*/


	viewDocument : function(component, event , helper){
		var listFields 			= component.get("v.listFields");
		var configurationId 	= listFields[0];
		var servicePoint 		= listFields[1];
		var merchant			= listFields[2];

		//	START	micol.ferrari 03/12/2018
		var logRequestId = '';
		if (listFields.length>6)
		{
			logRequestId = listFields[6];
			_utils.info("### logRequestId: "+logRequestId);
		}
		//	END		micol.ferrari 03/12/2018

		var docIdsMap = component.get("v.compareMap");
		_utils.info('***docIdsMap: ' + JSON.stringify(docIdsMap));
		var singledoc= component.get("v.singleDoc");
		_utils.info('****singledoc' + singledoc);
		var docId = component.get('v.idFromFilenet');
		_utils.info("merchant: "+merchant+"  servicePoint: "+servicePoint+"  configurationId: "+configurationId+"  ID: "+docId);
		var request = $A.get("e.c:OB_ContinuationRequest");

		//	START	micol.ferrari 03/12/2018
		if (typeof logRequestId !== 'undefined' && logRequestId!=null && logRequestId!='')
		{
			if(servicePoint == 'undefined' || servicePoint=='' || servicePoint==null )
			{
				servicePoint= '';
			}
			_utils.info("INSIDE visualizeDocLoadLogRequest");
			// _utils.info('Params: '+merchant+' || '+ servicePoint+' || '+ logRequestId+' || '+ docId );
			request.setParams(
			{ 
				methodName: "visualizeDocLoadLogRequest",
				methodParams: [merchant, servicePoint, logRequestId, docId],
				callback: function(result)
				{
					_utils.info('****RISULTATO: '+ JSON.stringify(result));
				}
			});
		}
		else
		{
			_utils.info("INSIDE visualizeDocLoad");
			request.setParams(
			{ 
				methodName: "visualizeDocLoad",
				methodParams: [merchant, servicePoint, configurationId, docId],
				callback: function(result)
				{
					_utils.info('****RISULTATO: '+ result);
				}
			});
		}
		//	END		micol.ferrari 03/12/2018
		request.fire();
	},
	/*
	* Author : Giovanni Spinelli
	* Date : 03/06/2019
	* Description : new method to show single doc.
	*/
	viewDocsJS: function (component, event, helper) {

		/*ANDREA MORITTU START 2019.08.21 - CALLING getTokenJWE apex method for document token */
		helper.getTokenJWE_Helper(component, event, helper);
		/*ANDREA MORITTU END 2019.08.21 - CALLING getTokenJWE apex method for document token */
	},
	resetFile : function(component, event, helper)
	{
		//giovanni spinelli 26/06/2019 add try-catch start
		try {
			var input = component.find("inputFile").getElement();
			input.value = null;
			// var myMap= component.get("v.myMap");
			var mapAllLoad = component.get("v.mapAllLoad");
			mapAllLoad[component.get("v.singleDoc")] = false;
			component.set("v.mapAllLoad", mapAllLoad);
			_utils.info("********MAP PRODUCT: " + JSON.stringify(component.get("v.mapAllLoad")));
			var docIdsMap = component.get("v.compareMap");
			var singledoc = component.get("v.singleDoc");
			var docId = docIdsMap[singledoc][0];
			var mapMultiple = component.get("v.mapMultiple");
			var isMultiple = mapMultiple[singledoc];
			//	console.log("@@isMultiple: " +isMultiple);
			if (docId != "" && isMultiple != "true") {
				helper.delete(component, event, helper);
			}
		} catch (err) {
			console.log('error in reset: ' + err.message);
		}
		//giovanni spinelli 26/06/2019 add try-catch end

	},



	newComp : function(component, event, helper){
		_utils.info("***newComp handler change");
		var response= component.get("v.response");
		var multipleMapId= component.get("v.multipleMapId");
		if(response!="")
		{
			var documentId=  response;
			_utils.info("****response", response);
			var isMultiple = component.get("v.isMultiple");
			_utils.info("****isMultiple", isMultiple);
			if(documentId!="" && documentId!=null && documentId!=undefined)
			{
				if(isMultiple=="true")
				{
					_utils.info("***in if response");
					var fileInput = component.find("inputFile").getElement();
					_utils.info("****fileInput: " +fileInput.length);
					if('files' in fileInput)
					{
						_utils.info("***in if file");
						var file= fileInput.files[0];
						var filename = file.name;
						_utils.info("doc: "+filename+"    type: " +typeof filename);
					}
					var orderHeaderId = component.get("v.orderHeaderId");
					var index = component.get("v.index");
					var namedoc = component.get("v.singleDoc");
					var idDocument = namedoc+"_"+index.toString();
					_utils.info("id doc: "+idDocument);
					idDocument = idDocument.replace(/ /g, "_").toLowerCase();
					_utils.info("id___doc: "+idDocument);
					multipleMapId[idDocument] = documentId;
					var listFields = component.get("v.listFields");
					_utils.info("***multipleMapId: "+JSON.stringify(multipleMapId));
					component.set("v.multipleMapId",multipleMapId);
					var docIdsMap = component.get("v.compareMap");
					var canUpload = component.get("v.canUpload");
					var readOnly = component.get("v.readonly");
					var condition = canUpload && !readOnly;
				//	console.log('=====cond: '+ condition);
				//	console.log('=====inModal: '+ component.get("v.isDraftModal"));
					$A.createComponent("c:OB_AttachedDocumentationsDynamic", 
					{
						"Id" : idDocument,
						"IdFilenet" :  documentId,
						"inputText" : filename,  
						"listFields" : listFields,
						"documentType" : component.get("v.documentType"),
						"singleDoc" : component.get("v.singleDoc"),
						"multipleMapId": component.get("v.multipleMapId"),
						"orderHeaderId": orderHeaderId,
						"IdMap" : docIdsMap,
						"license" : component.get("v.license"),
						"isAdmin" : component.get("v.isAdmin"),
						"canRemove" : condition,
						"fromItemsApprovalStatus" : component.get("v.fromItemsApprovalStatus"),
						"inModal" : component.get("v.isDraftModal")
					}, 
					function (cmp)
					{
						_utils.info("***new component Success");
						var body = component.get("v.body");
						var index = component.get("v.index");
						index+=1;
						component.set("v.index", index);
						body.push(cmp);
						component.set("v.body", body);

					});
				}
				else
				{
					_utils.info(" Document isMultiple = false");
				}
			}
		}
	},
	/*
	* Author : Giovanni Spinelli
	* Date : 03/06/2019
	* Description : method to create dynamic component with handler event.
	*/
	newDynamicComponent: function (component, event, helper) {
		var getEvent= component.get('v.fireDynamicComponent');
		if (getEvent == true || getEvent == 'true') {
			var documentId = component.get('v.idDocJS');
			var fileNameJS = component.get("v.fileNameJS");
			var listFields = component.get("v.listFields");
			var compareMap = component.get("v.compareMap");
			var canUpload = component.get("v.canUpload");
			var readOnly = component.get("v.readonly");
			var condition = canUpload && !readOnly;
			var orderHeaderId = component.get("v.orderHeaderId");
			$A.createComponent("c:OB_AttachedDocumentationsDynamic",
				{
					"Id": "id_" + documentId,
					"IdFilenet": documentId,
					"inputText": fileNameJS,
					"listFields": listFields,
					"documentType": component.get("v.documentType"),
					"singleDoc": component.get("v.singleDoc"),
					"multipleMapId": component.get("v.multipleMapId"),
					"orderHeaderId": orderHeaderId,
					"IdMap": compareMap,
					"license": component.get("v.license"),
					"isAdmin": component.get("v.isAdmin"),
					"canRemove": condition,
					"fromItemsApprovalStatus": component.get("v.fromItemsApprovalStatus"),
					"inModal": component.get("v.isDraftModal")
				},
				function (newContent, status, error) {
					if (status === "SUCCESS") {
						var body = component.get("v.body");
						_utils.info("***new component Success" + status);
						body.push(newContent);
						component.set("v.body", body);
					} else {
						console.log('ERROR: ' + error);
						throw new Error(error);
					}


				});
		}

	},
	/*
	* Author : Giovanni Spinelli
	* Date : 20/06/2019
	* Description : new method to load single doc
					control if it is over 8 mb
					control if doc name contains special character
	*/
	loadDocFromJS: function (component, event, helper) {
		try {
			var fileInput = component.find("inputFile").getElement();
			var isMultiple = component.get("v.isMultiple");
			//1. CONTROL SPECIAL CHARACTERS AND  MAX SIZE
			if ('files' in fileInput) {
				var file = fileInput.files[0],
					fileName = file.name;


				//DO NOT INSERT DOCUMENTS OVER 8 MB
				var totalSizeMB = file.size / Math.pow(1024, 2);
				if (totalSizeMB > 8) {
					//DELETE OLD FILE NAME IF IT ISN'T A PDF
					// component.set("v.fileName", '');
					// component.set('v.retrieveName', '');
					component.set('v.showSpinner', false);
					if (isMultiple == "true") {
						var idView = component.get("v.idView");
						var buttonView = document.getElementById(idView);
						buttonView.classList.add("slds-hide");
					}
					/**/

					var messageToast = $A.get("$Label.c.OB_Control_size_file");
					var titleToast = $A.get("$Label.c.OB_MAINTENANCE_OPERATION_FAILED");
					//FIRE TOAST EVENT
					helper.fireToast(component, titleToast, messageToast, 'error');
					return;
				}
				//DO NOT INSERT DOCUMENTS WITH SPECIAL CHARACTERS
				var regex = new RegExp("[&!|”£$%()=?^éè\/{}@#§°ç]", "g");
				if (regex.test(fileName) || fileName.includes('[') || fileName.includes(']')) {
					//DELETE OLD FILE NAME IF IT ISN'T A PDF
					// component.set("v.fileName", '');
					// component.set('v.retrieveName', '');
					component.set('v.showSpinner', false);
					if (isMultiple == "true") {
						var idView = component.get("v.idView");
						var buttonView = document.getElementById(idView);
						buttonView.classList.add("slds-hide");
					}
					/*var idView = component.get("v.idView");
					var buttonView =document.getElementById(idView);
					buttonView.classList.add("slds-hide");*/

					var messageToast = $A.get("$Label.c.OB_Invalid_Character_FileName");
					var titleToast = $A.get("$Label.c.OB_MAINTENANCE_OPERATION_FAILED");
					helper.fireToast(component, titleToast, messageToast, 'error');
					return;
				}
			}
			//2. DEPRECATE PREVIOUS DOCS AFTER SELECT
			try {
				var mapAllLoad = component.get("v.mapAllLoad");
				mapAllLoad[component.get("v.singleDoc")] = false;
				component.set("v.mapAllLoad", mapAllLoad);
				_utils.info("********MAP PRODUCT: " + JSON.stringify(component.get("v.mapAllLoad")));
				var docIdsMap = component.get("v.compareMap");
				var singledoc = component.get("v.singleDoc");
				var docId = docIdsMap[singledoc][0];
				var mapMultiple = component.get("v.mapMultiple");
				var isMultiple = mapMultiple[singledoc];
				//	console.log("@@isMultiple: " +isMultiple);
				if (docId != "" && isMultiple != "true") {
					helper.delete(component, event, helper);
				}
			} catch (err) {
				console.log('error in reset: ' + err.message);
			}
			//3. START METHOD TO LOAD NEW DOCUMENT
			// NEXI-298 Marta Stempien <marta.stempien@accenture.com> 10/09/2019 Start
			let listFields = component.get("v.listFields");
			let	documentName = component.get("v.nameFile");
			let	merchant = listFields[2];
			let	salePoint = listFields[1];
			let	orderId = listFields[0];
			//GET LOG REQUEST ID
			let objectsRequiringCurrentDocumentIds = [];
			if(!$A.util.isEmpty(component.get("v.documentsByLogRequestId")))
			{
                let currentDocumentName = component.get("v.singleDoc");
                let documentsByLogRequestId = component.get("v.documentsByLogRequestId");
                for(let property in documentsByLogRequestId)
                {
                    if(documentsByLogRequestId.hasOwnProperty.call(documentsByLogRequestId, property))
                    {
                        if(documentsByLogRequestId[property].includes(currentDocumentName))
                        {
                            objectsRequiringCurrentDocumentIds.push(property);
                        }
                    }
                }
            }
            if(!$A.util.isEmpty(orderId))
            {
                objectsRequiringCurrentDocumentIds = [];
                objectsRequiringCurrentDocumentIds.push(orderId);
            }

			else if($A.util.isEmpty(objectsRequiringCurrentDocumentIds))
			{
			    if (listFields.length > 6)
			    {
                    logRequestId = listFields[6];
                    _utils.info("### logRequestId: " + logRequestId);
                    objectsRequiringCurrentDocumentIds.push(logRequestId);
                }
            }
            let response;
            let token;
            let url;
            let idToFilenet;
            let action;
            let state;

            for(let objectId of objectsRequiringCurrentDocumentIds)
            {
                action = component.get("c.getTokenJWE");
                idToFilenet = orderId == null ? objectId : orderId;
                console.log('listFields: ', listFields);
                console.log('idToFilenet: ' + idToFilenet);
                component.set('v.disabledSaveDuringLoad', true);	//make disable button until load is fisnished								//fire spinner
                component.set("v.showSaving", true);				//show text saving....
                console.log('DOCS NAME: ' + documentName);
                console.log('PARMAS URL: ' + merchant + ' || ' + salePoint + ' || ' + orderId + ' || ' + idToFilenet);
                action.setParams({ documentName: documentName });
                if($A.util.isEmpty(orderId))
                {
                    action.setParams({ inLogRequestId: objectId });
                }
                action.setCallback(this, function (response)
                {
                    state = response.getState();
                    console.log('state getToken is: ' + state);
                    console.log('response is: ' + JSON.stringify(response.getReturnValue()));
                    response = response.getReturnValue();

                    if (state === "SUCCESS") {
                        component.set('v.showSpinner', true);
                        token = response['jewToken'];
                        //CREATE DIFFERT URL
                        url;
                        if (orderId) {
                            url = response['FEurl'] + '/api/merchants/' + merchant + '/sales-points/' + salePoint + '/orders/' + idToFilenet + '/documents';
                        } else {
                            //CHECK IF THERE IS A SERVICE POINT ID
                            if (salePoint) {
                                url = response['FEurl'] + '/api/merchants/' + merchant + '/sales-points/' + salePoint + '/requests/' + response['logRequestId'] + '/documents';
                            } else {
                                url = response['FEurl'] + '/api/merchants/' + merchant + '/requests/' + response['logRequestId'] + '/documents';
                            }
                        }
                        console.log('TOKEN: ' + token);
                        console.log('FE URL: ' + url);
                        helper.callBackJWE(component, token, url);
                    }
                    //Start antonio.vatrano 09/09/2019 wn-385
                    else if (state === "ERROR")
                    {
                        let messageToast = $A.get("$Label.c.OB_ServiceUnavailable");
                        let titleToast = $A.get("$Label.c.OB_MAINTENANCE_OPERATION_FAILED");
                        helper.fireToast(component, titleToast, messageToast,'Error');
                    }
                    //End antonio.vatrano 09/09/2019 wn-385
                });
                $A.enqueueAction(action);
            }
            // NEXI-298 Marta Stempien <marta.stempien@accenture.com> 10/09/2019 Stop
		} catch (err) {
			console.log('error loadDocFromJS: ' + err.message);
		}
	},

	closemodal : function(component, event, helper) {
		component.set('v.showdocumentsMODAL', false);
	}
})