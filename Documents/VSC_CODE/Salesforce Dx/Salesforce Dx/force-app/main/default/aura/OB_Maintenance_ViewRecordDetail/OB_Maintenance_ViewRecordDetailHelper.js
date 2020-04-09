({

	checkDraft : function (component, event, helper, recordId){
		console.log("@@@ in checkDraft");
		var action = component.get("c.retrieveStatus");
		action.setParams({
			"logrequestId": recordId,
		});
		action.setCallback(this, function(response)
		{
			var state = response.getState();
			if (state === "SUCCESS") 
			{
				var status = response.getReturnValue();
				console.log('@@@@@RESPONSE Status '+response.getReturnValue());
				console.log("@@@@Label: "+$A.get("$Label.c.OB_MAINTENANCE_LOGREQUEST_STATUS_DRAFT"));
				if(status == $A.get("$Label.c.OB_MAINTENANCE_LOGREQUEST_STATUS_DRAFT")){
					console.log("@@@@@isDraft");
					component.set('v.isDraft', true);
				}
				
			} 
			else if (state === "INCOMPLETE")
			{
				 /* do something */
			}
			else if (state === "ERROR")
			{
				var errors = response.getError();
				if (errors) 
				{
					if (errors[0] && errors[0].message) 
					{
						console.log("Error message: " + errors[0].message);
					}
					else 
					{
						console.log("Unknown error");
					}
				}
			}
		});
		$A.enqueueAction(action);
	},

	editStatus : function (component, event, helper, recordId)
	{
		console.log("@@@ in editStatus");
		// var action = component.get("c.editLogStatus");

		// 22-02-2019-S.P.-CHECKS FOR ACQUIRING
		var action = component.get("c.checkOnLogRequest");
		action.setParams
		({
			"logRequestId": recordId
		});
		action.setCallback(this, function(response){
			var state = response.getState();
			if (state === "SUCCESS") 
			{
				console.log("@@@@@EDIT STATUS DONE");
				//START - 2019/05/08 - salvatore.pianrua- Maitnenance Anagrafica Integration
				var submitAction = component.get("c.updateRequest");
				var logRequest = component.get("v.logRequest");
				submitAction.setParams
				({
					"logRequest": logRequest
				});
				submitAction.setCallback(this, function(response)
				{
					var stateSubmit = response.getState();
					if(stateSubmit === "SUCCESS")
					{
						$A.get("e.force:refreshView").fire();
					}
					else if(stateSubmit === "INCOMPLETE")
					{
						//do nothing
					}
					else if(stateSubmit === "ERROR")
					{
						var errorsSubmit = response.getError();
						if (errorsSubmit) 
						{
							if (errorsSubmit[0] && errorsSubmit[0].message) 
							{
								console.log("Error message: " + errorsSubmit[0].message);
							}
						}
						else
						{
							console.log("Unknown error");
						}
					}
				});
				$A.enqueueAction(submitAction);
				//END - 2019/05/08 - salvatore.pianrua- Maitnenance Anagrafica Integration
			} 
			else if (state === "INCOMPLETE"){ /* do something */}
			else if (state === "ERROR"){
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log("Error message: " + errors[0].message);
					}
				} 
				else 
				{
					console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(action);
	},

	checkProfileLogReqDraft : function (component, event, helper, recordId){
		console.log("@@@ in checkProfileLogReqDraft");
		var action = component.get("c.checkProfilesDraft");
		action.setParams({
			"logRequestId": recordId,
		});
		action.setCallback(this, function(response){
			var state = response.getState();
			if (state === "SUCCESS") 
			{
				var bool = response.getReturnValue();
				console.log('@@@@@RESPONSE boolean Profile '+response.getReturnValue());

				
				
					console.log("@@@@@ isProfCom");
					component.set('v.isProfCom', bool);
				
				
			} 
			else if (state === "INCOMPLETE"){ /* do something */}
			else if (state === "ERROR"){
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log("Error message: " + errors[0].message);
					}
				} 
				else 
				{
					console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(action);
	},

	// START DG - 09/02/2019 - 1316
	getBaseUrl : function(component, event, helper){
		console.log("@@@@ In getBaseUrl");
		var stringUrl = component.get("c.getStringUrl");
		
		stringUrl.setCallback(this, function(response){
			var state = response.getState();
			if (state === "SUCCESS") 
			{
				var status = response.getReturnValue();
				console.log('@@@@@RESPONSE Status ' + status);
				component.set('v.pageUrl', status);
				
			} 
			else if (state === "INCOMPLETE"){ /* do something */}
			else if (state === "ERROR"){
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log("Error message: " + errors[0].message);
					}
				} 
				else 
				{
					console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(stringUrl);
	}

	// END DG - 09/02/2019 - 1316

	//	START	micol.ferrari 07/02/2019 - #00001298 - EVERY PROFILE MUST SEE THE ORDER ID
	// isOrderDetailsVisible : function (component, event, helper, recordId){
	// 	console.log("@@@ in checkProfileLogReq");
	// 	var action = component.get("c.checkOrderDetailsVisibility");
	// 	action.setParams({
	// 		"logRequestId": recordId
	// 	});
	// 	action.setCallback(this, function(response){
	// 		var state = response.getState();
	// 		if (state === "SUCCESS") 
	// 		{
	// 			var bool = response.getReturnValue();
	// 			console.log('@@@@@RESPONSE boolean Profile for Order Details '+response.getReturnValue());

				
				
	// 				console.log("@@@@@ isProfForOrderDetails");
	// 				component.set('v.isProfForOrderDetails', bool);
				
				
	// 		} 
	// 		else if (state === "INCOMPLETE"){ /* do something */}
	// 		else if (state === "ERROR"){
	// 			var errors = response.getError();
	// 			if (errors) {
	// 				if (errors[0] && errors[0].message) {
	// 					console.log("Error message: " + errors[0].message);
	// 				}
	// 			} 
	// 			else 
	// 			{
	// 				console.log("Unknown error");
	// 			}
	// 		}
	// 	});
	// 	$A.enqueueAction(action);
	// }
	//	END		micol.ferrari 07/02/2019 - #00001298 - EVERY PROFILE MUST SEE THE ORDER ID



})