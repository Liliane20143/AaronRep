({
	startApprovalProcessJS : function(component, event) {
		console.log('sono nel controller');
		var action = component.get("c.startApprovalProcess");
		
		action.setCallback(this, function(response){
			var state = response.getState();
			if (state === "SUCCESS") {
			   console.log(" success!");

			  
			}
			else
			{
				console.log('ERROR ');
			}
		});
	$A.enqueueAction(action);
	}
})