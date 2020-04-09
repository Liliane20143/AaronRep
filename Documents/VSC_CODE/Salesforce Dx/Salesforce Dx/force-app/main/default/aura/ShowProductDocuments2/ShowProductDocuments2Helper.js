({

	showSpin : function (component){
		//giovanni spinelli 04/06/2019 remove addclass/removeclass
		component.set('v.showSpinner' , true);
	},

	hideSpin : function (component){
		//giovanni spinelli 04/06/2019 remove addclass/removeclass
		component.set('v.showSpinner' , false);
	},

	showFlag : function (component){
		var flag  = component.find("statusIcon");
		$A.util.addClass(flag,'slds-show');
		$A.util.removeClass(flag,'slds-hide');

	},

	hideFlag : function (component){
		var flag  = component.find("statusIcon");
		$A.util.removeClass(flag,'slds-show');
		$A.util.addClass(flag,'slds-hide');
	},

	delete : function(component, event, helper){
		console.log("delete ShowProductDocument")
		var merchantId = component.get("v.objectDataMap.merchant.Id");
		var servicePointId = component.get("v.objectDataMap.pv.Id");
		var orderItemId = component.get("v.objectDataMap.Configuration.Id");

		// var servicePointId='a199E000000G5HnQAK'; 
		// var orderItemId = 'a0y9E000000FYitQAG';
		// var merchantId = "0019E00000mIK0tQAG";
		
		
		var base64 = component.get("v.fileselect");
		var documentId = component.get("v.documentId");
		var documentIdMap = component.get("v.documentIdMap");
		console.log('documentId:'+documentIdMap[component.get("v.singleDoc")]);
		// var isNewUpload = documentId=='' ? true : false; 
		var singleDoc = component.get("v.singleDoc");
        var documentType = component.get("v.documentType")[singleDoc];
        console.log('documentType'+documentType);
        var response;
        var request = $A.get("e.c:OB_ContinuationRequest");
        request.setParams({ 
        	methodName: "filenetUpload",
        	methodParams: [merchantId, servicePointId, orderItemId,documentType,base64,"true",documentIdMap[component.get("v.singleDoc")][0],''],
        	callback: function(result) {
				console.log('RISULTATO: '+ result);
				var myMap= component.get("v.myMap");
				myMap[singleDoc]=false;
				component.set("v.myMap", myMap);
        		documentIdMap[component.get("v.singleDoc")]=[];//giovanni spinelli change key
        		component.set("v.documentIdMap" ,documentIdMap);
        	}
        });
        request.fire();
	},
	
	// Doris D. 12/04/2019 ....START//
	ToastFunction: function(messageToast, titleToast,type){
		
		var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: titleToast,
					message:messageToast,
					duration: '5000',
					type: type,
					mode: 'dismissible'
				});
				toastEvent.fire();
	},

	// Doris D. 12/04/2019 ....END//
	/*
	* Author : Giovanni Spinelli
	* Date : 16/05/2019
	* Description :send request
	*/
	callBackJWE: function (component, jweToken, url, helper) {
		//alert(jweToken);
		try {
			var singleDoc = component.get("v.singleDoc");
			var documentIdMap = component.get("v.documentIdMap");
			var utilityDocType = component.get("v.documentType")[singleDoc];
			var isMultiple = utilityDocType.split(':')[1];
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
					console.log('response OK:', json);
					var documentId = json['documentId'];
					console.log('DOCUMENT ID: ' + documentId);
					var myMap = component.get("v.myMap");
					var isMultiple = component.get("v.isMultiple");
					if (isMultiple == "true") {
						component.set("v.toSave", false);
						component.set("v.toUpload", true);
						component.set("v.nameFile", '');
						component.set('v.showIcon', false);
					} else {
						try {
							component.set("v.toSave", false);
							component.set("v.toUpload", false);//hide button 'carica'
							component.set("v.toModify", true);
							var listID = documentIdMap[singleDoc];
							listID.push(documentId);
							documentIdMap[singleDoc] = listID;
							component.set('v.documentIdMap', documentIdMap);
							console.log('documentIdMap: ' + JSON.stringify(documentIdMap));
							//START gianluigi.virga 25/09/2019  - commented logic
							// for (var name in documentIdMap) {
							// 	if (documentIdMap[name]) {
							// 		var ids = documentIdMap[name];
							// 		component.set('v.objectDataMap.documentSaved.' + name, ids);
							// 		console.log('@@@ document saved; ' + JSON.stringify(component.get('v.objectDataMap.documentSaved')));
							// 	}
							// }
							//END gianluigi.virga 25/09/2019
						} catch (err) {
							alert('ERROR IN STORE ID: ' + err.message);
						}

					}
					component.set('v.disabledSaveDuringLoad', false);//make enabled button until load is fisnished
					//giovanni spinelli start add class disabled
					var button = component.find('upLoad');
					$A.util.addClass(button, 'LoadButton');
					$A.util.removeClass(button, 'LoadButtonDisabled');
					//giovanni spinelli end add class disabled
					component.set("v.showSaving", false);			   //show text saving....
					myMap[singleDoc] = true; 							   //caricato = true altrimenti false . single doc è il nome del documento
					component.set("v.myMap", myMap);
					console.log("********MAP PRODUCT: " + JSON.stringify(component.get("v.myMap")));
					// hide spinner - this. doesn't work here
					component.set('v.showSpinner', false);
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
					//giovanni spinelli start add class disabled
					var button = component.find('upLoad');
					$A.util.addClass(button, 'LoadButton');
					$A.util.removeClass(button, 'LoadButtonDisabled');
					//giovanni spinelli start add class disabled
					component.set("v.showSaving", false);			   //show text saving....
					//component.set("v.response", json);
					var myMap = component.get("v.myMap");
					var isMultiple = component.get("v.isMultiple");
					if (isMultiple == "true") {
						component.set("v.toUpload", true);
						component.set("v.toSave", false);

					} else {
						component.set("v.toSave", false);
					}
					component.set("v.showSaving", false);
					myMap[singleDoc] = false;
					component.set("v.myMap", myMap);
					component.set("v.toUpload", true);
					//hide spin - this. doesn't work here
					component.set('v.showSpinner', false);
					component.set("v.showError", true); // francesca.ribezzi 06/12/19 - perf-17 - showing error icon and message


				}
				else {
					console.log('error:' + JSON.stringify(request));
				}

			};
			var body = this.generateBody(component, event);
			console.log('BODY JS: ', body);
			request.send(body);

		}
		catch (err) {
			console.log('error message call back JWE: ' + err.message);
		}
	},
	/*
	* Author : Giovanni Spinelli
	* Date : 20/05/2019
	* Description :create body
	*/
	generateBody: function (component, event) {
		var singleDoc = component.get("v.singleDoc"),
			utilityDocType = component.get("v.documentType")[singleDoc],
			documentType = utilityDocType.split(':')[0],
			fileName = component.get("v.nameFile"),
			fileselect = component.get("v.fileselect");

		var body = '{"documentType":"' + documentType + '","templateName":"","templateVersion":"","documentStream":"' + fileselect + '","documentStatus":"ACTIVE","posType":"","Campi_Setup_Contratto":"","documentFileName":"' + fileName + '","callbackUrl":""}';
		return body;
	}

})