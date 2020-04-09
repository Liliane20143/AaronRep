({
    saveLogNotes : function (component, event, helper)
	{
		var saveNotes = component.get("c.saveNotes");
		var logRequestId = component.get("v.recordId");
		var notes = component.get("v.notes");
            console.log('logRequestId: '+ logRequestId);
            console.log('notes: '+ notes);
			saveNotes.setParams	({
                "logRequestId": logRequestId,
                "notes": notes
            });
			saveNotes.setCallback(this,function(response)
			{
				var state = response.getState();
				if (state === "SUCCESS") 
				{
                    var saved = response.getReturnValue();
                    console.log('saved: '+ saved);
                    if(saved === true){
						console.log('savedif: '+ saved);
                        $A.get('e.force:refreshView').fire();
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                             "title": $A.get("$Label.c.OB_MAINTENANCE_TOAST_OPERATIONSUCCESSFULL"),
                             "type": "success",
                             "message":  $A.get("$Label.c.OB_MAINTENANCE_NOTES_SAVED")
                        });
                        toastEvent.fire();
                        console.log("Notes for logRequest"+ logRequest +" has been saved");
                    }else{
                        $A.get('e.force:refreshView').fire();
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": $A.get("$Label.c.OB_MAINTENANCE_OPERATION_FAILED"),
                            "type": "error",
                            "message": $A.get("$Label.c.OB_MAINTENANCE_NOTES_NOTSAVED")
                        });
                        toastEvent.fire();
                        console.log("SAVING NOTES FAILED. Notes for logRequest"+ logRequest +" has NOT been saved"); 
                    }
				}
				console.log('saved: '+ false);
            });
            $A.enqueueAction(saveNotes);
	},
	retrieveNotes : function (component, event, helper)
	{
		var retrieveLogRequest = component.get("c.retrieveLogRequest");
		var logRequestId = component.get("v.recordId");
            retrieveLogRequest.setParams
            ({
				"logRequestId": logRequestId
            });
            retrieveLogRequest.setCallback(this,function(response)
            {
                var state = response.getState();
                console.log('response@@@: '+ response.getState() )
                if (state === "SUCCESS") 
                {
                    var contextLogRequest = response.getReturnValue();
                    component.set("v.contextLogRequest", contextLogRequest);
                    var logRequest = component.get("v.contextLogRequest");
                    console.log('logRequest is: ' + JSON.stringify(logRequest));
                    component.set("v.notes",contextLogRequest.OB_Note__c);
                }else{
                    component.set("v.notes",'');
                }
            });
            $A.enqueueAction(retrieveLogRequest);
	}
})