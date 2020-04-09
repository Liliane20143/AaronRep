({
	retrieveServicePointDetails_helper : function(component, event, helper) 
	{
		console.log("recordid: "+component.get("v.recordId"));
		var action = component.get("c.getServicePointDetails");
		action.setParams({"logRequestId" : component.get("v.recordId")});	
		action.setCallback(this, function(response) 
		{
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                console.log('Success in getServicePointDetails');
                console.log('toReturn: ' + JSON.stringify(response.getReturnValue()));
                if(response.getReturnValue() != null)
                {
                	component.set("v.currentLogReq", response.getReturnValue());
                	component.set("v.showServicePointSection", true);
	            }
	            else
	            {
	            	console.log('aura if false');
	              	component.set("v.showServicePointSection", false);
	            }
            }
            else if (state === "INCOMPLETE") 
            {
             	console.log('Status incomplete');
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