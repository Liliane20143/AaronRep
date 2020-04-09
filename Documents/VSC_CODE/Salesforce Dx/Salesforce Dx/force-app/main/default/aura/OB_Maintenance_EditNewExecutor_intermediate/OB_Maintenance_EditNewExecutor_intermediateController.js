({
	modify : function(component, event, helper) {
		component.set('v.newExecutor',false);
		component.set("v.disabled",false);  
		//helper.disableFields(component,event,helper);
		//component.set("v.status","EDIT"); 
		var switchOnload= component.get("v.switchOnload");
		component.set('v.switchOnload',!switchOnload);
		//objectDataMap.executor = JSON.parse(oldFlowdata);
		component.set("v.test", true);
		component.set("v.showModal", true);
	},

	closeModal : function(component, event, helper) 
	{
		try
		{
			var save = component.get("v.showSaveButton");
			var listEmpty = component.get("v.listEmpty");
			console.log("*******Save Button: "+save);
			console.log("*******Save Button: "+listEmpty);
			var requestID =  component.get("v.logrequestid");
			console.log('REQUEST ID IN CLOSE MODAL: ' + requestID);
			var navEvt = $A.get("e.force:navigateToSObject");
			navEvt.setParams({"recordId": requestID,"slideDevName": "detail"});
			console.log("OB_Maintenance_EditNewExecutor_intermediateController.js : navEvt : " + navEvt);
			if(save || listEmpty)
			{
				var action = component.get("c.checkOnLogRequest");
				action.setParams
				({
					"logRequestId" : requestID
				});
				action.setCallback(this, $A.getCallback(function (response) 
				{
					var state = response.getState();
					if (state === "SUCCESS") 
					{
						console.log("OB_Maintenance_EditNewExecutor_intermediateController.js : navEvt : " + navEvt);
						navEvt.fire();
					}
					else if (state === "ERROR") 
					{
						var errors = response.getError();
						console.error(errors);
					}
				}));
				$A.enqueueAction(action);
			}
			else{
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					"type": "Error",
					"mode": "dismissible",
					"message": $A.get("$Label.c.OB_MAINTENANCE_ERRORMESSAGE_DOCUMENTS"),
					"title": $A.get("$Label.c.OB_MAINTENANCE_OPERATION_FAILED")
				});
				toastEvent.fire();
			}

		}
		catch(err) 
		{
			console.log('err.message navEvt : ' + err.message);
		} 
	},

	 saveAsDraft : function(component, event, helper)
    {
    	var logId = component.get("v.logrequestid");
    	console.log("logrequestid: "+ logId);
    	try
    	{
    		var action = component.get ("c.saveDraft");
    		action.setParams({ "logId" : logId});
    		action.setCallback(this, $A.getCallback(function (response) {
    			var state = response.getState();
    			if (state === "SUCCESS") {
    				try{
    					var navEvt = $A.get("e.force:navigateToSObject");
    					navEvt.setParams({"recordId": logId,"slideDevName": "detail"});
    					console.log("OB_Maintenance_EditNewExecutor_intermediateController.js : navEvt : " + navEvt);

    					navEvt.fire();

    				}
    				catch(err){
    					console.log('err.message navEvt : ' + err.message);
    				}
    				console.log("@@@@@LOG REQUEST UPDATE");
    			} 
    			else if (state === "ERROR") {
    				var errors = response.getError();
    				console.error(errors);
    			}
    		}));
    		$A.enqueueAction(action);
    	}
    	catch(err2){
    		console.log("@@@@@LOG REQUEST not UPDATE");
    	}
    }
})