({
	doInit : function(component, event, helper) {
		console.log('COMPARE MAP IN CHILD COMPONENT: ' + JSON.stringify(component.get('v.compareMap')));
		component.set("v.showUploadButton",true);
		var docList= component.get("v.documentsList");
		var mapMultiple= component.get("v.mapMultiple");
		var docType = component.get("v.documentType");
		for(var i=0; i<docList.length; i++){
			var isMultiple=docType[docList[i]].split(':')[1];
			mapMultiple[docList[i]]= isMultiple;
		}
		component.set("v.mapMultiple",mapMultiple);
		// /console.log("****map isMultiple"+JSON.stringify(mapMultiple));
		var documentIdMap = component.get("v.documentIdMap");
		for(var k in docList){
			documentIdMap[docList[k]]= [];//gs change value
		}
		component.set("v.documentIdMap",documentIdMap);
		// console.log("°°°mapIDSHOW"+JSON.stringify(component.get("v.documentIdMap")));
	},
	/* 
	* Author : Giovanni Spinelli
	* Date : 13/05/2019
	* Description : method to create a new map with previous documents 
	*/
	onRender: function(component, event, helper) {
		if (component.get("v.doneRender")==false)
		{
			
			console.log('CURRENT NAME DOCUMENT2: ' + component.get('v.singleDoc'));
			var singleDoc = component.get('v.singleDoc');
			var compareMap = component.get('v.compareMap');
			var myMap = component.get('v.myMap');//map to allow user to go to next step
			console.log('VALUE IN COMPARE MAP: '+ compareMap[singleDoc]);
			if(compareMap[singleDoc] && compareMap[singleDoc]!='')
			{
				//alert('into important if');
				for(var nameFile in compareMap){
					if(nameFile==singleDoc){
						console.log('KEY OF COMPARE MAP: '+ nameFile);
						console.log('NAME: '+nameFile+' ID: '+compareMap[nameFile]);
						if(!nameFile.includes('Contratto firmato')){
							helper.showFlag(component);
							//hide upload button and show modify button to indicate that there is that document
							component.set('v.toUpload' , false);
							component.set('v.toModify' , true);
							myMap[singleDoc]=true; //true means that I have uploaded a doc before
							component.set("v.myMap", myMap);
						}else{
							console.log('VALUE IN CONTRATTO FIRMATO: '+ compareMap[singleDoc]);
							helper.showFlag(component);
							//enable button to deprecate all previous contratti firmati docs
							component.set('v.deleteAllDocs' , true);
							myMap[singleDoc]=true; 
							component.set("v.myMap", myMap);
						}
						
						
						
					}
				}
				component.set('v.documentIdMap',compareMap);
			}
			console.log('COMPARE MAP IN ON RENDER: ' + JSON.stringify(component.get('v.documentIdMap')) );
			component.set("v.doneRender",true);
		}
	},




	loadDoc : function(component, event, helper)
	{
		//francesca.ribezzi 05/12/19 - perf-17 - hiding icons when loading docs
		component.set("v.showError", false);
		console.log("*******loadDoc ****************");
		var fileInput = component.find("inputFile").getElement();

		if('files' in fileInput)
		{
			var file = fileInput.files[0];
			var fileName = file.name;

			// IDJira Doris Dongmo <doris.tatiana.dongmo@accenture.com>, 12/04/2019 StartT//
			
			//CONVERT FILE SIZE TO MB 
			var totalSizeMB = file.size / Math.pow(1024,2);

			if(totalSizeMB > 8){ 
				var messageToast =  $A.get("$Label.c.OB_Control_size_file");
				var titleToast   =  $A.get("$Label.c.OB_MAINTENANCE_OPERATION_FAILED");
				//toast method
				helper.ToastFunction(messageToast,titleToast,'error');
				return;
							
			} 

			// Doris Dongmo, 12/04/2019 ....END//
			//04/06/2019 giovanni spinelli - start -PRODOB - 176
			var regex = new RegExp("[&!|”£$%()=?^éè\/{}@#§°ç]", "g");
			if (regex.test(fileName) || fileName.includes('[') || fileName.includes(']')) {
				var messageToast = $A.get("$Label.c.OB_Invalid_Character_FileName");
				var titleToast = $A.get("$Label.c.OB_MAINTENANCE_OPERATION_FAILED");
				helper.ToastFunction(messageToast, titleToast, 'error');
				return;
			}
			//04/06/2019 giovanni spinelli - end -PRODOB - 176
			var mapFileUploaded = new Map();
			mapFileUploaded[file.name] = file;
			component.set("v.mapFileUploaded",mapFileUploaded);
			component.set("v.fileselect", file);
			component.set("v.fileName",fileName);
			component.set("v.nameFile",fileName);					//  AV 26/02/2019 SETUP-92 show fileName uploaded 
			component.set("v.showIcon",true);	//giovanni spinelli show icon left name file
			console.log("***file.name: "+file.name);
			console.log("***file: "+typeof(file));
			
			var reader = new FileReader();
			reader.readAsDataURL(file);
			reader.onload=function()
			{
				var str=reader.result;
				var b64pure=str.split(",")[1];
				var typeDoc=str.split(",")[0];
				console.log("###TYPE: "+typeDoc);

				if(typeDoc == "data:application/pdf;base64"){ /*controll if the document is *.pdf" */
					// component.set("v.toUpload", false);
					//component.set("v.toSave", true);
					component.set("v.fileselect", b64pure);
					/*
					giovanni spinelli fire upload doc after select doc 31/07/2019
					*/
					component.set('v.fireHandlerUploadDoc' , true);
					
					

				}
				else{
					// IDJira Doris Dongmo <doris.tatiana.dongmo@accenture.com>, 12/04/2019 Start//	

					//toast method		
					titleToast  = $A.get("$Label.c.OB_MAINTENANCE_OPERATION_FAILED");
					messageToast= $A.get("$Label.c.OB_onlyPDF");
					helper.ToastFunction(messageToast,titleToast, 'error');
					// Doris Dongmo, 12/04/2019 ....END//
				}
			};
		};
	},





	saveButton : function (component, event, helper) {
		component.set("v.response", "");
		helper.showSpin(component);
		component.set("v.showSaving", true);//giovanni spinelli show text saving....
		var merchantId = component.get("v.objectDataMap.merchant.Id");
		var servicePointId = component.get("v.objectDataMap.pv.Id");
		var configurationId =  component.get("v.objectDataMap.Configuration.Id");
		/*var merchantId='0019E00000pZPVBQA4';
		var servicePointId='a199E000000pHf7QAE';
		var configurationId =  'a0w9E000002q4cjQAA';*/

		var singleDoc = component.get("v.singleDoc");
		// var servicePointId='a199E000000G5HnQAK';
		// var configurationId = 'a0y9E000000FYitQAG';
		// var merchantId = "0019E00000mIK0tQAG";
		var fileselect = component.get("v.fileselect");
		console.log('fileselect: '+fileselect);
		var documentIdMap = component.get("v.documentIdMap");
		var docId =[];//giovanni spinelli 14/05/2019 set null id when save a doc | before was -> var docId = documentIdMap[singleDoc];
		console.log();
		var isNewUpload = docId=="" ? "false" : "true"; 
		var fileName = component.get("v.fileName");
		var utilityDocType = component.get("v.documentType")[singleDoc];
		console.log('utilityDocType: '+JSON.stringify(utilityDocType));
		var documentType = utilityDocType.split(':')[0];
		// console.log('****documentType '+documentType);
		var isMultiple = utilityDocType.split(':')[1];
		component.set("v.isMultiple", isMultiple);
		console.log(merchantId+"||"+servicePointId+"||"+configurationId+"||"+singleDoc+"||"+docId+"||"+isNewUpload);
		var request = $A.get("e.c:OB_ContinuationRequest");
		request.setParams({ 
			methodName: "filenetUpload",
			methodParams: [merchantId, servicePointId, configurationId,documentType,fileselect,isNewUpload,docId,fileName],
			callback: function(result) {
				console.log('result: '+result);
				var documentId= result;
				console.log('****RISULTATO: '+ documentId);
				// var documentIdMap = component.get("v.documentIdMap");

				if(documentId!="" && documentId!=null && documentId!=undefined && documentId!='Error'){
					// component.set("v.documentId" , documentId);
					component.set("v.response",result);
					var myMap= component.get("v.myMap");
					var isMultiple = component.get("v.isMultiple");
					// var fileName = component.get("v.fileName");								// Start AV 20/02/2019  #00001589 show fileName uploaded 
					if(isMultiple=="true"){
						component.set("v.toSave", false);
						component.set("v.toUpload", true);
						component.set("v.nameFile",'');										//AV 20/02/2019  #00001589 show fileName uploaded
					}else{
						component.set("v.toSave", false);
						component.set("v.toModify", true);
						var listID = documentIdMap[singleDoc];
						listID.push(documentId);
						documentIdMap[singleDoc]=listID;
						component.set('v.documentIdMap' , documentIdMap);
						console.log('documentIdMap: '+JSON.stringify(documentIdMap));
						//START gianluigi.virga 25/09/2019
						// //giovanni spinelli start 08/07/2019 store value of docs saved in objectdatamap
						// try{
						// 	for(var name in documentIdMap){
						// 		if(documentIdMap[name]){
						// 			var ids = documentIdMap[name];
						// 			// component.set('v.objectDataMap.documentSaved.'+name , ids.replace(/{/g , '').replace(/}/g , ''));
						// 			component.set('v.objectDataMap.documentSaved.'+name , ids);
						// 			console.log('@@@ document saved; ' + JSON.stringify(component.get('v.objectDataMap.documentSaved')));
						// 		}
						// 	}
						// }catch(err){
						// 	console.log('ERROR IN STORE ID: ' + err.message);
						// }
						// //giovanni spinelli end 08/07/2019 store value of docs saved in objectdatamap
						//START gianluigi.virga 25/09/2019
						// component.set("v.nameFile",fileName);								// End AV 20/02/2019  #00001589 show fileName uploaded
					}
					// var singledoc = component.get("v.singleDoc");
					helper.hideSpin(component);
					component.set("v.showSaving", false);//giovanni spinelli hide text saving....
					myMap[singleDoc]=true; //caricato = true altrimenti false . single doc è il nome del documento
					component.set("v.myMap", myMap);
					console.log("********MAP PRODUCT: " + JSON.stringify(component.get("v.myMap")));
				}else{
					// component.set("v.documentId" , "");
					component.set("v.response",result);
					var myMap= component.get("v.myMap");
					var isMultiple = component.get("v.isMultiple");
					if(isMultiple=="true"){
						component.set("v.toUpload", true);
						component.set("v.toSave", false);
						
					}else{
						component.set("v.toSave", false);
					}
					// var singledoc = component.get("v.singleDoc");
					helper.hideSpin(component);
					component.set("v.showSaving", false);//giovanni spinelli hide text saving....
					myMap[singleDoc]=false;
					component.set("v.myMap", myMap);
					component.set("v.toUpload", true);
				//	helper.showError(component);
				//	helper.showErrorMessage(component);
				    component.set("v.showError", true);// francesca.ribezzi 06/12/19 - perf-17 - showing error icon and message
				}
			}
		});
		request.fire();
	},


	modification : function(component, event, helper){
	
		component.set("v.toModify", false);
		component.set("v.toUpload", true);
		component.set('v.disabledSaveDuringLoad' ,  false);//make enabled button until load is fisnished
		//giovanni spinelli start add class disabled
		var button = component.find('upLoad');
		$A.util.addClass(button, 'LoadButton');
		$A.util.removeClass(button, 'LoadButtonDisabled');
		//giovanni spinelli end add class disabled
		component.set("v.showIcon",true);	//giovanni spinelli show icon left name file
		var flag  = component.find("statusIcon");
		$A.util.addClass(flag,'slds-hide');
		$A.util.removeClass(flag,'slds-show');
		var myMap= component.get("v.myMap");
		myMap[component.get("v.singleDoc")]=false;
		component.set("v.myMap", myMap);
		console.log("********MAP PRODUCT: " + JSON.stringify(component.get("v.myMap")));
		component.set("v.nameFile",'');										// Start AV 26/02/2019 SSETUP-92 show fileName uploaded 
		component.set("v.showIcon",false);	//giovanni spinelli hide icon
		helper.delete(component, event, helper);


	},

	resetFile : function(component, event, helper){
		component.set("v.nameFile",'');	
		component.set('v.showIcon' , false);//giovanni spinelli 04/06/2019 hide icon
		var input= component.find("inputFile").getElement();
		input.value=null;
		//helper.hideError(component);
		//helper.hideErrorMessage(component);
		component.set("v.showError", false); // francesca.ribezzi 06/12/19 - perf-17 - hiding error icon and message
	},



	newComp : function(component, event, helper){
		console.log("***newComp handler change");
		var response= component.get("v.response");
		if(response!=""){
			//var jsonResponse= JSON.parse(response);
			var documentId=  response;
			console.log("****response", response);
			var isMultiple = component.get("v.isMultiple");
			console.log("****isMultiple"+ isMultiple);
			var documentIdMap = component.get("v.documentIdMap");
			if(documentId!="" && documentId!=null && documentId!=undefined && documentId!='Error'){
				if(isMultiple=="true"){
					console.log("***in if response");
					var filename = component.get("v.fileName");
					var index = component.get("v.index");
					var namedoc = component.get("v.singleDoc");
					var idDocument = namedoc+"_"+index.toString();
					console.log("id doc: "+idDocument);
					idDocumentButton = idDocument.replace(/ /g, "_").toLowerCase();
					documentIdMap[idDocumentButton]=documentId;
					//START gianluigi.virga 25/09/2019 - commented logic
					//giovanni spinelli start 08/07/2019 store value of docs saved in objectdatamap
					// try{
					// 	for(var name in documentIdMap){
					// 		if(documentIdMap[name]){
					// 			var ids = documentIdMap[name];
					// 			// component.set('v.objectDataMap.documentSaved.'+name , ids.replace(/{/g , '').replace(/}/g , ''));
					// 			component.set('v.objectDataMap.documentSaved.'+name , ids);
					// 			console.log('@@@ document saved; ' + JSON.stringify(component.get('v.objectDataMap.documentSaved')));
					// 		}
					// 	}
					// }catch(err){
					// 	console.log('ERROR STORE ID: ' + err.message);
					// }
					// //giovanni spinelli end 08/07/2019 store value of docs saved in objectdatamap
					//END gianluigi.virga 25/09/2019
					console.log('documentIdMap: '+JSON.stringify(documentIdMap));
					console.log("id___doc: "+idDocument);
					$A.createComponent("c:OB_DynamicCmpDocuments",
						{
							"Id": idDocumentButton,
							"inputText": filename,
							"objectDataMap": component.get("v.objectDataMap"),
							"fileselect": '',//giovanni spinelli pass emty value in this attribute because here we have the base64, for this reason $A.createComponent doesn't work(component.get("v.fileselect"))
							"documentIdMap": component.get("v.documentIdMap"),
							"documentType": component.get("v.documentType"),
							"singleDoc": component.get("v.singleDoc"),
							//02/04/19 francesca.ribezzi passing myMap:
							"myMap": component.get("v.myMap")
						}, 
						//giovanni spinelli manage error - start
						function (cmp, status, errorMessage) {
							if (status === "SUCCESS") {
								console.log("***new component Success");
								var body = component.get("v.body");
								var index = component.get("v.index");
								index += 1;
								component.set("v.index", index);
								body.push(cmp);
								component.set("v.body", body);
							} else if (status === "ERROR") {
								console.log("Error: " + errorMessage);
							}
						//giovanni spinelli manage error - start
						});
				}
				else{
					helper.showFlag(component);
					var btnLoad = component.find("upLoad");
					$A.util.addClass(btnLoad,'slds-hide');
					var btnEdit = component.find("modification");
					$A.util.removeClass(btnEdit,'slds-hide');
				}
			}
			else{
				var btnLoad = component.find("upLoad");
				$A.util.removeClass(btnLoad,'slds-hide');
				//helper.showError(component);
				//helper.showErrorMessage(component);
				component.set("v.showError", true); // francesca.ribezzi 06/12/19 - perf-17 - showing error icon and message
			}
		}

	},
	//03/04/19 francesca.ribezzi adding handleRemoveDoc function:
	handleRemoveDoc: function(component, event, helper){
		var myMap = event.getParam("myMap");
		component.set("v.myMap", myMap);
	},
	/*
	* Author : Giovanni Spinelli
	* Date : 13/05/2019
	* Description : call apex  method to deprecate all uploaded docs.
	*/
	deprecateAllDocsFirmato : function(component, event, helper){
		console.log('COMPARE MAP IN deprecate all: ' + JSON.stringify(component.get('v.documentIdMap')) );
		var contractsIdList = [];
		contractIdMap   = component.get('v.documentIdMap');
		//save only id in a list
		for(var ids in contractIdMap){
			if(ids.includes('Contratto firmato')){
				//store list of contratto firmato ids to deprecate
				contractsIdList=contractIdMap[ids];
			}
		}
        var merchantId      = component.get('v.objectDataMap.merchant.Id'),
            servicePointId  = component.get('v.objectDataMap.pv.Id'),
			orderId         = component.get('v.objectDataMap.Configuration.Id');
		var singleDoc = component.get('v.singleDoc');
		var myMap = component.get('v.myMap');//map to allow user to go to next step
		console.log('params: ' + merchantId + ' '+servicePointId+'  '+orderId);
		console.log('*****id list: ' +contractsIdList);
        var action = component.get("c.deprecateDocs");
        action.setParams({   merchantId     :   merchantId,
                            servicePointId  :   servicePointId,
                            orderId         :   orderId,
                            contractsIdList :   contractsIdList
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
			console.log('STATE IN DEPRECATE ALL PREVIOUS DOCUMENTS IS: '+ state);
			if(state === "SUCCESS"){
				console.log('RESPONSE DEPRECATE ALL DOCS: ' + response.getReturnValue());
				var returnValue =  response.getReturnValue();
				if(returnValue == '200'){
					var title   = $A.get("$Label.c.OB_SuccessToastTitle"),
						message = $A.get("$Label.c.OB_SuccessToastText");
					helper.ToastFunction(message, title,'success');//show success toast
					component.set('v.disableModificationAll',true);
					console.log('@@@@: ' + JSON.stringify(contractIdMap));
					try{
						// if map has at leat a 'contratto_firmato_1' this mean that user has generated a new contratto firmato --> allow to go next step
						if(contractIdMap['contratto_firmato_1']){
							myMap[singleDoc]=true;
						}else{
							myMap[singleDoc]=false;
						}
					}catch(err){
						console.log('ERROR MESASGE: '+err.message);
					}
					component.set('v.myMap' , myMap); 
					helper.hideFlag(component);
					console.log('ID MAP AFTER DEPRECATE: ' + JSON.stringify(contractIdMap));
					//delete id from map after deprecate them
					for(var ids in contractIdMap){
						if(ids.includes('Contratto firmato')){
							//store list of contratto firmato ids to deprecate
							var documentIdMap = component.get('v.documentIdMap');
							documentIdMap[ids] = [];
							component.set( 'v.documentIdMap', documentIdMap);
							console.log('MAP AFTER SET: '+ JSON.stringify(component.get('v.documentIdMap')));
						}
					}
				}else{
					var title   = $A.get("$Label.c.OB_CustomErrorLabelTech"),
						message = $A.get("$Label.c.OB_ErrorToastText");
					helper.ToastFunction(message, title,'error');
				}
				console.log('MY MAP AFTER DEPRECATED: ' + JSON.stringify(component.get('v.myMap')) );
			}else{
				var title   = $A.get("$Label.c.OB_CustomErrorLabelTech"),
					message = $A.get("$Label.c.OB_ErrorToastText");
				helper.ToastFunction(message, title,'error');
			}
        });
        $A.enqueueAction(action);
	},
	
	/*
	* Author : Giovanni Spinelli
	* Date : 16/05/2019
	* Description : get token valid 5 min
	* Version 1.0 --> Created
	* Version 2.0 --> move this method in aura handler and add boolean to control when is fired
	*/
	callAPIGW: function (component, event, helper) {
		var fireHandlerUploadDoc = component.get('v.fireHandlerUploadDoc');
		if(fireHandlerUploadDoc == true){
			try {
				var action = component.get("c.getTokenJWE"),
					documentName = component.get("v.nameFile"),
					merchant = component.get('v.objectDataMap.merchant.Id'),
					salePoint = component.get('v.objectDataMap.pv.Id'),
					orderId = component.get('v.objectDataMap.Configuration.Id');
				component.set('v.disabledSaveDuringLoad', true);	//make disable button until load is fisnished
				//giovanni spinelli start add class disabled
				var button = component.find('upLoad');
				$A.util.addClass(button, 'LoadButtonDisabled');
				$A.util.removeClass(button, 'LoadButton');
				//giovanni spinelli end add class disabled
				helper.showSpin(component);							//fire spinner
				component.set("v.showSaving", true);				//show text saving....
				console.log('DOCS NAME: ' + documentName);
				console.log('PARMAS URL: ' + merchant + ' || ' + salePoint + ' || ' + orderId);
				action.setParams({ documentName: documentName });
				action.setCallback(this, function (response) {
					var state = response.getState();
					console.log('state getToken is: ' + state);
					console.log('response is: ' + JSON.stringify(response.getReturnValue()));
					var response = response.getReturnValue();

					if (state === "SUCCESS") {

						var token = response['jewToken'];
						var url = response['FEurl'] + '/api/merchants/' + merchant + '/sales-points/' + salePoint + '/orders/' + orderId + '/documents';
						console.log('TOKEN: ' + token);
						console.log('FE URL: ' + url);
						component.set("v.uploadFileUrl", url);
						component.set("v.jweToken", token);
						helper.callBackJWE(component, token, url);
						component.set('v.fireHandlerUploadDoc' , false);
					}
				});
				$A.enqueueAction(action);
			} catch (err) {
				console.log(err.message);
			}
		}
		
	},
	

})