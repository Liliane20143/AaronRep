({
		approvalProcess : function(component, event) {
		var recordId = component.get("v.accountId");
		var action = component.get("c.startApprovalProcess");

		action.setParams({
			"recordId": recordId
		});
		action.setCallback(this, function(response){
			var state = response.getState();
			if (state === "SUCCESS") {
			   console.log(" success!");
			   if(response.getReturnValue() != null){
				   component.set("v.listOfContacts", response.getReturnValue());   
				   
				}
		
			}
			else
			{
				console.log('ERROR retrieving contacts');
			}
		});
	$A.enqueueAction(action);
	}
})