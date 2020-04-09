({
	checkDataForTracking : function(component,event,helper,listOfTerms)
	{

	},

	saveAndSetTrackingVas : function(component,event) 
	{
		try
		{
			/*
			var terminalId;
			var model;
			var modelDesc;
			var releaseDesc;
			var connectionDescr;
			var release;
			var connectionType;
			var listOfAttributes = [];
			if((typeof(currentTerm.NE__Order_Item_Attributes__r)!=undefined&&currentTerm.NE__Order_Item_Attributes__r!=null)&&
				(typeof(currentTerm.NE__Order_Item_Attributes__r.records)!=undefined&&currentTerm.NE__Order_Item_Attributes__r.records!=null))
			{
					listOfAttributes.push(currentTerm.NE__Order_Item_Attributes__r.records)
			}
			console.log("@listOfAttributes vas : " + JSON.stringify(listOfAttributes));
			console.log("@listOfAttributes length : " + listOfAttributes.length);
			for(var attr=0;attr < listOfAttributes.length;attr++)
			{
				for(var i=0;i<listOfAttributes[attr].length;i++)
				{
					console.log("@attr vas : " + JSON.stringify(listOfAttributes[attr][i]));
					if(listOfAttributes[attr][i].Name == "Terminal Id")
					{
						terminalId = listOfAttributes[attr][i].NE__Value__c;
						console.log("@terminalId vas : " + JSON.stringify(listOfAttributes[attr][i]));
					}
					else if(listOfAttributes[attr][i].Name == "Modello")
					{
						model = listOfAttributes[attr][i].NE__Value__c;
						console.log("@Modello vas : " + JSON.stringify(listOfAttributes[attr][i]));
					}
					else if(listOfAttributes[attr][i].Name == "Descrizione Modello")
					{
						modelDesc = listOfAttributes[attr][i].NE__Value__c;
						console.log("@modelDesc vas : " + JSON.stringify(listOfAttributes[attr][i]));
					}
					else if(listOfAttributes[attr][i].Name == "Descrizione Release")
					{
						releaseDesc = listOfAttributes[attr][i].NE__Value__c;
						console.log("@releaseDesc vas : " + JSON.stringify(listOfAttributes[attr][i]));
					}
					else if(listOfAttributes[attr][i].Name == "Descrizione Connessione")
					{
						connectionDescr = listOfAttributes[attr][i].NE__Value__c;
						console.log("@connectionDescr vas : " + JSON.stringify(listOfAttributes[attr][i]));
					}
					else if(listOfAttributes[attr][i].Name == "Release")
					{
						release = listOfAttributes[attr][i].NE__Value__c;
						console.log("@release vas : " + JSON.stringify(listOfAttributes[attr][i]));
					}
					else if(listOfAttributes[attr][i].Name == "ModalitàCollegamento")
					{
						connectionType = listOfAttributes[attr][i].NE__Value__c;
						console.log("@connectionType vas : " + JSON.stringify(listOfAttributes[attr][i]));
					}
				}
			}*/
			// var currentTerm = {};
			// currentTerm = component.get("v.currentTerm");
			/*
			var wrapperPar = {};
			if(listOfAttributes.length>0 && typeof(listOfAttributes)!==undefined && listOfAttributes!=null)
			{
				wrapperPar.itemId 					= currentTerm.Id;
				var comp = component.get("v.configuration");
				wrapperPar.idOrdineSfdc 			= (comp != undefined ? comp.Id : null);
				wrapperPar.codiceCTI				= (comp != undefined ? comp.OB_CTI_Code__c : null);
				wrapperPar.sistemaSorgente			= currentTerm.OB_GT__c;
				wrapperPar.statoProvisioning		= "Installazione Terminali";
				wrapperPar.codiceCliente			= currentTerm.OB_CustomerCode__c;
				wrapperPar.codiceStabilimento		= currentTerm.OB_CustomerCode__c;

				wrapperPar.codiceStabilimentoSIA	= component.get("v.enstabilishmentSIACode");
				wrapperPar.codiceProgressivoSIA		= component.get("v.progressiveSIACode");
				wrapperPar.codiceSIA				= component.get("v.SIACode");
				wrapperPar.dataInizioGT				= currentTerm.NE__StartDate__c;
				wrapperPar.tipo						= currentTerm.OB_ServicePointType__c; //externalSourceMapping.OB_ServicePointType__c
				wrapperPar.termId					= terminalId;
				wrapperPar.modello					= model;
				wrapperPar.descrizioneModello		= modelDesc;
				wrapperPar.descrizioneRelease		= releaseDesc;
				wrapperPar.descrizioneConnessione	= connectionDescr;
				wrapperPar.release					= release;
				wrapperPar.modalitaCollegamento		= connectionType;
				wrapperPar.statoInstallazione		= "Installato";//component.find("installationStatus").get("v.value");
				wrapperPar.causaleRifiuto 			= component.get("v.rejectionReason");
				wrapperPar.dataInstallazione		= currentTerm.NE__StartDate__c;
				wrapperPar.dataDisinstallazione		= currentTerm.NE__EndDate__c;
				wrapperPar.idItemSalesforceCodConv	= currentVas.Id;
				wrapperPar.companyCodeCodConv		= currentVas.OB_ConventionCode__c;
				wrapperPar.companyNameCodConv		= currentVas.OB_CompanyCode__c;
				if(component.find("startDateVas"))
				{
					wrapperPar.dataInizioCodConv = component.find("startDateVas").get("v.value");
				}
				else
				{
					wrapperPar.dataInizioCodConv = component.get("v.disconnectedVAS.NE__StartDate__c");
				}
				if(component.find("endDateVas"))
				{
					wrapperPar.dataFineCodConv = component.find("endDateVas").get("v.value");
				}
				else
				{
					wrapperPar.dataFineCodConv = component.get("v.disconnectedVAS.NE__EndDate__c");
				}
			}
			*/
			//if(wrapperPar!=null)	{
				//console.log("@wrapper : " + JSON.stringify(wrapperPar));
				// var action = component.get("c.saveAndSetTrackingGT");
				// LUBRANO 2019-03-05 -- TRACKING DIRETTO SUI VAS
				var finalStartDate = "";
				var finalEndDate = "";
				var item = component.get("v.disconnectedVAS");
				var action = component.get("c.updateItem");
				var startDate = component.find("startDateVas");
				if(startDate!=undefined)
				{
					var stringStartDate = startDate.get("v.value");
					if(!$A.util.isEmpty(stringStartDate))
					{
						if(stringStartDate.includes("T"))
						{
							finalStartDate = stringStartDate.substring(0,stringStartDate.indexOf("T"));
						}
						else
						{
							finalStartDate = stringStartDate;
						}
					}
				}
				else
				{
					var stringStartDate = component.get("v.disconnectedVAS.NE__StartDate__c");
					if(!$A.util.isEmpty(stringStartDate))
					{
						if(stringStartDate.includes("T"))
						{
							finalStartDate = stringStartDate.substring(0,stringStartDate.indexOf("T"));
						}
						else
						{
							finalStartDate = stringStartDate;
						}
					}
				}
				var endDate = component.find("endDateVas");
				if(endDate!=undefined)
				{
					var stringendDate = endDate.get("v.value");
					if(!$A.util.isEmpty(stringendDate))
					{
						if(stringendDate.includes("T"))
						{
							finalEndDate = stringendDate.substring(0,stringendDate.indexOf("T"));
						}
						else
						{
							finalEndDate = stringendDate;
						}
					}
				}
				else
				{
					var stringendDate = component.get("v.disconnectedVAS.NE__EndDate__c");
					if(!$A.util.isEmpty(stringendDate))
					{
						if(stringendDate.includes("T"))
						{
							finalEndDate = stringendDate.substring(0,stringendDate.indexOf("T"));
						}
						else
						{
							finalEndDate = stringendDate;
						}
					}
				}
				//Simone Misani 19/12/2019 STARt per -100
				var codiceconv = '';
            	var isRecorOne = component.get('v.hasRecOneClickVas');
                if(isRecorOne){
                    codiceconv = component.find('conventionCode').get('v.value');
                    if($A.util.isEmpty(codiceconv)){
                        component.set('v.isdisabledVas', false );
                    }else{
                        component.set('v.isdisabledVas', true );
					}
                    
                }
				action.setParams
				({
					"rootId" : item.Id,
					"startDate" : finalStartDate,
					"endDate" : finalEndDate,
					"stringConventionCode"		:	codiceconv
				});	//Simone Misani 19/12/2019 END per -100
				action.setCallback(this,function(response)
				{
					var state = response.getState();
					if (state === "SUCCESS") 
					{
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams
						({
							type: "Success",
							title: $A.get("$Label.c.OB_MAINTENANCE_TOAST_OPERATIONSUCCESSFULL"),
							message: "   ",
							mode: "dismissible"
						});
						toastEvent.fire();
						location.reload(); 
						// component.set("v.disabledButtons",true);
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
								console.log("OB_Maintenance_Consistenza_ItemVasHelper.js : action : Error message: " + errors[0].message);
							}
						}
						else 
						{
							console.log("OB_Maintenance_Consistenza_ItemVasHelper.js : action : *UNKNOW ERROR*");
						}
					}
				});
				$A.enqueueAction(action);
				/*
			}
			else
			{
				console.log("@Cannot call tracking");
			}*/
		}
		catch(err) 
		{
			console.log('[EXCE] OB_Maintenance_Consistenza_ItemVasHelper.js : doInit : ' + err.message);
		} 
	},
	//START--Simone Misani Fix Tracking 20/07/2019
	saveVas : function(component,event,helper)
	{
		var listOfTerms = [];
		listOfTerms = component.get("v.configurationTerminalObject");
		var parentVas = JSON.stringify(component.get("v.disconnectedVAS"));
		console.log("@listOfTerms : " + JSON.stringify(listOfTerms));
		var action = component.get("c.getVasClone");
		action.setParams
		({
			"parentVas" : parentVas
		});
		action.setCallback(this,function(response)
		{
			var state = response.getState();
			if (state === "SUCCESS") 
			{
				var listOfVasClone = [];
				listOfVasClone = response.getReturnValue();
				console.log("@listOfVasClone : " + JSON.stringify(listOfVasClone));
				for(var vas in listOfVasClone)
				{
					helper.saveAndSetTrackingVas(component,event);
					/*
					for(var term in listOfTerms)
					{
						var currentTerm = listOfTerms[term];
						var currentVas = listOfVasClone[vas];
						if(currentVas.NE__Parent_Order_Item__c == currentTerm.Id)
						{
							console.log("@currentTerm : " + JSON.stringify(currentTerm));
							console.log("@currentVas : " + JSON.stringify(currentVas));
							helper.saveAndSetTrackingVas(component,event);
						}
					}*/
				}
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
						// console.log("OB_Maintenance_Consistenza_ItemVasHelper.js : action : Error message: " + errors[0].message);
					}
				}
				else 
				{
					console.log("OB_Maintenance_Consistenza_ItemVasHelper.js : action : *UNKNOW ERROR*");
				}
			}
		});
		$A.enqueueAction(action);
		// helper.checkDataForTracking(component,event,helper,listOfTerms);
		// helper.saveAndSetTrackingVas(component,event,helper);
	},

	saveTerminalMixedMaintenace : function(component, event,helper){
		var action = component.get("c.updateOrderItemMixedMaintenance");
			action.setParams({ 
				confId : component.get("v.confId"),
				type: 'Vas'
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
	}//END--Simone Misani Fix Tracking 20/07/2019
})