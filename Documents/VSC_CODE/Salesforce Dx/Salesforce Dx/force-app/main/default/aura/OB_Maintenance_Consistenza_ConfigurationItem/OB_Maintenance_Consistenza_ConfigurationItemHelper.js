({
	// Start antonio.vatrano 13/06/2019 ri-100
	// Start antonio.vatrano 27/06/2019 r1f2-270
	setDisableRACSIA : function(component,stabSia,progSia,siaCode){
		var action = component.get("c.isPartnerUser");
		action.setCallback(this,function(response)
		{
			var state = response.getState();
			if (state === "SUCCESS") 
			{
				var isPartnerComm = response.getReturnValue();
				console.log('isParter??: '+ isPartnerComm);
				if(isPartnerComm){
					component.set("v.SIACodeRO", true);
					component.set("v.enstabSIACodeRO", true);
					component.set("v.progSIACodeRO", true);
				}else{
					if(!$A.util.isEmpty(siaCode))
						component.set("v.SIACodeRO", true);
					if(!$A.util.isEmpty(stabSia))
						component.set("v.enstabSIACodeRO", true);
					if(!$A.util.isEmpty(progSia))
						component.set("v.progSIACodeRO", true);
				}
			}
		});
		$A.enqueueAction(action);	
	},
	// Start antonio.vatrano 27/06/2019 r1f2-270
	// End antonio.vatrano 13/06/2019 ri-100
	saveTerminal : function(component,event,helper)
	{
		var action = component.get("c.saveAndSetTrackingGT");

		// INSTANCE PARAMETER OBJECT FOR TRACKING REQUEST GT
		var wrapperPar 				= {};
		var isFirstPos 				= component.get("v.isFirstPos");
		var isAdd					= component.get("v.isAdd");
		var isRemove				= component.get("v.isRemove");
		
		wrapperPar.isFirstPos = isFirstPos;
		wrapperPar.isAdd = isAdd;
		wrapperPar.isRemove = isRemove;

		var isMisingMandatoryData	=  false;
		var comp 					= component.get("v.configurationTerminalObject");
		//START - salvatore.pianura 27/03/2019 - update enablement's values from inputs value
		var enablementsList = [];
		enablementsList = component.get("v.enablements");
		for(singleEnab in enablementsList)
		{
			var singleId = enablementsList[singleEnab].Id;
			if(component.find(singleId)!=undefined)
			{
				var inputValue = component.find(singleId).get("v.value");
				if(enablementsList[singleEnab].OB_enablement__c == "Y")
				{
					enablementsList[singleEnab].NE__StartDate__c = inputValue;
				}
				else
				{
					enablementsList[singleEnab].NE__EndDate__c = inputValue;
				}
			}
			delete enablementsList[singleEnab].attributes ;
			delete enablementsList[singleEnab].disabledEnd ;
			delete enablementsList[singleEnab].disabledStart ;
			delete enablementsList[singleEnab].showStart ;
			delete enablementsList[singleEnab].showEnd ;
			delete enablementsList[singleEnab].showEnablement ;
			delete enablementsList[singleEnab].isNexi ;
		}
		//END - salvatore.pianura 27/03/2019 - update enablement's values from inputs value
		
		wrapperPar.itemId 					= (comp!= undefined ? comp.Id : null);
		wrapperPar.sistemaSorgente			= (comp!= undefined ? comp.OB_GT__c: null);

		// 11-03-2019--S.P.--GET ATTRIBUTE FOR CLIENT ID
		var clientId = component.get("v.clientId");
		if(clientId!=null&&clientId!=undefined)
		{
			wrapperPar.codiceCliente = clientId;
		}
		else
		{
			wrapperPar.codiceCliente			= (comp!= undefined ? comp.OB_CustomerCode__c: null);
		}
		isMisingMandatoryData = isMisingMandatoryData || (isFirstPos && $A.util.isEmpty(wrapperPar.codiceCliente));
		console.log('OB_CustomerCode__c: '+ isMisingMandatoryData);

		var shopCode = component.get("v.shopCode");
		if(shopCode!=null&&shopCode!=undefined)
		{
			wrapperPar.codiceStabilimento = shopCode;
		}
		else
		{
			wrapperPar.codiceStabilimento		= (comp!= undefined ? comp.OB_ShopCode__c: null);
		}
		isMisingMandatoryData = isMisingMandatoryData || (isFirstPos && $A.util.isEmpty(wrapperPar.codiceStabilimento));
		console.log('OB_ShopCode__c: '+ isMisingMandatoryData);
		wrapperPar.tipo						= "FISICO"; //(comp!= undefined ? comp.OB_ServicePointType__c: null);
				
		comp = component.get("v.configuration");
		wrapperPar.idOrdineSfdc 			= (comp!= undefined ? comp.Id : null);
		var ctiCode = component.get("v.ctiCode");
		if(ctiCode!=null&&ctiCode!=undefined)
		{
			wrapperPar.codiceCTI = ctiCode;
		}
		else
		{
			wrapperPar.codiceCTI				= (comp!= undefined ? comp.OB_CTI_Code__c : null);
		}
		isMisingMandatoryData = isMisingMandatoryData || (isFirstPos && $A.util.isEmpty(wrapperPar.codiceCTI));
		console.log('OB_CTI_Code__c: '+ isMisingMandatoryData);

		wrapperPar.statoProvisioning		= "Installazione Terminali";
		
		wrapperPar.codiceStabilimentoSIA	= component.get("v.enstabilishmentSIACode");
		isMisingMandatoryData 				= isMisingMandatoryData || (isFirstPos && $A.util.isEmpty(wrapperPar.codiceStabilimentoSIA));
		console.log('codiceStabilimentoSIA: '+ isMisingMandatoryData);

		wrapperPar.codiceProgressivoSIA		= component.get("v.progressiveSIACode");
		isMisingMandatoryData				= isMisingMandatoryData || (isFirstPos && $A.util.isEmpty(wrapperPar.codiceProgressivoSIA));
		console.log('codiceProgressivoSIA: '+ isMisingMandatoryData);

		wrapperPar.codiceSIA				= component.get("v.SIACode");
		isMisingMandatoryData 				= isMisingMandatoryData || (isFirstPos && $A.util.isEmpty(wrapperPar.codiceSIA));
		console.log('codiceSIA: '+ isMisingMandatoryData);
		//01-03-2019-S.P.
		comp = component.find("installationDate");
		if(comp != undefined)
		{
			var tempString = comp.get("v.value");
			if(!$A.util.isEmpty(tempString))
			{
				if(tempString.includes("T"))
				{
					wrapperPar.dataInizioGT =  tempString.substring(0,tempString.indexOf("T"));
				}
				else
				{
					wrapperPar.dataInizioGT =  tempString;
				}
			}
		}
		else
		{
			var tempString = component.get("v.configurationTerminalObject.NE__StartDate__c");
			if(!$A.util.isEmpty(tempString))
			{
				if(tempString.includes("T"))
				{
					wrapperPar.dataInizioGT = tempString.substring(0,tempString.indexOf("T"));
				}
				else
				{
					wrapperPar.dataInizioGT = tempString;
				}
			}
		}
		// if(wrapperPar.dataInizioGT.includes("T")){
		// 	wrapperPar.dataInizioGT = wrapperPar.dataInizioGT.split('T')[0];
		// }
		// wrapperPar.dataInizioGT				= (comp != undefined ? comp.get("v.value"): null);
		//01-03-2019-S.P.
		isMisingMandatoryData 				= isMisingMandatoryData || (isAdd && $A.util.isEmpty(wrapperPar.dataInizioGT));
		if(!(isAdd || isRemove )){ 
			var today = new Date();
			wrapperPar.dataInizioGT = today.toISOString().split('T')[0]; 
		}
		wrapperPar.dataInstallazione		= wrapperPar.dataInizioGT;	
		//externalSourceMapping.OB_ServicePointType__c
		console.log('installationDate: '+ isMisingMandatoryData);

		wrapperPar.termId					= component.get("v.terminalId");
		isMisingMandatoryData 				= isMisingMandatoryData || ($A.util.isEmpty(wrapperPar.termId));
		console.log('terminalId: ' + isMisingMandatoryData);

		comp = component.find("model");
		//01-03-2019-S.P.
		if(comp != undefined)
		{
			wrapperPar.modello = comp.get("v.value");
		}
		else
		{
			wrapperPar.modello = component.get("v.model");
		}
		// wrapperPar.modello					= (comp != undefined ? comp.get("v.value") : null);
		//01-03-2019-S.P.
		isMisingMandatoryData 				= isMisingMandatoryData || (isAdd && $A.util.isEmpty(wrapperPar.modello));
		console.log('modello: ' + isMisingMandatoryData);

		comp = component.find("modelDesc");
		//01-03-2019-S.P.
		if(comp != undefined)
		{
			wrapperPar.descrizioneModello = comp.get("v.value");
		}
		else
		{
			wrapperPar.descrizioneModello = component.get("v.modelDesc");
		}
		// wrapperPar.descrizioneModello		= (comp != undefined ? comp.get("v.value") : null);
		//01-03-2019-S.P.
		isMisingMandatoryData 				= isMisingMandatoryData || (isAdd && $A.util.isEmpty(wrapperPar.descrizioneModello));
		console.log('descrizioneModello: ' + isMisingMandatoryData);

		comp = component.find("releaseDesc");
		//01-03-2019-S.P.
		if(comp != undefined)
		{
			wrapperPar.descrizioneRelease = comp.get("v.value");
		}
		else
		{
			wrapperPar.descrizioneRelease = component.get("v.releaseDesc");
		}
		// wrapperPar.descrizioneRelease		= (comp != undefined ? comp.get("v.value") : null);
		//01-03-2019-S.P.
		isMisingMandatoryData 				= isMisingMandatoryData || (isAdd && $A.util.isEmpty(wrapperPar.descrizioneRelease));
		console.log('descrizioneRelease: ' + isMisingMandatoryData);

		comp = component.find("connectionDescr");
		//01-03-2019-S.P.
		if(comp != undefined)
		{
			wrapperPar.descrizioneConnessione = comp.get("v.value");
		}
		else
		{
			wrapperPar.descrizioneConnessione = component.get("v.connectionDescr");
		}
		// wrapperPar.descrizioneConnessione	= (comp != undefined ? comp.get("v.value") : null);
		//01-03-2019-S.P.
		isMisingMandatoryData 				= isMisingMandatoryData || (isAdd && $A.util.isEmpty(wrapperPar.descrizioneConnessione));
		console.log('descrizioneConnessione: ' + isMisingMandatoryData);

		comp = component.find("release");
		//01-03-2019-S.P.
		if(comp != undefined)
		{
			wrapperPar.release = comp.get("v.value");
		}
		else
		{
			wrapperPar.release = component.get("v.release");
		}
		// wrapperPar.release					= (comp != undefined ? comp.get("v.value") : null);
		//01-03-2019-S.P.
		isMisingMandatoryData 				= isMisingMandatoryData || (isAdd && $A.util.isEmpty(wrapperPar.release));
		console.log('release: ' + isMisingMandatoryData);

		comp = component.find("connectionType");
		//01-03-2019-S.P.
		if(comp != undefined)
		{
			wrapperPar.modalitaCollegamento = comp.get("v.value");
		}
		else
		{
			wrapperPar.modalitaCollegamento = component.get("v.connectionType");
		}
		// wrapperPar.modalitaCollegamento		= (comp != undefined ? comp.get("v.value")  : null);
		//01-03-2019-S.P.
		isMisingMandatoryData 				= isMisingMandatoryData || (isAdd && $A.util.isEmpty(wrapperPar.modalitaCollegamento));
		console.log('modalitaCollegamento: ' + isMisingMandatoryData);

		comp = component.find("installationStatus");
		//01-03-2019-S.P.
		if(comp != undefined)
		{
			wrapperPar.statoInstallazione = comp.get("v.value");
		}
		else
		{
			wrapperPar.statoInstallazione = component.get("v.installationStatus");
		}
		if(isRemove){
			isMisingMandatoryData = false; //EP i dati prima non servono
		}
		// wrapperPar.statoInstallazione		= (comp != undefined ? comp.get("v.value")  : null);
		//01-03-2019-S.P.
		if(!(isAdd || isRemove )){
			wrapperPar.statoInstallazione ='Installato';
		}
		isMisingMandatoryData 				= isMisingMandatoryData || ($A.util.isEmpty(wrapperPar.statoInstallazione));
		console.log('statoInstallazione: ' + isMisingMandatoryData);
		
		//wrapperPar.causaleRifiuto 			= component.find("rejectionReason").get("v.value");
		
		comp = component.find("unistallationDate");
		//01-03-2019-S.P.
		if(comp != undefined)
		{
			var tempString = comp.get("v.value");
			if(!$A.util.isEmpty(tempString))
			{
				if(tempString.includes("T"))
				{
					wrapperPar.dataDisinstallazione =  tempString.substring(0,tempString.indexOf("T"));
				}
				else
				{
					wrapperPar.dataDisinstallazione =  tempString;
				}
				// wrapperPar.dataDisinstallazione = comp.get("v.value");
			}
		}
		else
		{
			var tempString = component.get("v.configurationTerminalObject.NE__EndDate__c");
			if(!$A.util.isEmpty(tempString))
			{
				if(tempString.includes("T"))
				{
					wrapperPar.dataDisinstallazione =  tempString.substring(0,tempString.indexOf("T"));
				}
				else
				{
					wrapperPar.dataDisinstallazione =  tempString;
				}
			// wrapperPar.dataDisinstallazione = component.get("v.configurationTerminalObject.NE__EndDate__c");
			}
		}
		// if(wrapperPar.dataDisinstallazione.includes("T")){
		// 	wrapperPar.dataDisinstallazione = wrapperPar.dataDisinstallazione.split('T')[0];
		// }
		// wrapperPar.dataDisinstallazione		= (comp!= undefined ? comp.get("v.value") : null);
		//01-03-2019-S.P.
		isMisingMandatoryData 				= isMisingMandatoryData || (isRemove && $A.util.isEmpty(wrapperPar.dataDisinstallazione));
		console.log('dataDisinstallazione: ' + isMisingMandatoryData);

		console.log('@@ wrapperPar: ' + JSON.stringify(wrapperPar));

		if(isMisingMandatoryData){
			var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams
				({
					type: "Error",
					title: "Error",
					message: "ErrorFromServer:" +$A.get("$Label.c.OB_Missing_Data"),
					mode: "dismissible"
				});
				toastEvent.fire();
				return;
		}

		wrapperPar.idItemSalesforceCodConv	= "";
		wrapperPar.companyCodeCodConv		= "";
		wrapperPar.companyNameCodConv		= "";
		wrapperPar.dataInizioCodConv		= "";
		wrapperPar.dataFineCodConv	 		= "";

		console.log("@wrapper : " + JSON.stringify(wrapperPar));
		console.log("@enablementsList : " + JSON.stringify(enablementsList));
		action.setParams
		({
			"wrapperPar" : wrapperPar			,
			"enablementsList" : enablementsList
		});
		action.setCallback(this,function(response)
		{
			var state = response.getState();
			if (state === "SUCCESS") 
			{
				var res = response.getReturnValue();
				console.log('@@Tracking GT res: '+ res);
				if(res.errorCode<1){
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams
					({
						type: "Success",
						title: $A.get("$Label.c.OB_MAINTENANCE_TOAST_OPERATIONSUCCESSFULL"),
						message: "  ",
						mode: "dismissible"
					});
					toastEvent.fire();
					component.set("v.disabledButtons",true);
					location.reload(); 
				} else{
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams
					({
						type: "Error",
						title: "Error",
						message: "ErrorFromServer:" + res.errorMessage,
						mode: "dismissible"
					});
					toastEvent.fire();
				}
				
				// $A.get("e.force:refreshView").fire(); 
			}
			else if (state === "INCOMPLETE")
			{
				//do something
			}
			else if (state === "ERROR") 
			{
				var errors = response.getError();
				if (errors) 
				{
					if (errors[0] && errors[0].message)
					{
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams
						({
							type: "Error",
							title: "Error",
							message: errors[0].message,
							mode: "dismissible"
						});
						toastEvent.fire();
						// console.log("OB_Maintenance_Consistenza_ConfigurationItemHelper.js : action : Error message: " + errors[0].message);
					}
				}
				else 
				{
					console.log("OB_Maintenance_Consistenza_ConfigurationItemHelper.js : action : *UNKNOW ERROR*");
				}
			}
		});
		$A.enqueueAction(action);
	},
	//START--Simone Misani Fix Tracking 20/07/2019
	saveTerminalMixedMaintenace : function(component, event,helper){
		var action = component.get("c.updateOrderItemMixedMaintenance");
			action.setParams({ 
				confId : component.get("v.confId"),
				type: 'Terminali'
			});
			action.setCallback(this, $A.getCallback(function (response) {
				var state = response.getState();
				if (state === "SUCCESS") 
				{	
					var response = response.getReturnValue();
					if(!response){
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams
						({
							type: "Success",
							title: $A.get("$Label.c.OB_MAINTENANCE_TOAST_OPERATIONSUCCESSFULL"),
							message: "  ",
							mode: "dismissible"
						});
						toastEvent.fire();
						component.set("v.disabledButtons",true);
						location.reload(); 
					} else{
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams
						({
							type: "INCOMPLETE",
							title: "Incomplete",
							message: "Manca la risposta della Tracking",
							mode: "dismissible"
						});
						toastEvent.fire();
					}
				}
			}));
			$A.enqueueAction(action); 
			//END--Simone Misani Fix Tracking 20/07/2019  			
	}
})