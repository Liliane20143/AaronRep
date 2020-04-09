({
	doInit : function(component, event, helper) 
	{
		try
		{
			console.log("@Into doInit of item vas");
			var configuration = component.get("v.configuration");
			console.log("@configuration vas: " + JSON.stringify(configuration));
			console.log("@enstabilishmentSIACode vas: " + component.get("v.enstabilishmentSIACode"));
			console.log("@progressiveSIACode vas: " + component.get("v.progressiveSIACode"));
			console.log("@SIACode vas: " + component.get("v.SIACode"));
			var item = component.get("v.disconnectedVAS");
			if(!$A.util.isEmpty(item.OB_Conventioncode__c)){
				component.set('v.isdisabledVas', true);
			}
			
			var terminals = component.get("v.configurationTerminalObject");
			console.log("@configurationTerminalObject : " + JSON.stringify(terminals));
			console.log("@item vas : " + JSON.stringify(item));
			console.log("@isNotOperation vas : " + component.get("v.isNotOperation"));

			if(configuration.OB_BankApprovalStatus__c == "In Approvazione")
			{
				component.set("v.isInApprovation",false);
			}
			else
			{
				component.set("v.isInApprovation",true);
			}

			if(item.OB_FulfilmentStatus__c == "Completed" || item.OB_FulfilmentStatus__c == "Disconnected" || item.OB_FulfilmentStatus__c == "Cancelled" || item.OB_FulfilmentStatus__c == "Rejected"){
				component.set("v.isFinalStatus",true);
			}

			if(item.NE__Action__c=='Remove')
			var startDate 	= "";
			var endDate 	= "";
			var circuitName = "";
			if(item!=null)
			{
				startDate 	= item.NE__StartDate__c;
				endDate 	= item.NE__EndDate__c;
				circuitName = item.NE__ProdId__r.Name;
			}
			console.log("@startDate : " + startDate);
			console.log("@endDate : " + endDate);
			console.log("@circuitName : " + circuitName);

			component.set("v.startDateVas",startDate);
			component.set("v.endDateVas",endDate);
			component.set("v.circuitNameVas",circuitName);

			// var currentTerm;
			// var listOfAttributes = [];

			// for(var term = 0;term < terminals.length;term++)
			// {
			// 	if(typeof(terminals[term].NE__Order_Item_Attributes__r)!=undefined&&terminals[term].NE__Order_Item_Attributes__r!=null)
			// 	{
			// 		if(terminals[term].Id == item.NE__Parent_Order_Item__c)
			// 		{
			// 			currentTerm = terminals[term];
			// 			listOfAttributes.push(terminals[term].NE__Order_Item_Attributes__r.records)
			// 		}
			// 	}
			// }
			// component.set("v.currentTerm",currentTerm);
			// console.log("@currentTerm vas : " + JSON.stringify(component.get("v.currentTerm")));
			// console.log("@listOfAttributes vas : " + JSON.stringify(listOfAttributes));
			
			// for(var attr=0;attr < listOfAttributes.length;attr++)
			// {
			// 	for(var i=0;i<listOfAttributes[attr].length;i++)
			// 	{
			// 		console.log("@attr vas : " + JSON.stringify(listOfAttributes[attr][i]));
			// 		if(listOfAttributes[attr][i].Name == "Terminal Id")
			// 		{
			// 			component.set("v.terminalId",listOfAttributes[attr][i].NE__Value__c);
			// 			console.log("@terminalId vas : " + JSON.stringify(listOfAttributes[attr][i]));
			// 		}
			// 		else if(listOfAttributes[attr][i].Name == "Modello")
			// 		{
			// 			component.set("v.model",listOfAttributes[attr][i].NE__Value__c);
			// 			console.log("@Modello vas : " + JSON.stringify(listOfAttributes[attr][i]));
			// 		}
			// 		else if(listOfAttributes[attr][i].Name == "Descrizione Modello")
			// 		{
			// 			component.set("v.modelDesc",listOfAttributes[attr][i].NE__Value__c);
			// 			console.log("@modelDesc vas : " + JSON.stringify(listOfAttributes[attr][i]));
			// 		}
			// 		else if(listOfAttributes[attr][i].Name == "Descrizione Release")
			// 		{
			// 			component.set("v.releaseDesc",listOfAttributes[attr][i].NE__Value__c);
			// 			console.log("@releaseDesc vas : " + JSON.stringify(listOfAttributes[attr][i]));
			// 		}
			// 		else if(listOfAttributes[attr][i].Name == "Descrizione Connessione")
			// 		{
			// 			component.set("v.connectionDescr",listOfAttributes[attr][i].NE__Value__c);
			// 			console.log("@connectionDescr vas : " + JSON.stringify(listOfAttributes[attr][i]));
			// 		}
			// 		else if(listOfAttributes[attr][i].Name == "Release")
			// 		{
			// 			component.set("v.release",listOfAttributes[attr][i].NE__Value__c);
			// 			console.log("@release vas : " + JSON.stringify(listOfAttributes[attr][i]));
			// 		}
			// 		else if(listOfAttributes[attr][i].Name == "ModalitàCollegamento")
			// 		{
			// 			component.set("v.connectionType",listOfAttributes[attr][i].NE__Value__c);
			// 			console.log("@connectionType vas : " + JSON.stringify(listOfAttributes[attr][i]));
			// 		}
			// 	}
			// }
		}
		catch(err) 
		{
			console.log('[EXCE] OB_Maintenance_Consistenza_ItemVasController.js : doInit : ' + err.message + ' at line '+err.lineNumber);
		} 
	},

	save : function(component,event,helper)
		{
			//START--Simone Misani Fix Tracking 20/07/2019
			var action = component.get('c.verifyMixedLogrequest');
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
						helper.saveVas(component,event,helper);
					}
				}
			}));
			$A.enqueueAction(action);   
	
		},//END--Simone Misani Fix Tracking 20/07/2019
})