({
	doInit : function(component, event, helper) {
		console.log("@@doinit ATTACHED for orderHeader: "+component.get("v.orderHeaderId"));
		//START ANDREA
		/*var retrieveNameDocument = component.get("v.retrieveName");
		console.log('retrieveNameDocument: ' + pippo);*/
		//END ANDREA

		// Start AV 21/02/2019 dont show buttons CARICA and RIMUOVI if ADMIN  [Schema STEFANO MONTORI]
		helper.getProfile(component, event, helper);
		// End AV 21/02/2019 dont show buttons CARICA and RIMUOVI if ADMIN  [Schema STEFANO MONTORI]
		// Start AV 21/02/2019  show buttons CARICA and RIMUOVI if DOCUEMNTAZIONE ASSENTE/INCOMPLEATA [Schema STEFANO MONTORI]
		// helper.checkRejectReasons(component, event, helper);
		// END AV 21/02/2019  show buttons CARICA and RIMUOVI if DOCUEMNTAZIONE ASSENTE/INCOMPLEATA [Schema STEFANO MONTORI]


		//	START 	micol.ferrari 18/11/2018
		var actiongetLicense = component.get("c.retrieveUserLicense");
		actiongetLicense.setCallback(this, function(response)
		{
			var state = response.getState();
			// console.log("the state is: "+state);
			if (state === "SUCCESS") 
			{
				var license = response.getReturnValue();
				component.set("v.license", license);

				if (license==$A.get("$Label.c.OB_License_PartnerCommunity"))
				{
					component.set("v.showResubmitIfPartner",true);
					
				}

				//	micol.ferrari 30/11/2018 - FROM CONFIGURATION DETAIL PAGE
				// console.log("## RecordID: "+component.get("v.recordId"));
				if (component.get("v.recordId")!=null && component.get("v.recordId")!="")
				{
					//	WE ARRIVE FROM THE STANDARD LAYOUT OF CONFIGURATION
					var actiondoinit = component.get("c.retrieveOrderHeaderId");
					actiondoinit.setParams({configurationId : component.get("v.recordId")});
					actiondoinit.setCallback(this, function(response)
					{
						var state = response.getState();
						// console.log("the state is: "+state);
						if (state === "SUCCESS") 
						{
							var response = response.getReturnValue();
							component.set("v.orderHeaderId",response);
							// console.log("##response "+response);

							helper.getProductDocuments(component, event, helper);
							helper.getDocId(component);
							// helper.getContractList(component);
						}
						else
						{
							// console.log("retrieveOrderHeaderId ERROR");
						}
					});
					$A.enqueueAction(actiondoinit);
				}
				else
				{
					//	WE ARRIVE FROM ANOTHER COMPONENT
					helper.getProductDocuments(component, event, helper);
					helper.getDocId(component);
					// helper.getContractList(component);
				}
			}
			else
			{
				console.log("NO USER");
			}
		});
		$A.enqueueAction(actiongetLicense);
		//	END 	micol.ferrari 18/11/2018
	},

	fieldsForResubmit : function(component, event, helper){
		var listFields = component.get("v.listFields");
		var sap = listFields[3];
		var fc = listFields[4];
		var rr = listFields[5];
		if(rr==null)
		{
			rr="";
		}
		// console.log("*****Field Resubmit: "+ sap+fc+rr);
		// var condition1 = (sap == "false");
		// var condition2 = (fc == "Controlli Operativi" || fc == "Controlli AML" || fc =="Controlli Sicurezza");
		// var condition3 = (rr != "Rifiuto definitivo");

		// console.log("condizione: "	+ condition1+condition2+condition3);
		if((sap == "false") && (fc == "Controlli Operativi" || fc == "Controlli AML" || fc =="Controlli Sicurezza") && (rr != "Rifiuto definitivo"))
		{
			component.set("v.resubmit",true);
		} 
		console.log("@resubmit:::" + component.get("v.resubmit"));
	},

	// compareDocFilenetSalesForce: function(component)
	// {
	// 	console.log("***compareDocFilenetSalesForce***");
	// 	var documentsInFilenet = component.get("v.mapFileNet");
	// 	console.log(JSON.stringify(documentsInFilenet));
	// 	var documentInSales = component.get("v.response");
	// 	console.log(JSON.stringify(documentInSales));
	// 	var compareMap = new Map();
	// 	for(var k in documentInSales)
	// 	{
	// 		compareMap[k] = ''; 
	// 		var typeDoc = documentInSales[k].split(':')[0];
	// 		console.log('k: '+ k +'		typeDoc: '+typeDoc);
	// 		for (var key in documentsInFilenet)
	// 		{
	// 			console.log('key: '+ key +'		typeDoc: '+documentsInFilenet[key]);
	// 			if(typeDoc == documentsInFilenet[key] && compareMap[k]=='')
	// 			{
	// 				compareMap[k]= key.substring(1, key.length-1);

	// 			}
				
				
	// 		}
	// 	}
		
	// 	component.set("v.compareMap", compareMap);
	// 	console.log("****compareMapNew: "+ JSON.stringify(compareMap));
	// },

	compareDocFilenetSalesForce: function(component)
	{
		console.log("***compareDocFilenetSalesForce***");
		var documentsInFilenet = component.get("v.mapFileNet");
		// console.log(JSON.stringify(documentsInFilenet));
		var documentInSales = component.get("v.response");
		// console.log(JSON.stringify(documentInSales));
		var compareMap = new Map();
		for(var k in documentInSales)
		{
			var listId = [];
			compareMap[k] = ''; 
			var typeDoc = documentInSales[k].split(':')[0];
			// console.log('k: '+ k +'		typeDoc: '+typeDoc);
			for (var key in documentsInFilenet)
			{
				// console.log('key: '+ key +'		typeDoc: '+documentsInFilenet[key]);
				if(typeDoc == documentsInFilenet[key])
				{
					// compareMap[k]= key.substring(1, key.length-1);
					listId.push(key.substring(1, key.length-1));	
				}
			}
				compareMap[k] = listId;
				// console.log('key: '+ k +'		typeDoc: '+ JSON.stringify(listId));
		}
		console.log("****compareMapNew: "+ JSON.stringify(compareMap));
		component.set("v.compareMap", compareMap);
		
	},



	approvalProcess : function(component,event,helper){

		console.log(component.get("v.orderHeaderId"));
		var orderHeaderId = component.get("v.orderHeaderId")
		var action = component.get("c.submitApprovalProcess");
		action.setParams({ orderHeaderId : orderHeaderId });
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				console.log("******approvalProcessStart");
				// alert("RESUBMIT APPROVAL PROCESS");
				//23-02-2018-S.P.-START
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams
				({
					type: "Success",
					title: $A.get("$Label.c.OB_MAINTENANCE_TOAST_OPERATIONSUCCESSFULL"),
					message: "  ",
					mode: "dismissible"
				});
				toastEvent.fire();
				component.set("v.resubmitDisabled",true);
				//23-02-2018-S.P.-END
			}
			else 
			{
				console.log("Failed with state: " + state);
			}
		});
		$A.enqueueAction(action);
	},
	
	//ANDREA START
	// setDocumName : function(component, event, helper) {
	// 	var idSpinner = document.getElementById("mySpinner4");
	
	// 	console.log('setDocumName is called ');
	// 	var eventValue= event.getParam("filename");
 //        component.set("v.documName", eventValue);
 //        console.log('file name is : ' + component.get("v.documName"));
 //        console.log('eventValue is: ' + eventValue);
 //        if(eventValue != '' || eventValue != null){
 //        	// var showMeSpinner = component.get("v.disableSpinner")
 //        	// component.set("v.disableSpinner", false);
 //        	if(component.get("v.removedSpinner")){

 //        		idSpinner.remove();
 //        		component.set("v.removedSpinner", false);
 //        	}
 //        }
	// }
	//ANDREA END

	// start AV 20/02/2019 1388 can resubmit
	checkAllTrue : function(component, event){
		var changedMap=event.getParam("value");
		var allTrue = false;
		var listChecked = [];
		for(var key in changedMap){
			listChecked.push(changedMap[key]);
		}
		console.log("@@@checkalltrue: "+JSON.stringify(listChecked));
		if(listChecked.includes(false)){
			component.set("v.canResubmit", "false");
			// console.log("*******all Docs aren't load************");
		}
		else {
			// console.log("*******all Docs are load************");
			component.set("v.canResubmit", "true");
		}
	},
	// End AV 20/02/2019 1388 can resubmit

	//giovanni spinelli method to download all documents 
	downloadAllDocs: function(component, event){
		var mapValueDocs= component.get('v.mapValueDocs');
		for(var key in mapValueDocs){
			// console.log('KEY--> ' + key);
			var hiddenElement      = document.createElement('a');
			hiddenElement.href     = 'data:application/octet-stream;base64,' + encodeURI(mapValueDocs[key]['b64']);//data:application/octet-stream;base64,
			hiddenElement.target   = '_self'; //
			hiddenElement.download = mapValueDocs[key]['filename'];  // CSV file Name* you can change it.[only name not .csv]
			document.body.appendChild(hiddenElement); // Required for FireFox browser
			hiddenElement.click();
		}
	},
	//giovanni spinelli method to download all contracts 
	downloadAllContracts :  function(component, event){
		var mapValueContracts= component.get('v.mapValueContracts');
		for(var key in mapValueContracts){
			// console.log('KEY--> ' + key);
			var hiddenElement      = document.createElement('a');
			hiddenElement.href     = 'data:application/octet-stream;base64,' + encodeURI(mapValueContracts[key]['b64']);//data:application/octet-stream;base64,
			hiddenElement.target   = '_self'; //
			hiddenElement.download = mapValueContracts[key]['filename'];  // CSV file Name* you can change it.[only name not .csv]
			document.body.appendChild(hiddenElement); // Required for FireFox browser
			hiddenElement.click();
		}
	},
//Start antonio.vatrano 24/09/2019 R1F3-97 
	openDocRisk : function(component, event){
		try {
			var idDocRisk = component.get('v.idDocRisk');
			var idFinal = idDocRisk.substring(1,idDocRisk.length-1 );
			var action = component.get("c.getTokenJWE");
			action.setParams({ documentName : idFinal });

			action.setCallback(this, function(response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					var response = response.getReturnValue();
					var token = response['jewToken'];
					var url;
					var listFields = component.get("v.listFields");
					var orderId = listFields[0];
					var salePoint = listFields[1];
					var merchant = listFields[2];
					url = response['FEurl'] + '/api/merchants/'+merchant+'/sales-points/'+salePoint+'/orders/'+orderId+'/documents/'+idFinal;
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
	}
	//End antonio.vatrano 24/09/2019 R1F3-97 
})