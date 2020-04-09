({
	doInit: function (component, event, helper) {
		try {
			/****create table****/
			console.log('do init table');
			helper.hideToAdmin(component);
			var action = component.get("c.getTableInformation");
			action.setCallback(this, function (response) {
				var state = response.getState();
				console.log('state table is: ' + state);
				var OB_Status_DraftIncompleteOrder 			= $A.get("$Label.c.OB_Status_DraftIncompleteOrder"),
					OB_Status_EconomicConditionsApproval 	= $A.get("$Label.c.OB_Status_EconomicConditionsApproval"),
					OB_Status_DraftApprovedPricing 			= $A.get("$Label.c.OB_Status_DraftApprovedPricing"),
					OB_Status_DraftRejectedPricing 			= $A.get("$Label.c.OB_Status_DraftRejectedPricing"),
					OB_Status_MissingInformation 			= $A.get("$Label.c.OB_Status_MissingInformation"),
					OB_Status_RifiutatoDaRisottomettere 	= $A.get("$Label.c.OB_Status_RifiutatoDaRisottomettere"),
					OB_Status_OrderToBeCompleted 			= $A.get("$Label.c.OB_Status_OrderToBeCompleted"),
					OB_Status_BankVerification				= $A.get("$Label.c.OB_Status_BankVerification"),
					OB_Status_PrintedQuote					= $A.get("$Label.c.OB_Status_PrintedQuote"); //gianluigi.virga 23/09/2019 - added 'Print quote' status
				var mapLabels ={};
				var listLabel =[];
				listLabel.push(OB_Status_DraftIncompleteOrder,OB_Status_EconomicConditionsApproval,OB_Status_DraftApprovedPricing,OB_Status_DraftRejectedPricing,OB_Status_MissingInformation,OB_Status_RifiutatoDaRisottomettere,OB_Status_OrderToBeCompleted,OB_Status_BankVerification,OB_Status_PrintedQuote); //gianluigi.virga 23/09/2019 - added 'OB_Status_PrintedQuote' label
				console.log('list label: ' , listLabel);
				for(var label in listLabel){
					
					var singleLabel = listLabel[label];
					console.log('label: ' + singleLabel);
					mapLabels[singleLabel.split('_')[0]] = singleLabel.split('_')[1];

				}
				console.log('mapLabels: ' , mapLabels);
 




				if (state === "SUCCESS") {
					// alert();
					/*
					OB_Setup_ManagedPractices
     				 OB_Maintenance_ManagedPractices
					*/
					var setup = $A.get("$Label.c.OB_Setup_ManagedPractices");
					var maintenance = $A.get("$Label.c.OB_Maintenance_ManagedPractices");
					console.log("From server: " , response.getReturnValue());
					var tables=[];
					var setupInfo = [];
					var maintenanceInfo = [];
					response = response.getReturnValue();
					for(var key in response){
						console.log('key: ' , key);
						console.log('value: ' , response[key]);
						var values = response[key];
						if(key==setup){
							
							for(var childValue in values){
								console.log('childValue: ' + childValue);
								console.log('values: ' + values[childValue]);
								setupInfo.push({	nameStatus: childValue.split('||')[0],
													valueStatus:childValue.split('||')[1],
													tooltip : mapLabels[childValue.split('||')[1]],
													orderType:'InOrder',
													quantity: values[childValue]
												}) 
							}
						}
						if(key==maintenance){
							
							for(var childValue in values){
								console.log('childValue: ' + childValue);
								console.log('values: ' + values[childValue]);
								maintenanceInfo.push({	nameStatus: childValue.split('||')[0],
														valueStatus:childValue.split('||')[1],
														tooltip : mapLabels[childValue.split('||')[1]],
														orderType:'ChangeOrder',
														quantity: values[childValue]
													}) 
							}
						}
						//sort name status
						setupInfo.sort(function(a, b){
							return a.nameStatus == b.nameStatus ? 0 : +(a.nameStatus > b.nameStatus) || -1;
						});
						maintenanceInfo.sort(function(a, b){
							return a.nameStatus == b.nameStatus ? 0 : +(a.nameStatus > b.nameStatus) || -1;
						});
						//CREATE TABLE TO ITERATE
						tables.push({	tableName 		:	key,
										info			:	key ==setup?setupInfo: maintenanceInfo
										});
					}
					console.log('setupInfo' , setupInfo);
					console.log('maintenanceInfo' , maintenanceInfo);
					component.set('v.tableInformationList' , tables);
					
					console.log('map saved: '+  JSON.stringify(component.get('v.tableInformationList')));
					console.log('tables : ',tables);

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
				}
			});
			$A.enqueueAction(action);
			/****get current url****/
			var getBaseURL = component.get("c.getBaseURl");
			getBaseURL.setCallback(this, function (response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					var myBaseURL = response.getReturnValue();
					component.set("v.myBaseURL", myBaseURL);
					console.log('myBaseURL: ' + myBaseURL);

				}
				else if (state === "ERROR") {
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							console.log("Error message: " +
								errors[0].message);
						}
					}
					else {
						console.log("Unknown error");
					}
				}
			});

			$A.enqueueAction(getBaseURL);
		} catch (err) {
			console.log('doInit error: '+err.message);
		}

	},
	fireAction : function(component, event, helper){
		helper.fireAction_Helper(component, event, helper);
		
		
	}
})