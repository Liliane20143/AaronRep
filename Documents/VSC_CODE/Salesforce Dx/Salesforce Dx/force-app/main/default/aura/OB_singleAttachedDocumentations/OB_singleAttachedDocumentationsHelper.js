({
	delete : function(component, event, helper){
		_utils.info("delete ShowProductDocument")
		var listFields 			= component.get("v.listFields");
		var configurationId 	= listFields[0];
		var servicePointId 		= listFields[1];
		var merchantId 			= listFields[2];
		if( typeof(servicePointId) == 'undefined' || servicePointId=='' || servicePointId==null )
		{
			servicePointId= '';
		}
		//	START	micol.ferrari 03/12/2018
		var logRequestId = '';
		if (listFields.length>6)
		{
			logRequestId = listFields[6];
			_utils.info("### logRequestId: "+logRequestId);
		}
		//	END		micol.ferrari 03/12/2018
		var docIdsMap = component.get("v.compareMap");
		var singledoc = component.get("v.singleDoc"); 
		// var documentId = docIdsMap[singledoc][0];
		var listId 				=  docIdsMap[singledoc];
		if(listId.length>0){
			var documentId 			=  listId[0];
			var isNewUpload 		= 'true'; 	
		}
		else{
			_utils.info('######list empty');
			var documentId 			=  '';
			var isNewUpload 		= 'false';
		}
		_utils.info('****ID: '+documentId);
		var request = $A.get("e.c:OB_ContinuationRequest");

			//	START	micol.ferrari 03/12/2018
			if (typeof logRequestId !== 'undefined' && logRequestId!=null && logRequestId!='')
			{
				request.setParams({ 
					methodName: "filenetUpload",
					methodParams: [merchantId, servicePointId,logRequestId,'',"",isNewUpload,documentId,''],
					callback: function(result)
					{
						_utils.info('RISULTATO deprecate : '+ result);
						component.set("v.documentId" ,[]);
						var docIdsMap = component.get("v.compareMap");
						var singledoc = component.get("v.singleDoc");
						docIdsMap[singledoc]=[];
						component.set("v.compareMap", docIdsMap);
						for (var key in docIdsMap)
						{
							_utils.info("key: "+key+"	value: "+docIdsMap[key]);
						}
						component.set("v.base64", "");
					}
				});
			}
			else
			{
				request.setParams({ 
					methodName: "filenetUpload",
					methodParams: [merchantId, servicePointId,configurationId,'',"",isNewUpload,documentId,''],
					callback: function(result)
					{
						_utils.info('RISULTATO deprecate : '+ result);
						component.set("v.documentId" ,'');
						var docIdsMap = component.get("v.compareMap");
						var singledoc = component.get("v.singleDoc");
						docIdsMap[singledoc]=[];
						component.set("v.compareMap", docIdsMap);
						// for (var key in docIdsMap)
						// {
						// 	_utils.info("key: "+key+"	value: "+docIdsMap[key]);
						// }
						component.set("v.base64", "");
					}
				});
			}
			//	END		micol.ferrari 03/12/2018
			if(documentId != ''){
				_utils.info('°°°°request fire°°°°');
				request.fire();
			}

		// }

	},


	saveDoc : function (component, file, helper) {
		_utils.info("INSIDE Savedoc");
		// var merchantId = '0019E00000pZPVBQA4';
		// var servicePointId = 'a199E000000pHf7QAE';
		// var configurationId = 'a0w9E000002q4cjQAA';
		// var configurationItem = 'a0y9E000003WzoBQAS';
		// String myKey = orderId+':'+servicePointId+':'+accountId+':'+mcc+':'+ateco+':'+legalForm+':'+isCrowdfunding;
		component.set("v.response", "");
		var listFields 			= component.get("v.listFields");
		var configurationId 	= listFields[0];
		var servicePointId 		= listFields[1];
		var merchantId 			= listFields[2];

		//	START	micol.ferrari 03/12/2018
		var logRequestId = '';
		if (listFields.length>6)
		{
			logRequestId = listFields[6];
			_utils.info("### logRequestId: "+logRequestId);
		}
		//	END		micol.ferrari 03/12/2018
		var singledoc 			= component.get("v.singleDoc");
		var utilityDocType 		= component.get("v.documentType")[singledoc];
		var documentType 		= utilityDocType.split(':')[0];
		var isMultiple 			= utilityDocType.split(':')[1];
		component.set("v.isMultiple", isMultiple);
		
		var base64 				= component.get("v.base64");
		var fileName 			= component.get("v.fileName");
		var docIdsMap 			= component.get("v.compareMap");
		var listId 				=  docIdsMap[singledoc];
		_utils.info("MAYLISTID"+JSON.stringify(listId));
		_utils.info("MAYLISTID"+listId);
		
		_utils.info("##filename "+fileName);
		_utils.info("##singledoc "+singledoc);
		_utils.info("##documentType "+documentType);
		_utils.info("##isMultiple "+isMultiple);
		component.set("v.isMultiple", isMultiple);
		if(listId.length>0){
			if(isMultiple== "true"){
				var documentId 			=  '';
				var isNewUpload 		= 'false';
			}
			else{
				
				var documentId 			=  docIdsMap[singledoc][0];
				var isNewUpload 		= 'true'; 	
			}
		}
		else{
			var documentId 			=  '';
			var isNewUpload 		= 'false';
		}
		_utils.info("****isNewUpload: "+isNewUpload);
		
		_utils.info("***Savedoc fields "+configurationId+" "+servicePointId+" "+merchantId+" "+documentId);
		component.set("v.isMultiple", isMultiple);

		var request 			= $A.get("e.c:OB_ContinuationRequest");

		//	START	micol.ferrari 03/12/2018
		if (typeof logRequestId != undefined && logRequestId!=null && logRequestId!='')
		{
			request.setParams({ 
				methodName: "filenetUpload",
				methodParams: [merchantId, servicePointId,logRequestId,documentType,base64,isNewUpload,documentId,fileName],
				callback: function(result) {
					var myResult = result.replace("{", "");
					myResult = myResult.replace("}", "");
					_utils.info("****result ID: "+ myResult);
					var documentId= myResult;
					if(documentId!='')
					{
						component.set("v.documentId" ,'');
						component.set("v.response",myResult);
						_utils.info("****result ID != ''***** ");
						var mapAllLoad= component.get("v.mapAllLoad");

						var isMultiple = component.get("v.isMultiple");
						if(isMultiple != "true")
						{
							var idView = component.get("v.idView");
							var buttonView =document.getElementById(idView);
							buttonView.classList.remove("slds-hide");
							var name = component.get("v.fileName");
							component.set('v.retrieveName', name);
							component.set('v.isSingle', true);
							component.set('v.idFromFilenet',documentId );
							// Start AV 22022019
							var singledoc = component.get("v.singleDoc");
							var mapAllLoad= component.get("v.mapAllLoad");
							mapAllLoad[singledoc]=true;
							component.set("v.mapAllLoad", mapAllLoad);
						}
						var singledoc = component.get("v.singleDoc");
						var listId = docIdsMap[singledoc];
						listId.push(documentId);
						docIdsMap[singledoc]=listId;
						component.set("v.compareMap",docIdsMap);
						_utils.info("********MAP docIdsMap: " + JSON.stringify(component.get("v.compareMap")));
						mapAllLoad[singledoc]=true;
						component.set("v.mapAllLoad", mapAllLoad);
						// _utils.info("********MAP PRODUCT: " + JSON.stringify(component.get("v.mapAllLoad")));
					}
					else
					{
						component.set("v.response",myResult);
						var mapAllLoad= component.get("v.mapAllLoad");
						var isMultiple = component.get("v.isMultiple");
						if(isMultiple=="true")
						{
							// component.set("v.doneRender", false);

						}
						var singledoc = component.get("v.singleDoc");
						mapAllLoad[singledoc]=false; //antonio.vatrano r1f2-128 14/05/2019
						component.set("v.mapAllLoad", mapAllLoad);
					}
				}
			});
			request.fire();
		}
		else
		{
			request.setParams({ 
				methodName: "filenetUpload",
				methodParams: [merchantId, servicePointId,configurationId,documentType,base64,isNewUpload,documentId,fileName],
				callback: function(result) {
					var myResult = result.replace("{", "");
					myResult = myResult.replace("}", "");
					_utils.info("****result ID: "+ myResult);
					var documentId= myResult;
					if(documentId!='')
					{
						component.set("v.documentId" ,'');
						component.set("v.response",myResult);
						_utils.info("****result ID != ''***** ");
						var myMap= component.get("v.myMap");

						var isMultiple = component.get("v.isMultiple");
						if(isMultiple != "true")
						{
							var idView = component.get("v.idView");
							var buttonView =document.getElementById(idView);
							buttonView.classList.remove("slds-hide");
							var name = component.get("v.fileName");
							component.set('v.retrieveName', name);
							component.set('v.isSingle', true);
							component.set('v.idFromFilenet',documentId );
						}
						var singledoc = component.get("v.singleDoc");
						var listId = docIdsMap[singledoc];
						listId.push(documentId);
						docIdsMap[singledoc]=listId;
						component.set("v.compareMap",docIdsMap);
						// _utils.info("********MAP docIdsMap: " + JSON.stringify(component.get("v.mapDocumentId")));
						var mapAllLoad= component.get("v.mapAllLoad");
						mapAllLoad[singledoc]=true;
						component.set("v.mapAllLoad", mapAllLoad);

						// _utils.info("********MAP PRODUCT: " + JSON.stringify(component.get("v.myMap")));
					}
					else
					{
						component.set("v.response",myResult);
						var singledoc = component.get("v.singleDoc");
						var isMultiple = component.get("v.isMultiple");
						if(isMultiple=="true")
						{
							// component.set("v.doneRender", false);

						}
						var mapAllLoad= component.get("v.mapAllLoad");
						mapAllLoad[singledoc]=false; //antonio.vatrano r1f2-128 14/05/2019
						component.set("v.mapAllLoad", mapAllLoad);
					}
				}
			});
			request.fire();
		}
		//	END		micol.ferrari 03/12/2018

	},
	/*
	* Author : Giovanni Spinelli
	* Date : 20/06/2019
	* Description :send request
	*/
	callBackJWE: function (component, jweToken, url, helper) {
		try {
			var singleDoc = component.get("v.singleDoc");
			var documentIdMap = component.get("v.documentIdMap");
			var utilityDocType = component.get("v.documentType")[singleDoc];
			var isMultiple = utilityDocType.split(':')[1];
			var tmpbase64  = '';
			component.set("v.isMultiple", isMultiple);
			var request = new XMLHttpRequest();
			request.open("POST", url, true);
			request.setRequestHeader("Content-Type", "application/json");
			request.setRequestHeader("token", jweToken);

			request.onreadystatechange = function () {
				//request finished and response is ready and status is OK
				if (request.readyState === 4 && request.status === 200) {
					var json = JSON.parse(request.responseText);
					component.set("v.response", json);
					console.log('success json:', json);
					var documentId = json['documentId'];
					component.set('v.idDocJS'		, documentId);//store file name
					component.set('v.fileNameJS' 	, component.get('v.retrieveName'));
					console.log('DOCUMENT ID: ' + documentId);
					var myMap = component.get("v.mapAllLoad");
					var isMultiple = component.get("v.isMultiple");
					component.set('v.showSpinner', false);
					if (isMultiple == "true") {
						component.set("v.toSave", false);
						component.set("v.toUpload", true);
						component.set("v.nameFile", '');
						component.set('v.showIcon', false);
						component.set('v.fireDynamicComponent' , true);
						component.set('v.fireDynamicComponent' , false);
						// hide spinner - this. doesn't work here
						
						var idView = component.get("v.idView");
						var buttonView =document.getElementById(idView);
						buttonView.classList.add("slds-hide");
					} else {
						try {
							component.set("v.toSave", false);
							component.set("v.toModify", true);
							component.set('v.isSingle', true);
							//var listID = documentIdMap[singleDoc];
							//listID.push(documentId);
							//documentIdMap[singleDoc] = listID;
							component.set('v.documentIdMap', documentIdMap);
							console.log('documentIdMap: ' + JSON.stringify(documentIdMap));
							component.set('v.idFromFilenet',documentId );//giovanni spinelli
							var mapValueDocs = component.get('v.mapValueDocs');
							console.log('mapValueDocs BEFORE: ' + JSON.stringify(mapValueDocs));
							var innerMap = {};
							innerMap['filename'] 	= component.get('v.retrieveName');
							//innerMap['b64'] 		= component.get("v.base64");
							innerMap['b64']			= tmpbase64;
							component.set('v.base64' , tmpbase64);
							console.log('BASE64 RESPONSE SUCCESSS: ' + component.get("v.base64"));
							var idDoc =documentId ;
							mapValueDocs[idDoc] 	= innerMap;
							
							console.log('mapValueDocs after: ' + JSON.stringify(mapValueDocs))
							component.set('v.mapValueDocs',mapValueDocs);
							for (var name in documentIdMap) {
								if (documentIdMap[name]) {
									var ids = documentIdMap[name];
									// component.set('v.objectDataMap.documentSaved.' + name, ids);
									// console.log('@@@ document saved; ' + JSON.stringify(component.get('v.objectDataMap.documentSaved')));
								}
							}

						} catch (err) {
							console.log('ERROR IN STORE ID SINGLE ATT: ' + err.message);
						}

					}
					component.set('v.disabledSaveDuringLoad', false);	//make enabled button until load is fisnished
					component.set("v.showSaving", false);			   	//show text saving....
					myMap[singleDoc] = true; 							//caricato = true altrimenti false . single doc è il nome del documento
					component.set("v.mapAllLoad", myMap);				//map used to check if there are all docs
					console.log("********MAP PRODUCT: " + JSON.stringify(component.get("v.mapAllLoad")));
					// // hide spinner - this. doesn't work here
					// component.set('v.showSpinner', false);
					// var idView = component.get("v.idView");
					// var buttonView =document.getElementById(idView);
					// buttonView.classList.add("slds-hide");
					
					// show flag;- this. doesn't work here
					if (isMultiple != "true") {
						var flag = component.find("statusIcon");
						$A.util.addClass(flag, 'slds-show');
						$A.util.removeClass(flag, 'slds-hide');
					}
					console.log('after this.');
				}
				//request finished and response is ready and status is KO
				else if (request.readyState === 4 && request.status !== 200) {
					var json = JSON.parse(request.responseText);
					console.log('json in error:', json);
					component.set('v.disabledSaveDuringLoad', false);//make enabled button until load is fisnished
					component.set("v.showSaving", false);			   //show text saving....
					//component.set("v.response", json);
					var myMap = component.get("v.mapAllLoad");
					var isMultiple = component.get("v.isMultiple");
					if (isMultiple == "true") {
						component.set("v.toUpload", true);
						component.set("v.toSave", false);

					} else {
						component.set("v.toSave", false);
					}
					component.set("v.showSaving", false);
					myMap[singleDoc] = false;
					component.set("v.mapAllLoad", myMap);
					component.set("v.toUpload", true);
					//hide spin - this. doesn't work here
					component.set('v.showSpinner', false);
					var idView = component.get("v.idView");
					var buttonView =document.getElementById(idView);
					buttonView.classList.add("slds-hide");
					//show error - this. doesn't work here
					var error = component.find("errorIcon");
					$A.util.addClass(error, 'slds-show');
					$A.util.removeClass(error, 'slds-hide');
					//show error message - this. doesn't work here

					var errorMessage = component.find("loadErrorMessage");
					$A.util.addClass(errorMessage, 'slds-show');
					$A.util.removeClass(errorMessage, 'slds-hide');

				}
				else {
					console.log('error:' + JSON.stringify(request));
				}

			};
			//var body = this.generateBody(component, event);
			//GENERATE BODY FOR REQUEST FROM SELECTED PDF
			
			var singleDoc 		= component.get("v.singleDoc"),
				utilityDocType 	= component.get("v.documentType")[singleDoc],
				documentType 	= utilityDocType.split(':')[0],
				fileInput 		= component.find("inputFile").getElement(),
				body			='';
			if('files' in fileInput)
			{
				var file 			= fileInput.files[0],
					fileName 		= file.name;
					
				
				//DO NOT INSERT DOCUMENTS OVER 8 MB
				/*var totalSizeMB = file.size / Math.pow(1024, 2);
				if (totalSizeMB > 8) {
					//DELETE OLD FILE NAME IF IT ISN'T A PDF
					// component.set("v.fileName", '');
					// component.set('v.retrieveName', '');
					component.set('v.showSpinner', false);
					var idView = component.get("v.idView");
					var buttonView =document.getElementById(idView);
					buttonView.classList.add("slds-hide");
					
					var messageToast = $A.get("$Label.c.OB_Control_size_file");
					var titleToast = $A.get("$Label.c.OB_MAINTENANCE_OPERATION_FAILED");
					//FIRE TOAST EVENT
					this.fireToast(component,titleToast,messageToast, 'error');
					return;
				}
				//DO NOT INSERT DOCUMENTS WITH SPECIAL CHARACTERS
				var regex = new RegExp("[&!|”£$%()=?^éè\/{}@#§°ç]", "g");
				if (regex.test(fileName) || fileName.includes('[') || fileName.includes(']')) {
					//DELETE OLD FILE NAME IF IT ISN'T A PDF
					// component.set("v.fileName", '');
					// component.set('v.retrieveName', '');
					component.set('v.showSpinner', false);
					var idView = component.get("v.idView");
					var buttonView =document.getElementById(idView);
					buttonView.classList.add("slds-hide");
					
					var messageToast = $A.get("$Label.c.OB_Invalid_Character_FileName");
					var titleToast = $A.get("$Label.c.OB_MAINTENANCE_OPERATION_FAILED");
					this.fireToast(component,titleToast,messageToast, 'error');
					return;
				}*/
				//CORRECT DOCUMENT
				var reader 			= new FileReader();
				reader.readAsDataURL(file);
				reader.onload=function()
				{
					var strin = reader.result;
					var b64pure = strin.split(",")[1];
					var typeDoc = strin.split(",")[0];
					console.log('typeDoc: ' + typeDoc);
					if(typeDoc == "data:application/pdf;base64")
					{    
						component.set("v.fileName", file.name);
						component.set('v.retrieveName', file.name);
						console.log("***fileName: "+file.name);
						console.log("***TYPE file: "+typeDoc); 
						component.set("v.base64", b64pure);
						tmpbase64 = b64pure;
						console.log('base 64: ' + b64pure);
						body = '{"documentType":"' + documentType + '","templateName":"","templateVersion":"","documentStream":"' + b64pure + '","documentStatus":"ACTIVE","posType":"","Campi_Setup_Contratto":"","documentFileName":"' + fileName + '","callbackUrl":""}';
						console.log('body: ' , body);
						request.send(body);
					}
					else {
						//DELETE OLD FILE NAME IF IT ISN'T A PDF
						component.set("v.fileName", '');
						component.set('v.retrieveName', '');
						component.set('v.showSpinner', false);
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							title: $A.get("$Label.c.OB_MAINTENANCE_OPERATION_FAILED"),
							message: $A.get("$Label.c.OB_onlyPDF"),
							duration: '5000',
							type: 'error',
							mode: 'dismissible'
						});
						toastEvent.fire();
						if (isMultiple == "true") {
							var idView = component.get("v.idView");
							var buttonView = document.getElementById(idView);
							buttonView.classList.add("slds-hide");
						}
						
					}
				}
			}
			
			

		}
		catch (err) {
			console.log('error message call back JWE 2: ' + err.message);
		}
	},
	/*
	* Author : Giovanni Spinelli
	* Date : 21/06/2019
	* Description : fire toast method 
	*/
	fireToast: function (component,title, message, type) {

		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: message,
			duration: '5000',
			type: type,
			mode: 'dismissible'
		});
		toastEvent.fire();
		/*var idView = component.get("v.idView");
		var buttonView =document.getElementById(idView);
		buttonView.classList.add("slds-hide");*/
	},
	/*
	* Author : Giovanni Spinelli
	* Date : 20/06/2019
	* Description :create body
	*/
	getDocsfromJS : function (component , docId , merchantId ,salespointsId ,configurationIdOrLogRequest , isLogRequest,isMultiple){
		//alert('in get document');
		console.log('isLogRequest? ' + isLogRequest);
		try {
			//var docId = listId[i];
			var url;
			var action2 = component.get("c.getTokenJWE");
			action2.setParams({ documentName: docId });
			action2.setCallback(this, function (response) {
				var state = response.getState();
				console.log('state getToken is: ' + state);
				console.log('response is: ' + JSON.stringify(response.getReturnValue()));
				var response = response.getReturnValue();

				if (state === "SUCCESS") {
					var idView = component.get("v.idView");
					var buttonView = document.getElementById(idView);
					var token = response['jewToken'];
					var documentId = response['documentId'];
					console.log('document id from server: ' + documentId);
					if (isLogRequest) {
						console.log('IS LOG REQUEST');
						if (salespointsId) {
							//CORRECT END POINT (BY EROS ORLANDO)--> url = response['FEurl'] + '/api/merchants/' + merchantId + '/sales-points/' + salespointsId + '/requests/' + configurationIdOrLogRequest + '/documents/' + documentId;
							//NOT CORRECT ENDPOINT -->
							url = response['FEurl'] + '/api/merchants/' + merchantId + '/sales-points/' + configurationIdOrLogRequest  + '/documents/' + documentId;
						} else {
							//CORRECT END POINT (BY EROS ORLANDO)-->url = response['FEurl'] + '/api/merchants/' + merchantId + '/requests/' + configurationIdOrLogRequest + '/documents/' + documentId;
							url = response['FEurl'] + '/api/merchants/' + merchantId + '/sales-points/' + configurationIdOrLogRequest + '/documents/' + documentId;

						}

					} else if (!isLogRequest) {
						console.log('ISNT LOG REQUEST');
						url = response['FEurl'] + '/api/merchants/' + merchantId + '/sales-points/' + salespointsId + '/orders/' + configurationIdOrLogRequest + '/documents/' + documentId;
					}

					
					console.log('TOKEN: ' + token);
					console.log('FE URL: ' + url);
					
					var request = new XMLHttpRequest();
					request.open("GET", url, true);
					request.setRequestHeader("Content-Type", "application/json");
					request.setRequestHeader("token", token);
					request.onreadystatechange = function () {
						if (request.readyState === 4 && request.status === 200) {
							component.set('v.showSpinner', false);
							var singledoc=component.get("v.singleDoc");//giovanni spinelli 04/07/2019 - add missing var
							// buttonView.classList.remove("slds-hide");
							// buttonView.classList.add("slds-show");
							var res = JSON.parse(request.responseText);
							console.log('RESPONSE HTTP: ' + JSON.stringify(res));
							var filename = res['filename'];
							var idDoc = documentId;
							console.log('ID DOCS IN IF: ' + idDoc);
							// var idDoc = res['DOCID'];
							var b64 = res['documentStream'];
							console.log('BASE64: ' + b64);
							var mapValueDocs = component.get('v.mapValueDocs');
							var innerMap = {};
							innerMap['filename'] = filename;
							innerMap['b64'] = b64;
							mapValueDocs[idDoc] = innerMap;
							component.set('v.mapValueDocs', mapValueDocs);
							component.set('v.idDocJS', idDoc);//store file name
							component.set('v.fileNameJS', filename);
							console.log('### file id: ' + component.get('v.idDocJS'));
							var listFields = component.get("v.listFields");
							var orderHeaderId = component.get("v.orderHeaderId");
							if (isMultiple == "true") {
								console.log('multiple map: ', component.get("v.multipleMapId"));
								console.log('### id contratto firmato: ' + component.get('v.idDocJS'));
								var canUpload = component.get("v.canUpload");
								var readOnly = component.get("v.readonly");
								var condition = canUpload && !readOnly;
								var idView = component.get("v.idView");
								var buttonView = document.getElementById(idView);
								buttonView.classList.add("slds-hide");
								console.log('file name: ' + filename);
								console.log('listFields: ' + listFields);
								component.set('v.fireDynamicComponent', true);
								component.set('v.fireDynamicComponent', false);
								/*START AV 25_01_2019**********MAIN102*/
								var mapAllLoad = component.get("v.mapAllLoad");
								mapAllLoad[singledoc] = true;
								component.set("v.mapAllLoad", mapAllLoad);
								/*END AV 25_01_2019**********MAIN102*/
							}
							else {
								component.set('v.idFromFilenet', idDoc);
								component.set('v.retrieveName', filename);
								component.set('v.isSingle', true);
								console.log('NAME FILE FILENET: ' +component.get('v.retrieveName'));
								/*START AV 25_01_2019**********MAIN102*/
								var mapAllLoad = component.get("v.mapAllLoad");
								mapAllLoad[singledoc] = true;
								component.set("v.mapAllLoad", mapAllLoad);
								/*END AV 25_01_2019**********MAIN102*/
							}
						} else if (request.readyState === 4 && request.status !== 200) {
							component.set('v.showSpinner', false);
							var res = JSON.parse(request.responseText);
							console.log('RESPONSE HTTP: ' + JSON.stringify(res));
						}
					};
					request.send();

				}
			});
			$A.enqueueAction(action2);
		} catch (err) {
			console.log('ON RENDER ERROR: ' + err.message);
		}
	},
	/*
	* Author : Giovanni Spinelli
	* Date : 20/06/2019
	* Description :create body
	*/
	/*generateBody: function (component, event) {
		var singleDoc 		= component.get("v.singleDoc"),
			utilityDocType 	= component.get("v.documentType")[singleDoc],
			documentType 	= utilityDocType.split(':')[0],
			fileselect 		= component.get("v.fileselect"),
			fileInput 		= component.find("inputFile").getElement(),
			body			='';
			
			
			if('files' in fileInput)
			{
				var file 			= fileInput.files[0],
					fileName 		=  file.name;;
				var reader 			= new FileReader();
				reader.readAsDataURL(file);
				reader.onload=function()
				{
					var strin = reader.result;
					var b64pure = strin.split(",")[1];
					var typeDoc = strin.split(",")[0];
					component.set("v.fileName", file.name);
					_utils.info("***fileName: "+file.name);
					_utils.info("***TYPE file: "+typeDoc);
					if(typeDoc == "data:application/pdf;base64")
					{     
						component.set("v.base64", b64pure);
						body = '{"documentType":"' + documentType + '","templateName":"","templateVersion":"","documentStream":"' + b64pure + '","documentStatus":"ACTIVE","posType":"","Campi_Setup_Contratto":"","documentFileName":"' + fileName + '","callbackUrl":""}';
						return body;
					}
					else
					{
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
		
	}*/

	/*
	*	Author		:		Morittu Andrea
	*	Date		:		21.08.2019
	*	Description	:		calling getTokenJWE method for document token
	*/

	getTokenJWE_Helper : function(component, event, helper) {

		try {
			var idDocJS = component.get('v.idDocJS');

			var documentName = '';
			var action = component.get("c.getTokenJWE");
			action.setParams({ documentName : idDocJS });

			action.setCallback(this, function(response) {
				var state = response.getState();
				if (state === "SUCCESS") {

					var response = response.getReturnValue();
					var token = response['jewToken'];
					//CREATE DIFFERT URL 
					var url;
					var listFields = component.get("v.listFields");
					var orderId = listFields[0];
					var salePoint = listFields[1];
					var merchant = listFields[2];
					var idToFilenet;
					var token = response['jewToken'];
					var docIdsMap = component.get("v.compareMap");
					var singledoc = component.get("v.singleDoc");
					var docId = docIdsMap[singledoc][0];
					/*History: START 26-Aug-2019 - Fix on Document URL (in production org, salePoint and OrderId are fundamental) */
					url = response['FEurl'] + '/api/merchants/'+merchant+'/sales-points/'+salePoint+'/orders/'+orderId+'/documents/'+docId;
					/*History: END 26-Aug-2019 - Fix on Document URL (in production org, salePoint and OrderId are fundamental) */
					window.open('/apex/OpenDocumentsPage?params='+token+'?'+url);
				}
				else if (state === "INCOMPLETE") {
					
				}
				else if (state === "ERROR") {
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							console.log("Error message: " + 
									errors[0].message);
						}
					} else {
						console.log("Unknown error");
					}
					let title 	= $A.get("$Label.c.OB_MAINTENANCE_TOASTERROR");
					let message = $A.get("$Label.c.OB_ServiceUnavailable");
					let type = 'error';
					helper.showToast(component, event, helper, title, message, type);
				}
			});
			$A.enqueueAction(action);
		} catch(exc) {
			console.log('An error has occured : ' + exc.message);
		}
	},

	/*
	*	Author		:	Morittu Andrea		
	*	Date		:	2019.08.21
	*	Description	:	Function to create dynamically a toast mesage
	*/
	showToast: function (component, event, helper, title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },
})