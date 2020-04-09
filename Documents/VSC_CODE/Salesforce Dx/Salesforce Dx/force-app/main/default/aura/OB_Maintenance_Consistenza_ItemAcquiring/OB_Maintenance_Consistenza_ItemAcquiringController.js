({
	doInit : function(component, event, helper) 
	{
		console.log("@doInit of consistenza's child acquiring");
		var configuration = component.get("v.configuration");
		console.log("@configuration acquiring: " + JSON.stringify(configuration));
		console.log("@enstabilishmentSIACode acquiring: " + component.get("v.enstabilishmentSIACode"));
		console.log("@progressiveSIACode acquiring: " + component.get("v.progressiveSIACode"));
		console.log("@SIACode acquiring: " + component.get("v.SIACode"));
		var item = component.get("v.configurationACQUIRINGItems");
		var action = item.NE__Action__c;
		component.set("v.action",action);
		var circuitNameAcq = item.NE__ProdId__r.Name;
		component.set("v.circuitNameAcq",circuitNameAcq);
		console.log("@item acquiring : " + JSON.stringify(item));
		component.set("v.confItemId",item.Id);
		component.set("v.startDateAcq",item.NE__StartDate__c);
		component.set("v.endDateAcq",item.NE__EndDate__c);
		console.log("@isNotOperation acquiring: " + component.get("v.isNotOperation"));
		console.log("@isNotIntegrated acquiring: " + component.get("v.isNotIntegrated"));

		if(configuration.OB_BankApprovalStatus == "In Approvazione")
		{
			component.set("v.isInApprovation",false);
		}
		else
		{
			component.set("v.isInApprovation",true);
		}
		console.log("@isInApprovation : " + component.get("v.isInApprovation"));
		
		if(item.NE__ProdId__r.Name == "Visa/Mastercard" && item.NE__Action__c=='Add'){
			component.set("v.isVisaMast",true);
			console.log("@Is Visa/Mastercard");
		}

		if(item.OB_FulfilmentStatus__c == "Completed" || item.OB_FulfilmentStatus__c == "Disconnected" || item.OB_FulfilmentStatus__c == "Cancelled" || item.OB_FulfilmentStatus__c == "Rejected"){
			component.set("v.isFinalStatus",true);
		}

		if(item.NE__ProdId__r.OB_Acquirer__c == "NEXI")
		{
			
			console.log("@Is NEXI");
			console.log("@CompanyCode : " + item.OB_CompanyCode__c);
			console.log("@ServicePointCode : " + item.OB_ServicePointCode__c);

			// component.set("v.isVisaMast",true);
			component.set("v.isNexi",true);
			component.set("v.companyCode",item.OB_CompanyCode__c);
			component.set("v.servicePointCode",item.OB_ServicePointCode__c);
		}
		else
		{
			component.set("v.isNotNexi",false);
			//elena.preteni 24/12/2019 R1P-349 add codicePuntoVendita
			component.set("v.servicePointCode",item.OB_ServicePointCode__c);
			//elena.preteni 24/12/2019 R1P-349 add codicePuntoVendita
			
		}

		// var prod = item.NE__ProdId__r.Name;
		// if(prod=="AMEX")
		// {
		// 	component.set("v.isAmex",true);
		// }
		// if(prod == "DINERS")
		// {
		// 	component.set("v.isDiners",true);
		// }
		// console.log("@isAmex : " + component.get("v.isAmex"));
		// console.log("@isDiners : " + component.get("v.isDiners"));
	},
	
	save : function(component,event,helper)
	{	
		startComp = component.find("startDateAcq");
		endComp = component.find("endDateAcq");

		var endDate	= (endComp!= undefined ? endComp.get("v.value"): component.get("v.configurationACQUIRINGItems.NE__EndDate__c"));
		var startDate = (startComp!= undefined ? startComp.get("v.value"): component.get("v.configurationACQUIRINGItems.NE__StartDate__c"));
		var actionAcquaring = component.get("v.configurationACQUIRINGItems.NE__Action__c");
		var errorField = "";
		var productName = component.get("v.circuitNameAcq");
		if	((actionAcquaring == "Add" && (startDate == undefined || startDate == null || startDate == '')) || 
			(actionAcquaring == "Remove" && (endDate == undefined || endDate == null || endDate == '')))
		{
			if(startDate == undefined || startDate == null || startDate == ''){
				errorField = " " + productName + ": Data Inizio Validità";

			}if (endDate == undefined ||  endDate == null || endDate == ''){
				errorField =  " " + productName + ": Data Fine Validità";
			}
			var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams
					({
						type: "Error",
						title: "Error",
						message: $A.get("$Label.c.OB_Missing_Data") + errorField,
						mode: "dismissible"
					});
					toastEvent.fire();
		}else{
			//START--Simone Misani Fix Tracking 20/07/2019
			helper.mixedLogrequest(component, event, helper); 
			// var action = component.get("c.verifyMixedLogrequest");
			// action.setParams({ 
			// 	confId : component.get("v.confId")
			// });
			// action.setCallback(this, $A.getCallback(function (response) {
			// 	var state = response.getState();
			// 	if (state === "SUCCESS") 
			// 	{
			// 		var valueReturns = response.getReturnValue();
			// 		if(valueReturns){
			// 			helper.saveTerminalMixedMaintenace(component, event,helper);
			// 		}else{
			// 			helper.saveAndTrackingAcquiring(component,event,helper);(component,event,helper);
			// 		}
			// 	}
			// }));
			// $A.enqueueAction(action);   
	
		//END--Simone Misani Fix Tracking 20/07/2019	
		}
	}
})