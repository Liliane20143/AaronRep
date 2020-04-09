({
	init : function(component, event, helper) {
		console.log('RECORD ID IN INIT VIEW REQUEST: ' + component.get('v.recordId'));
		helper.doInit(component, event, helper);
	},
	confirmReject : function(component, event, helper){
		helper.rejectLogRequest(component, event, helper);
		//	START 	micol.ferrari 31/01/2019 - MAIN_85_R1F1_NICE_TO_HAVE
		$A.get('e.force:refreshView').fire();
		//	END 	micol.ferrari 31/01/2019 - MAIN_85_R1F1_NICE_TO_HAVE
	},

	isRefreshed: function(component, event, helper) {
        location.reload();
    },

	fieldChanged : function(component, event, helper){
		var target = event.getSource();
		var whichOne = target.getLocalId();
		var inputField = component.find(whichOne);
		var value = inputField.get("v.validity");
		var button = component.find ("finalReject");
		console.log(value.valid);
		if( value.valid){
			component.set("v.rejectreason",inputField.get("v.value"));
			button.set('v.disabled',false);
		}
		else{
			component.set("v.rejectreason","");
			button.set('v.disabled',true);
		}
	},

	confirmRequestSia : function(component,event,helper)
	{
		var logRequest = component.get("v.currentLogRequest");
		var action = component.get("c.updateRequestSia");
		action.setParams
		({
			"logRequest" : logRequest
		});
		action.setCallback(this, function(response){
			var state = response.getState();
			if (state === "SUCCESS") 
			{
				var outcome = response.getReturnValue();
				console.log("confirmRequestSia outcome: "+outcome);
				location.reload(); 
			} 
			else if (state === "INCOMPLETE")
			{
				//do something
			}
			else if (state === "ERROR") 
			{
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) 
					{
						console.log("Error message: " + 
						errors[0].message);
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

	confirmRequestEwMonetica : function(component,event,helper)
	{
		var logRequest = component.get("v.currentLogRequest");
		var action = component.get("c.updateRequestEwMonetica");
		action.setParams
		({
			"logRequest" : logRequest
		});
		action.setCallback(this, function(response)
		{
			var state = response.getState();
			if (state === "SUCCESS") 
			{
				var outcome = response.getReturnValue();
				console.log("confirmRequestEwMonetica outcome: "+outcome);
				location.reload(); 
			} 
			else if (state === "INCOMPLETE")
			{
			}
			else if (state === "ERROR") 
			{
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) 
					{
						console.log("Error message: " + 
							errors[0].message);
					}
				} 
				else 
				{
					console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(action);
	}
})