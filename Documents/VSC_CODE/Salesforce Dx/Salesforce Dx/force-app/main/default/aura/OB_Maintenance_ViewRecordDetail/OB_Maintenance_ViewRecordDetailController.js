({
	doInit : function(component, event, helper) 
	{
		
		var recordId = component.get('v.recordId');
		console.log(component.get('v.recordId.OB_ChangeLegalRepresentative__c'));
		console.log("°°°°°°°°°°°°°°°°°°°"+recordId);
		var action = component.get("c.retrieveLogRequestServer");
		action.setParams({
			"logrequestId": recordId
		});
		action.setCallback(this, function(response){
			var state = response.getState();
			if (state === "SUCCESS") 
			{
				var logRequestResult = response.getReturnValue();
				console.log('@@@@@RESPONSE is:  ' + JSON.stringify(logRequestResult) );
				var JSONlogRequest = {};
				JSONlogRequest = logRequestResult;
				if(typeof(JSONlogRequest) != undefined && JSONlogRequest != null) {
					
					var resubmitBoolean = JSONlogRequest.resubmitBoolean;
					console.log('resubmitBoolean is: ' + resubmitBoolean);
					component.set('v.showButton', resubmitBoolean);
					component.set("v.logRequest", JSONlogRequest.logRequest );
					component.set("v.isConfirmButton", JSONlogRequest.isConfirmButton );//NEXI-33 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 14/05/2019
					component.set('v.isTEEdit', JSONlogRequest.logRequest['OB_Change_of_data_of_beneficial_owners__c']); //NEXI-156 Wojciech Kucharek<wojciech.kucharek@accenture.com>
				}
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
		helper.checkDraft(component, event, helper, recordId);
		helper.checkProfileLogReqDraft(component, event, helper, recordId);
		helper.getBaseUrl(component, event, helper);
		
		//	START	micol.ferrari 07/02/2019 - #00001298 - EVERY PROFILE MUST SEE THE ORDER ID
		//helper.isOrderDetailsVisible(component, event, helper, recordId);
		//	END		micol.ferrari 07/02/2019 - #00001298 - EVERY PROFILE MUST SEE THE ORDER ID
	},


	clickResubmit : function(component, event, helper){

		var recordId = component.get('v.recordId');
		console.log("°°°°°°°°°°°°°°°°°°°"+recordId);
		var action = component.get("c.inApprovalProcess");
		action.setParams({
			"logrequestId": recordId,
		});
		action.setCallback(this, function(response){
			var state = response.getState();
			if (state === "SUCCESS") 
			{
				console.log('@@@@@RESPONSE IN ApprovalProcess');
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					type: "Success",
					title: $A.get("$Label.c.OB_MAINTENANCE_TOAST_OPERATIONSUCCESSFULL"),
					message: $A.get("$Label.c.OB_MAINTENANCE_SUCCESSRESUBMITAPPROVALPROCESS"),
					mode: "dismissible"
				});
				toastEvent.fire();

				var button = event.getSource();
				button.set('v.disabled',true);
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



	showDocs : function (component, event, helper){
		var isDraft = component.get("v.isDraft");
		if (isDraft == true){
			component.set("v.showModalDocuments", true);
		}
	},

	hideDocs : function (component, event, helper){
		var isDraft = component.get("v.isDraft");
		if (isDraft == true){
			component.set("v.showModalDocuments", false);
		}
	},

	save : function (component, event, helper){
		try
		{
			var canSave = component.get("v.showSaveButton");
			var listEmpty = component.get("v.listEmpty");
			let isTEEdit = component.get("v.isTEEdit"); //NEXI-156 Wojciech Kucharek<wojciech.kucharek@accenture.com> 05/07/2019
       		console.log("*******Save Button: "+canSave);
       		console.log("*******Save Button: "+listEmpty);

			var requestID =  component.get("v.recordId");
			console.log('REQUEST ID IN CLOSE MODAL: ' + requestID);
			if (canSave || listEmpty){
				//NEXI-156 Wojciech Kucharek<wojciech.kucharek@accenture.com> 05/07/2019 Start
                if(isTEEdit)
                {
                    let navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams
                    ({
                        "recordId" : requestID,
                        "slideDevName" : "detail"
                    });

                    let action = component.get('c.startApprovalProcess');
                    action.setParam("logRequestId" , requestID);
                    action.setCallback(this, $A.getCallback(function (response)
                    {
                        let state = response.getState();
                        if (state !== "SUCCESS")
                        {
                            this.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"), $A.get("$Label.c.OB_ServerLogicFailed"), 'error');
                            return;
                        }
                        navEvt.fire();
                    }));
                    $A.enqueueAction(action);
                    return;
                }
                //NEXI-156 Wojciech Kucharek<wojciech.kucharek@accenture.com> 05/07/2019 Stop
                helper.editStatus(component, event, helper, requestID);
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

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 14/05/2019
    * @description Method update log request status
    */
	updateLogStatus : function(component, event, helper)
	{
	    // NEXI-97 Marta Stempien <marta.stempien@accenture.com>, 12/06/2019
        // deleted conditions for required fields to update LogRequest
        let logRequest = component.get("v.logRequest");
	    let action = component.get("c.confirmLogRequest");
        action.setParams
        ({
            "inLogRequestId": logRequest.Id
        });
        action.setCallback(this, function(response)
        {
            let state = response.getState();
            if (state === "SUCCESS")
            {
                let confirmResult = response.getReturnValue();
                if(String(confirmResult) == 'false')
                {
                    let toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams
                    ({
                        "type": "Error",
                        "mode": "dismissible",
                        "message": $A.get("$Label.c.OB_ServerLogicFailed"),
                        "title": $A.get("$Label.c.OB_MAINTENANCE_OPERATION_FAILED")
                    });
                    toastEvent.fire();
                }
                else
                {
                    component.set("v.logRequest.OB_Status__c","Confermato");
                    component.set("v.logRequest.OB_StatusFormula__c","Confermato");
                    component.set("v.isConfirmButton", false )
                }
            }
        });
        $A.enqueueAction(action);
	}
})