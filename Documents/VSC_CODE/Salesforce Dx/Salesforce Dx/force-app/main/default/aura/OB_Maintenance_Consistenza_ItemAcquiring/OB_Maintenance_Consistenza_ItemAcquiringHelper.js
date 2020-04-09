({
	saveAndTrackingAcquiring : function(component,event,helper) 
	{
		try
		{
			console.log("@ItemAcquiringHelper : saveAndTrackingAcquiring");
			// INSTANCE PARAMETER OBJECT FOR TRACKING REQUEST ACQUIRING
			var isVisaMast = component.get("v.isVisaMast");
			var action = component.get("v.configurationACQUIRINGItems.NE__Action__c");
			var comp 		= component.find("startDateAcq");
			var startDateAcq = (comp!= undefined ? comp.get("v.value"): component.get("v.configurationACQUIRINGItems.NE__StartDate__c"));

			console.log("@stringStartDate : " + startDateAcq);
			var stringStartDate;
			if(startDateAcq != null)
			{
				//11-03-2019--S.P.--IF THE DATE VALUE IS A TYPE DATATIME GET THE SUBSTRING WHIT OBLY THE DATE--START
				if(startDateAcq.includes("T"))
				{
					stringStartDate = startDateAcq.substring(0,startDateAcq.indexOf("T"));
				}
				//11-03-2019--S.P.--IF THE DATE VALUE IS A TYPE DATATIME GET THE SUBSTRING WHIT OBLY THE DATE--END
				else
				{
					stringStartDate =  startDateAcq;
				}
			}
			console.log("@stringStartDate : " + stringStartDate);

			comp 			= component.find("endDateAcq");
			var endDateAcq 	= (comp!= undefined ? comp.get("v.value"): component.get("v.configurationACQUIRINGItems.NE__EndDate__c"));

			var stringEndDate ;
			if(endDateAcq != null)
			{
				//11-03-2019--S.P.--IF THE DATE VALUE IS A TYPE DATATIME GET THE SUBSTRING WHIT OBLY THE DATE--START
				if(endDateAcq.includes("T"))
				{
					stringEndDate = endDateAcq.substring(0,endDateAcq.indexOf("T"));
				}
				//11-03-2019--S.P.--IF THE DATE VALUE IS A TYPE DATATIME GET THE SUBSTRING WHIT OBLY THE DATE--END
				else
				{
					stringEndDate = endDateAcq;
				}
			}
			console.log("@stringEndDate : " + stringEndDate);

			var wrapperPar = {};
			var isMisingMandatoryData			= false;
			comp 								= component.get("v.configuration");

			wrapperPar.idOrdineSfdc 			= (comp!= undefined ? comp.Id : null);
			wrapperPar.codiceCTI				= (comp!= undefined ? comp.OB_CTI_Code__c : null);

			comp 								= component.get("v.configurationACQUIRINGItems");
			wrapperPar.sistemaSorgente			= (comp!= undefined ? comp.OB_Processor__c : null);
			wrapperPar.tipo						= (comp!= undefined ? comp.OB_ServicePointType__c : null);
			wrapperPar.itemId					= (comp!= undefined ? comp.Id : null);
			wrapperPar.codiceStabilimento		= (comp!= undefined ? comp.OB_ShopCode__c : null);
			wrapperPar.acquirerType				= (comp!= undefined ? comp.NE__ProdId__r.OB_Acquirer__c: null);
			wrapperPar.action					= (comp!= undefined ? comp.NE__Action__c: null);

			comp 								= component.find("companyCode");
			//01-03-2019-S.P.
			if(comp!= undefined)
			{
				wrapperPar.codiceSocieta = comp.get("v.value");
			}
			else
			{
				wrapperPar.codiceSocieta = component.get("v.companyCode");
			}
			// wrapperPar.codiceSocieta			= (comp!= undefined ? comp.get("v.value") : null);// component.get("v.configurationACQUIRINGItems").OB_CompanyCode__c;
			//01-03-2019-S.P.
			isMisingMandatoryData = isMisingMandatoryData || (isVisaMast && $A.util.isEmpty(wrapperPar.codiceSocieta));

			comp 								= component.find("servicePointCode");
			//01-03-2019-S.P.
			if(comp!= undefined)
			{
				wrapperPar.codicePuntoVendita = comp.get("v.value");
			}
			else
			{
				wrapperPar.codicePuntoVendita = component.get("v.servicePointCode");
			}
			// wrapperPar.codicePuntoVendita		= (comp!= undefined ? comp.get("v.value") : null);
			//01-03-2019-S.P.
			isMisingMandatoryData = isMisingMandatoryData || (isVisaMast && $A.util.isEmpty(wrapperPar.codicePuntoVendita));
			

			wrapperPar.codiceStabilimentoSIA	= component.get("v.enstabilishmentSIACode");
			wrapperPar.codiceProgressivoSIA		= component.get("v.progressiveSIACode");
			wrapperPar.codiceSIA				= component.get("v.SIACode");

			wrapperPar.dataInizioAcq			= stringStartDate;			
			isMisingMandatoryData = isMisingMandatoryData || (isVisaMast && action =='Add' && $A.util.isEmpty(stringStartDate));
			
			wrapperPar.dataCessazioneAcq		= stringEndDate;
			isMisingMandatoryData = isMisingMandatoryData || (isVisaMast && action =='Remove' && $A.util.isEmpty(stringEndDate));
			
			wrapperPar.causaleCessazioneAcq		= "";

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


			console.log("@wrapper acquiring : " + JSON.stringify(wrapperPar));
			var action = component.get("c.saveAndSetTrackingAcquiring");
			action.setParams
			({
				"wrapperPar" : wrapperPar
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
							// console.log("OB_Maintenance_Consistenza_ItemAcquiringHelper.js : action : Error message: " + errors[0].message);
						}
					}
					else 
					{
						console.log("OB_Maintenance_Consistenza_ItemAcquiringHelper.js : action : *UNKNOW ERROR*");
					}
				}
			});
			$A.enqueueAction(action);
		}
		catch(err) 
		{
			console.log('[EXCE] OB_Maintenance_Consistenza_ItemAcquiringHelper.js : action : ' + err.message);
		} 
	},
	//START--Simone Misani Fix Tracking 20/07/2019
	saveTerminalMixedMaintenace : function(component, event,helper){
		var action = component.get("c.updateOrderItemMixedMaintenance");
			action.setParams({ 
				confId : component.get("v.confId"),
				type : 'Acquiring'
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
	},
	
	mixedLogrequest: function(component, event, helper){
		var action = component.get("c.verifyMixedLogrequest");
			action.setParams({ 
				confId : component.get("v.confId")
			});
			action.setCallback(this, $A.getCallback(function (response) {
				var state = response.getState();
				if (state === "SUCCESS") 
				{
					var valueReturns = response.getReturnValue();
					if(valueReturns){
						helper.saveTerminalMixedMaintenace(component, event,helper);
					}else{
						helper.saveAndTrackingAcquiring(component,event,helper);(component,event,helper);
					}
				}
			}));
			$A.enqueueAction(action);   
	}
		//END--Simone Misani Fix Tracking 20/07/2019
})