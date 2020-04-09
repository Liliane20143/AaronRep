({
	doInit: function (component, event, helper) 
		{
			console.log("@doInit of consistenza's child");
			try
			{
				var configuration = component.get("v.configuration");
				console.log("@configuration terminals: " + JSON.stringify(configuration));
				var stabSia = component.get("v.enstabilishmentSIACode");
				console.log("@enstabilishmentSIACode terminals: " + stabSia);
				var progSia = component.get("v.progressiveSIACode");
				console.log("@progressiveSIACode terminals: " + progSia);
				var siaCode = component.get("v.SIACode"); 
				console.log("@SIACode terminals: " + siaCode);
				var objectMap = component.get("v.configurationTerminalObject");
				console.log('@configurationTerminalObject' + JSON.stringify(objectMap));
				component.set("v.action",objectMap.NE__Action__c);
				
				component.set("v.startDate",objectMap.NE__StartDate__c);
				if(objectMap.OB_FulfilmentStatus__c == "Completed" || objectMap.OB_FulfilmentStatus__c == "Disconnected" || objectMap.OB_FulfilmentStatus__c == "Cancelled" || objectMap.OB_FulfilmentStatus__c == "Rejected"){
					//Simone Misani WN-484 26/09/2019 START
					var childObject = objectMap.NE__Order_Items_Conf__r.records;
					var j = 0;
					for(var i =0; i<childObject.length; i++ ){
						if(childObject[i].OB_FulfilmentStatus__c != 'Pending'){
							j++;
						}

					}
					if(childObject.length == j){
						component.set("v.isFinalStatus",true);
					}
					
				}
				//Simone Misani WN-484 26/09/2019 END
				if(objectMap.NE__Action__c == "Add")
				{	
					component.set("v.isAdd",true);
					component.set("v.requiredOnInstalled",true);
					component.set("v.setDisabledOnInstalled",true);
				}
				if(objectMap.NE__Action__c == "Remove")
				{
					component.set("v.isRemove",true);
					//component.set("v.requiredOnRejected",true);
					component.set("v.setDisabledOnUnistalled",true);
					component.set("v.setDisabledOnRejected",false);
					//01-02-2019-S.P.
					component.set("v.setDisabledOnInstalled",false);
					//01-02-2019-S.P.
				}
				if(objectMap.NE__Action__c == "None")
				{
					component.set("v.isNone",true);
				}

				//11-03-2019--S.P.--SET INSTALLATION STATUS VALUE WHEN LOG REQUEST'S STATUS IS "CONFERMATO"--START
				if(objectMap.OB_FulfilmentStatus__c == "Cancelled")
				{
					component.set("v.installationStatus","Rifiutato");
				}
				else
				{
					var installationStatusValue;
					if(objectMap.NE__StartDate__c!=null&&objectMap.NE__EndDate__c==null)
					{
						installationStatusValue = "Installato";
					}
					else if(objectMap.NE__StartDate__c==null&&objectMap.NE__EndDate__c!=null)
					{
						installationStatusValue = "Disinstallato";
					}
					component.set("v.installationStatus",installationStatusValue)
				}
				//11-03-2019--S.P.--SET INSTALLATION STATUS VALUE WHEN LOG REQUEST'S STATUS IS "CONFERMATO"--END
				console.log("@isNotAdd : " + component.get("v.isNotAdd"));
				console.log("@isNotOperation : " + component.get("v.isNotOperation"));
				var checkProfile = component.get("v.isNotOperation");
				if(checkProfile==false || configuration.OB_BankApprovalStatus__c == "In Approvazione")
				{
					component.set("v.setDisabledOnInstalled",true);
					component.set("v.setDisabledOnUnistalled",true);
					component.set("v.setDisabledOnRejected",true);
					component.set("v.requiredOnInstalled",false);
					component.set("v.requiredOnUnistalled",false);
					component.set("v.requiredOnRejected",false);
				//	component.set("v.showButtons",false);
				}
				//START francesca.ribezzi 24/06/19 - descoping-consistenza
				if(checkProfile|| configuration.OB_BankApprovalStatus__c == "In Approvazione")
				{
					component.set("v.showButtons",false);

				}
				//END francesca.ribezzi 24/06/19

				console.log("@setDisabledOnInputs : " + component.get("v.setDisabledOnInputs"));
				var listOfAttr 				= [];	
				var listOfItemsByRoot 		= [];

				console.log("@objectMap.NE__Order_Item_Attributes__r : " + JSON.stringify(objectMap.NE__Order_Item_Attributes__r));
				//ANDREA START 2019.02.21: If record' node is undefined take the attreibutes and ordItems;
				if(typeof(objectMap.NE__Order_Item_Attributes__r) !== undefined)
				{
					console.log("@objectMap.NE__Order_Item_Attributes__r : " + JSON.stringify(objectMap.NE__Order_Item_Attributes__r));
					if(typeof(objectMap.NE__Order_Item_Attributes__r.records) !== undefined )
					{
						console.log("@objectMap.NE__Order_Item_Attributes__r.records : " + JSON.stringify(objectMap.NE__Order_Item_Attributes__r.records));
						listOfAttr = objectMap.NE__Order_Item_Attributes__r.records;
					}
					else
					{
						console.log("@objectMap.NE__Order_Item_Attributes__r : " + JSON.stringify(objectMap.NE__Order_Item_Attributes__r));
						listOfAttr = objectMap.NE__Order_Item_Attributes__r;
					}
				}
				
				if(objectMap.NE__Order_Items_Conf__r != undefined) 
				{
					console.log("@Into first if");
					if(typeof(objectMap.NE__Order_Items_Conf__r.records) !== undefined)
					{
						console.log("@Into second if");
						listOfItemsByRoot 	= objectMap.NE__Order_Items_Conf__r.records;
					}
					else
					{
						listOfItemsByRoot 	= objectMap.NE__Order_Items_Conf__r;
					}
				}
				//ANDREA END 2019.02.21
				var itemId = objectMap["Id"];
				console.log("@itemId : " + itemId);

					// for(var attr in listOfAttr)
				for(var attr = 0; attr<listOfAttr.length;attr++)
				{	
					console.log("@listOfAttr["+attr+"]: " + JSON.stringify(listOfAttr[attr]));
					console.log("@" +listOfAttr[attr].Name + ": " + listOfAttr[attr].NE__Value__c);
					switch(listOfAttr[attr].Name) {
						case "Terminal Id":
								component.set("v.terminalId",listOfAttr[attr].NE__Value__c);
								console.log("sw@" +listOfAttr[attr].Name + ": " + listOfAttr[attr].NE__Value__c);
						  break;
						case "Modello":
								component.set("v.model",listOfAttr[attr].NE__Value__c);
								console.log("sw@" +listOfAttr[attr].Name + ": " + listOfAttr[attr].NE__Value__c);
						  break;
						case "Descrizione Modello":
								component.set("v.modelDesc",listOfAttr[attr].NE__Value__c);
								console.log("sw@" +listOfAttr[attr].Name + ": " + listOfAttr[attr].NE__Value__c);
						  break;
						case "Descrizione Release":
								component.set("v.releaseDesc",listOfAttr[attr].NE__Value__c);
								console.log("sw@" +listOfAttr[attr].Name + ": " + listOfAttr[attr].NE__Value__c);
							break;
						case "Descrizione Connessione":
								component.set("v.connectionDescr",listOfAttr[attr].NE__Value__c);
								console.log("sw@" +listOfAttr[attr].Name + ": " + listOfAttr[attr].NE__Value__c);
							break;
						case "Release":
								component.set("v.release",listOfAttr[attr].NE__Value__c);
								console.log("sw@" +listOfAttr[attr].Name + ": " + listOfAttr[attr].NE__Value__c);
							break;
						case "Modalità Collegamento":
								component.set("v.connectionType",listOfAttr[attr].NE__Value__c);
								console.log("sw@" +listOfAttr[attr].Name + ": " + listOfAttr[attr].NE__Value__c);
							break;
						//Andrea Saracini RAC SIA R1F2-24 bis 17/04/2019 START
						case "Codice SIA":
								component.set('v.SIACode', listOfAttr[attr].NE__Value__c);
							break;
						case "Codice Stabilimento SIA"://Andrea Saracini RAC SIA R1F2-24 bis 19/04/2019
								component.set('v.enstabilishmentSIACode', listOfAttr[attr].NE__Value__c);
							break;
						case "Progressivo SIA":
								component.set('v.progressiveSIACode', listOfAttr[attr].NE__Value__c);
							break;
						//Andrea Saracini RAC SIA R1F2-24 bis 17/04/2019 STOP
					  }
				}
				helper.setDisableRACSIA(component,component.get('v.enstabilishmentSIACode'),component.get('v.progressiveSIACode'),component.get('v.SIACode')); // antonio.vatrano 13/06/2019 ri-100
				console.log("@ATTRIBUTES : terminalId = "+component.get("v.terminalId")+" , model : "+component.get("v.model")+" , modelDesc : "+component.get("v.modelDesc")+" , releaseDesc : "+component.get("v.releaseDesc")+" , connectionDescr : "+component.get("v.connectionDescr")+" , release : "+component.get("v.release")+" , connectionType : "+component.get("v.connectionType"));
				
				if(listOfItemsByRoot!=null && listOfItemsByRoot!=undefined)
				{
					component.set("v.showEnablement",true);
					console.log("@listOfItemsByRoot : " + JSON.stringify(listOfItemsByRoot));
					var listOfEnablements = [];
					var itemRoot = {};
					// for(itemRoot in listOfItemsByRoot)
					var isNotOperation = component.get("v.isNotOperation");
					var isAdd = component.get("v.isAdd");
					for( var itemRoot = 0; itemRoot<listOfItemsByRoot.length; itemRoot++)
					{
						console.log("@hasOwnProperty itemFromRoot : " + JSON.stringify(Object.getOwnPropertyNames(listOfItemsByRoot[itemRoot])));
						console.log("@itemFromRoot : " + JSON.stringify(listOfItemsByRoot[itemRoot]));
						if(listOfItemsByRoot[itemRoot].OB_enablement__c!=null && typeof listOfItemsByRoot[itemRoot].OB_enablement__c!="undefined")
							{
								console.log("@OB_enablement__c : " + listOfItemsByRoot[itemRoot].OB_enablement__c);
								console.log("@OB_Old_Enablement__c : " + listOfItemsByRoot[itemRoot].OB_Old_Enablement__c);
								
								
								listOfItemsByRoot[itemRoot].disabledStart = true;
								listOfItemsByRoot[itemRoot].disabledEnd = true;
								listOfItemsByRoot[itemRoot].showStart = false;
								listOfItemsByRoot[itemRoot].showEnd = false;

								if(listOfItemsByRoot[itemRoot].OB_enablement__c!=listOfItemsByRoot[itemRoot].OB_Old_Enablement__c || isAdd)
								{	listOfItemsByRoot[itemRoot].showEnablement=true;
									
									if(listOfItemsByRoot[itemRoot].NE__ProdId__r.OB_Acquirer__c=='NEXI'){
										listOfItemsByRoot[itemRoot].isNexi = true;
									}

									if(listOfItemsByRoot[itemRoot].OB_enablement__c=="Y"){
										listOfItemsByRoot[itemRoot].showStart = true;
									} else{
										listOfItemsByRoot[itemRoot].showEnd = true;
									}
									//20/06/19 francesca.ribezzi changing if condition -> if(!isNotOperation)
									if(!isNotOperation){
										if(listOfItemsByRoot[itemRoot].OB_enablement__c=="Y")
										{
											listOfItemsByRoot[itemRoot].disabledStart = false;
											listOfItemsByRoot[itemRoot].disabledEnd = true;
										}
										else
										{
											listOfItemsByRoot[itemRoot].disabledStart = true;
											listOfItemsByRoot[itemRoot].disabledEnd = false;
										}
									}
									
									// listOfEnablements.push(listOfItemsByRoot[itemRoot]);
									// console.log("@currentEnablement : " + listOfItemsByRoot[itemRoot]);
								}
		
								listOfEnablements.push(listOfItemsByRoot[itemRoot]);
							}
					}
					component.set("v.enablements",listOfEnablements);
					console.log("@enablements : " + component.get("v.enablements"));
				}

			}
			catch(err) 
			{
				console.log('[EXCE] OB_Maintenance_Consistenza_ConfigurationItemController.js : doInit : ' + err.message);
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
						helper.saveTerminal(component,event,helper);
					}
				}
			}));
			$A.enqueueAction(action);   
			//END--Simone Misani Fix Tracking 20/07/2019
		},

		changeStatus : function(component,event,helper)
		{
			component.set("v.requiredOnInstalled",false);
			component.set("v.requiredOnUnistalled",false);
			component.set("v.requiredOnRejected",false);
			component.set("v.setDisabledOnInstalled",false);
			component.set("v.setDisabledOnUnistalled",false);
			component.set("v.setDisabledOnRejected",false);
			var statusValue = component.find("installationStatus").get("v.value");
			console.log("@statusValue : " + statusValue);
			if(statusValue=="Installato")
			{
				component.set("v.requiredOnInstalled",true);
				component.set("v.setDisabledOnInstalled",true);
			}
			if(statusValue=="Disinstallato")
			{
				component.set("v.requiredOnUnistalled",true);
				component.set("v.setDisabledOnUnistalled",true);
			}
			if(statusValue=="Rifiutato")
			{
				component.set("v.requiredOnRejected",true);
				component.set("v.setDisabledOnRejected",true);
			}
		}
})