({

	// Start AV 18/02/2019 defect Id #00001548 Hide button REMOVE if logrequest's status is In attesa. 
	getStateLogRequest : function(component, event, helper)
	{
		console.log("### getStateLogRequest");
		var listFields 	= component.get("v.listFields");
		var logRequestId = '';
		if (listFields.length>6)
		{
			logRequestId = listFields[6];
			console.log("### logRequestId: "+logRequestId);
			if(logRequestId != '' && logRequestId!=null && typeof logRequestId != 'undefined'){
				var action = component.get("c.getStateLogRequest");
				action.setParams({ "logRequestId" : logRequestId });
				action.setCallback(this, function(response){
					var state = response.getState();
					if (state === "SUCCESS")
					{
						var stateLogRequest = response.getReturnValue();
						console.log("### statusLog: " + stateLogRequest);
						var pending = $A.get("$Label.c.OB_MAINTENANCE_LOGREQUEST_STATUS_PENDING");
						if (stateLogRequest != null && stateLogRequest == pending)
						{
							component.set("v.canRemove", false);
						}
					}
				});
				$A.enqueueAction(action);
			}
		}	
	},
	// End AV 18/02/2019 defect Id #00001548

	/*
	*	Author		:		Morittu Andrea
	*	Date		:		21.08.2019
	*	Description	:		calling getTokenJWE method for document token
	*/

	getTokenJWE_Helper : function(component, event, helper, docId) {

		var documentName = '';
		var action = component.get("c.getTokenJWE");
		action.setParams({ documentName : docId });

		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {

				var response = response.getReturnValue();
				var token = response['jewToken'];
				var url;
				var listFields = component.get("v.listFields");
				var orderId = listFields[0];
				var salePoint = listFields[1];
				var merchant = listFields[2];
				var idToFilenet;
				console.log('TOKEN: ' + token);
				console.log('FE URL: ' + url);
				var token = response['jewToken'];				
				/*History: START 26-Aug-2019 - Fix on Document URL (in production org, salePoint and OrderId are fundamental) */
				url = response['FEurl'] + '/api/merchants/'+merchant+'/sales-points/'+salePoint+'/orders/'+orderId+'/documents/'+docId;
				/*History: END 26-Aug-2019 - Fix on Document URL (in production org, salePoint and OrderId are fundamental) */
				
				window.open('/apex/OpenDocumentsPage?params='+token+'?'+url);
			}
			else if (state === "INCOMPLETE") {
				
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

				let title 	= $A.get("$Label.c.OB_MAINTENANCE_TOASTERROR");
				let message = $A.get("$Label.c.OB_ServiceUnavailable");
				let type = 'error';
				helper.showToast(component, event, helper, title, message, type);

			}
		});
		$A.enqueueAction(action);
	},

	/*
	*	Author		:	Morittu Andrea		
	*	Date		:	2019.08.21
	*	Description	:	Function to create dynamically a toast mesage
	*/
	showToast: function (component, event, helper, title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
	},
	
})